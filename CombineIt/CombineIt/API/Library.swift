//
//  Library.swift
//  CombineIt
//
//  Created by Barbara Rodeker on 2022-05-24.
//

import Foundation
import Combine

/// Simple class holding an array of books
class Library: ObservableObject {
    
    // MARK: - Properties
    
    /// a list of books read from the Ney York Times API
    @Published var books: [Book]? = [Book]()
    
    /// an API for making requests
    private var api: APIProtocol
    
    /// holds a reference to the getBooks Data Task publisher
    private var booksCancellable: AnyCancellable?
    
    // MARK: - Functions
    
    init(with api: APIProtocol) {
        self.api = api
    }
    
    /// Ask to the network layer for a bunch of new books
    func loadBooks() {
        
        // cancel any outgoing request to avoid multiple requests at the same time
        self.booksCancellable?.cancel()
        
        // Create a new publisher which request books from the NYTime API
        self.booksCancellable = api.getBooks()
            // receive it on the Main Queue to make sure any UI update work properly
            .receive(on: DispatchQueue.main)
            // read the completion and release the publisher
            .sink(receiveCompletion: { [weak self] _ in
                self?.booksCancellable = nil
            // receive the value and store it into the book property
            }, receiveValue: { [weak self] booksWrapper in
                self?.books = booksWrapper.results
                self?.booksCancellable = nil
            })
    }
}
