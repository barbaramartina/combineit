//
//  Book.swift
//  CombineIt
//
//  Created by Barbara Rodeker on 2022-05-24.
//

import Foundation
import Combine

/// The New York Time APIs is used to read a list of book
/// and parse them into a custom defined BOOK object.
/// https://any-api.com/nytimes_com/books_api/docs/_lists_format_/GET_lists_format
/// Book is decodable, so it can be parsed from a publishers on URLSessions
class Book: ObservableObject, Decodable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case amazonURL = "amazon_product_url"
        case name = "display_name"
    }
    
    var id: String {
        return name
    }
    
    @Published var amazonURL: String
    @Published var name: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        amazonURL = try container.decode(String.self, forKey: .amazonURL)
        name = try container.decode(String.self, forKey: .name)
    }

 
    
        
}

