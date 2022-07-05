//
//  CollectPublisherTests.swift
//  CombineItTests
//
//  Created by Barbara Rodeker on 2022-07-05.
//

import XCTest
import Combine

class CollectPublisherTests: XCTestCase {

    /// https://developer.apple.com/documentation/combine/publishers/collect
    /// this version of collect will keep in memory all elements received from another publisher until it receives a completion
    /// this goes well with a Passthrough Subject.
    /// After a completion is sent, collect will send dowstream all the element accumulated.
    /// This could be useful for when an array of heavy parsed elements have to be generated, so the parsing
    /// can be thrown to different tasks and when all are done, a completion can be called.
    func testCollectSimple() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequence to create a Sequence Publisher
        let sequence = ["H", "E", "I"]

        // to assign the sequence received
        var values: [String] = []
        
        // create a sequence publisher and subscribe
        let subscription = sequence.publisher
            .collect()
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        XCTFail()
                }
                expectation.fulfill()
            } receiveValue: { valuesCollected in
                values = valuesCollected
            }



        // wait for the publisher to be processed
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        // All values should be received at the en
        XCTAssertEqual(values[0], "H")
        XCTAssertEqual(values[1], "E")
        XCTAssertEqual(values[2], "I")

        
    }

}
