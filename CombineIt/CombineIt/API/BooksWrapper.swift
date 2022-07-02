//
//  BooksWrapper.swift
//  CombineIt
//
//  Created by Barbara Rodeker on 2022-05-25.
//

import Foundation
import Combine


class BooksWrapper: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    private(set) var results: [Book]?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.results = try container.decode([Book].self, forKey: .results)

    }

   
    
}
