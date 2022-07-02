//
//  PublishersSequenceTests.swift
//  CombineItTests
//
//  Created by Barbara Rodeker on 2022-07-01.
//

import XCTest
import Combine

///
/// Apple Documentation: https://developer.apple.com/documentation/combine/publishers/sequence
///
class PublishersSequenceTests: XCTestCase {

    /// Testing subscribing to a sequence and asking for values one by one
    func testSequenceOneByOne() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "the sequence publisher must give the values one by one in order")
        
        // the initial sequence to create a Sequence Publisher
        let sequence = [1,2,3,4,5]
        
        // collect the values received
        var values: [Int] = []
        
        // create a sequence publisher and subscribe
        let subscription = Publishers.Sequence<[Int], Error>(sequence: sequence)
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        XCTFail("sequence failed to complete")
                }
                expectation.fulfill()
            } receiveValue: { value in
                values.append(value)
            }
        
        // wait for the publisher to give us the values
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        XCTAssertEqual(values.count, 5)
        XCTAssertEqual(values, sequence)
        
    }

    /// Testing subscribing to a sequence and asking for values one by one
    /// This time by creating the publisher from a sequence itself by appending ".publisher" to it
    func testSequenceOneByOneConvenientPublisherCreator() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "the sequence publisher must give the values one by one in order")
        
        // the initial sequence to create a Sequence Publisher
        let sequence = [1,2,3,4,5]
        
        // collect the values received
        var values: [Int] = []
        
        // create a sequence publisher and subscribe
        let subscription = sequence.publisher
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        XCTFail("sequence failed to complete")
                }
                expectation.fulfill()
            } receiveValue: { value in
                values.append(value)
            }
        
        // wait for the publisher to give us the values
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        XCTAssertEqual(values.count, 5)
        XCTAssertEqual(values, sequence)
        
    }


    /// Testing applying the method all satisfy to a sequence
    /// https://developer.apple.com/documentation/combine/publishers/sequence/allsatisfy(_:)
    func testSequenceAllSatisfy() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the initial sequence to create a Sequence Publisher
        let sequence = [1,2,3,4,5,6,8,34,56,9,24,7,18,5,3,7,9,3,5,9,2,44,0]
        
        // check if all elements of the sequence satisfy the condition of being multiple of 2
        var satisfy: Bool = true
        
        // create a sequence publisher and subscribe
        let subscription = Publishers.Sequence<[Int], Error>(sequence: sequence)
            .allSatisfy { values in
                return values.isMultiple(of: 2)
            }
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        XCTFail("")
                }
                expectation.fulfill()
            } receiveValue: { result in
                satisfy = result
            }

        // wait for the publisher to be processed by allSatisfy instance method
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        XCTAssertFalse(satisfy)
        
    }
    
    /// Testing applying the method append
    /// https://developer.apple.com/documentation/combine/publishers/sequence/append(_:)-2knh4
    func testSequenceAppendingSequence() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequences to create a Sequence Publisher
        let sequence1 = [1,2,3,4]
        let sequence2 = [1,2,3,4]

        // collect elements
        var values: [Int] = []
        
        // create a sequence publisher and subscribe
        let subscription = Publishers.Sequence<[Int], Error>(sequence: sequence1)
            .append(sequence2)
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        XCTFail("")
                }
                expectation.fulfill()
            } receiveValue: { number in
                values.append(number)
            }

        // wait for the publisher to be processed by allSatisfy instance method
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        XCTAssertEqual(values.count, 8)
        
    }
    

    /// Testing applying the instance method "collect"
    /// https://developer.apple.com/documentation/combine/publishers/sequence/append(_:)-2knh4
    /// collect waits for the publisher to complete. A PassthroughSubject doesn't automatically complete. You need to call send completion
    /// This allows for good combination of a Passthrough subject, waiting for tasks to complete, and then calling send completion, will trigger the collect
    func testSequenceCollect() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "The publisher will give us values in 1 shot")
        
        // the sequence to create a Sequence Publisher
        let sequence = [1,2,3,4]

        // to assign the sequence received
        var values: [Int] = []
        
        // create a sequence publisher and subscribe
        let subscription = Publishers.Sequence<[Int], Error>(sequence: sequence)
            .collect()
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        XCTFail()
                }
                expectation.fulfill()
            } receiveValue: { sequenceIn in
                values = sequenceIn
            }


        // wait for the publisher to be processed by allSatisfy instance method
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        XCTAssertEqual(values.count, 4)
        
    }
    

    ///  It transforms the elements of its upstream publisher and excludes nil values
    ///  https://developer.apple.com/documentation/combine/publishers/sequence/compactmap(_:)-94a6k
    func testSequenceCompactMap() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequence to create a Sequence Publisher
        let sequence = [1,2,3,4, nil, 9, nil]

        // to assign the sequence received
        var values: [Int] = []
        
        // create a sequence publisher and subscribe
        let subscription = Publishers.Sequence<[Int?], Error>(sequence: sequence)
            .compactMap { $0 }
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        XCTFail()
                }
                expectation.fulfill()
            } receiveValue: { value in
                values.append(value)
            }



        // wait for the publisher to be processed by allSatisfy instance method
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        XCTAssertEqual(values.count, 5)
        
    }
    
    /// https://developer.apple.com/documentation/combine/publishers/sequence/count()-5rrw2
    func testSequenceCount() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequence to create a Sequence Publisher
        let sequence = [1,2,3,4, nil, 9, nil]

        // to assign the amount of elements in the array
        var count: Int = 0
        
        // create a sequence publisher and subscribe
        let subscription = Publishers.Sequence<[Int?], Error>(sequence: sequence)
            .count()
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        XCTFail()
                }
                expectation.fulfill()
            } receiveValue: { value in
                count = value
            }



        // wait for the publisher to be processed by allSatisfy instance method
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        XCTAssertEqual(count, 7)
        
    }
    

    /// Testing drop while https://developer.apple.com/documentation/combine/publishers/sequence/drop(while:)
    /// And inspecting the struct class DropWhileSequence https://developer.apple.com/documentation/Swift/DropWhileSequence
    /// A sequence that lazily consumes and drops n elements from an underlying Base iterator before possibly returning the first available element.
    func testSequenceDropWhile() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequence to create a Sequence Publisher
        let sequence = [1,2,3,4, nil, 9, nil]

        // to assign the sequence received
        var values: [Int] = []
        
        // create a sequence publisher and subscribe
        let subscription = Publishers.Sequence<[Int?], Error>(sequence: sequence)
            .drop(while: { value in
                value != nil
            })
            .compactMap{ $0 }
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        XCTFail()
                }
                expectation.fulfill()
            } receiveValue: { value in
                values.append(value)
            }



        // wait for the publisher to be processed by allSatisfy instance method
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        XCTAssertEqual(values.count, 1)
        
    }
    
    /// https://developer.apple.com/documentation/combine/publishers/sequence/dropfirst(_:)
    /// https://developer.apple.com/documentation/Swift/DropFirstSequence
    /// DropFirstSequence
    /// A sequence that lazily consumes and drops n elements from an underlying Base iterator before possibly returning the first available element.
    func testSequenceDropFirst() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequence to create a Sequence Publisher
        let sequence = [1,2,3,4, nil, 9, nil]

        // to assign the sequence received
        var values: [Int?] = []
        
        // create a sequence publisher and subscribe
        let subscription = Publishers.Sequence<[Int?], Error>(sequence: sequence)
            .dropFirst(1)
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        XCTFail()
                }
                expectation.fulfill()
            } receiveValue: { value in
                values.append(value)
            }



        // wait for the publisher to be processed by allSatisfy instance method
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        XCTAssertEqual(values.count, 6)
        
    }
    



}
