//
//  API.swift
//  CombineIt
//
//  Created by Barbara Rodeker on 2022-05-24.
//
import Foundation
import Combine

// MARK: - EndPoint

/// String enumeration to define the URLs required for each API call
enum EndPoint {
    case getBooks(listName: String)
    
    var url: URL? {
        switch self {
            case .getBooks(let listName):
                let urlString = "https://api.nytimes.com/svc/books/v3/lists.json?api-key=aL8oZVKrC1kVxRy8PMXsf9lElTdWU5BT&list="
                
                guard let encodedListName = listName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
                        let url = URL(string: urlString + encodedListName) else {
                    return nil
                }
                
                return url
        }
    }
}

// MARK: - APIError

/// Error processing
enum APIError: Error {
    case generalConnectionError
    case invalidRequest
    case invalidResponse
    case validationError(message:String)
}

// MARK: - APIErrorMessage

/// Which information is contained in a HTTP failed response
struct APIErrorMessage: Decodable {
  var error: Bool
  var reason: String
}

// MARK: - APIProtocol

protocol APIProtocol {
    
    func getBooks() -> AnyPublisher<BooksWrapper, APIError>
}

// MARK: - API

struct API: APIProtocol {
    
    /// Session to perform requests
    let urlSession = URLSession.shared
    
    /// Parser of responses
    private let decoder = JSONDecoder()
    
    func getBooks() -> AnyPublisher<BooksWrapper, APIError> {
        
        guard let url = EndPoint.getBooks(listName: "Combined Print and E-Book Fiction").url else {
            return Fail(error: APIError.invalidRequest)
                .eraseToAnyPublisher()
        }
        
        return urlSession
            .dataTaskPublisher(for: url)
            .mapError({ error  in
                return APIError.generalConnectionError
            })
            .tryMap() { element -> Data in
                
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw URLError((URLError.Code.badServerResponse))
                }
                    
                guard (200..<300) ~= httpResponse.statusCode else {
 
                    if httpResponse.statusCode == 400 {
                        let apiError = try decoder.decode(APIErrorMessage.self,
                                                          from: element.data)
                        throw APIError.validationError(message: apiError.reason)
                    }
                    throw APIError.validationError(message: "")
                }
                return element.data
            }
            .decode(type: BooksWrapper.self, decoder: decoder)
            .mapError({ error  in
                return APIError.generalConnectionError
            })
            .eraseToAnyPublisher()

    }
    
}



