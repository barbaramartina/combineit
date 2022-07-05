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

        // wait for the publisher to be processed
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

        // wait for the publisher to be processed
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

        // wait for the publisher to be processed
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


        // wait for the publisher to be processed
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

        // wait for the publisher to be processed
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

        // wait for the publisher to be processed
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

        // wait for the publisher to be processed
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        XCTAssertEqual(values.count, 6)
        
    }
    
    /// filter operation is also available as a publisher operator
    /// https://developer.apple.com/documentation/combine/publishers/sequence/filter(_:)
    func testSequenceFilter() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequence to create a Sequence Publisher
        let sequence = [1,2,3,4]

        // to assign the sequence received
        var values: [Int?] = []
        
        // create a sequence publisher and subscribe
        let subscription = sequence.publisher
            .filter { $0.isMultiple(of: 3) }
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

        // wait for the publisher to be processed
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        XCTAssertEqual(values.count, 1)
        
    }
    
    /// Used for when you are not interested in the values produced by a publisher, but you want to know when it finishes, and then
    /// check if there was an error or a succesfull termination
    /// https://developer.apple.com/documentation/combine/publishers/sequence/ignoreoutput()
    func testSequenceIgnoreOutput() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequence to create a Sequence Publisher
        let sequence = [1,2,3,4]

        // to assign the sequence received
        var values: [Int?] = []
        
        // create a sequence publisher and subscribe
        let subscription = sequence.publisher
            .ignoreOutput()
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

        // wait for the publisher to be processed
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        // the value closure should never be called
        XCTAssertEqual(values.count, 0)
        
    }
    
    /// this is an easy one, where you get the first element of the sequence, if any
    /// https://developer.apple.com/documentation/combine/publishers/sequence/first()-70lwp
    /// It can be used with a filter, to choose the first element which fullfil a confition
    /// https://developer.apple.com/documentation/combine/publishers/sequence/first(where:)-6o4zh
    func testSequenceFirst() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequence to create a Sequence Publisher
        let sequence = [1,2,3,4]

        // to assign the sequence received
        var values: [Int?] = []
        
        // create a sequence publisher and subscribe
        let subscription = sequence.publisher
            .first()
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


        // wait for the publisher to be processed
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        // only the first value should be received
        XCTAssertEqual(values.count, 1)
        
    }
    
    /// this is an easy one, where you get the last element of the sequence, if any
    /// https://developer.apple.com/documentation/combine/publishers/sequence/last()-66x9v
    /// Can also be used in combination with a confition
    /// https://developer.apple.com/documentation/combine/publishers/sequence/last(where:)-33v3b
    func testSequenceLast() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequence to create a Sequence Publisher
        let sequence = [1,2,3,4]

        // to assign the sequence received
        var values: [Int?] = []
        
        // create a sequence publisher and subscribe
        let subscription = sequence.publisher
            .last()
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

        // wait for the publisher to be processed
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        // only the first value should be received
        XCTAssertEqual(values.count, 1)
        
    }
    
    /// Transform each element into another type of element and return a puiblisher which has a sequence as value with the new
    /// type of returned value
    /// https://developer.apple.com/documentation/combine/publishers/sequence/map(_:)-nh4n
    func testSequenceMap() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequence to create a Sequence Publisher
        let sequence = [1,2,3,4]

        // to assign the sequence received
        var values: [Int?] = []
        
        // create a sequence publisher and subscribe
        let subscription = sequence.publisher
            .map { $0 * 2 }
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


        // wait for the publisher to be processed
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        // only the first value should be received
        XCTAssertEqual(values.count, 4)
        
    }
    
    /// Max By: allows to pick the maximum value from a sequence based on an individually defined comparission
    /// For example when you have a complex struct, and want to determine some sort of sorting based on 1 property of the struct
    /// Like for example age.
    /// https://developer.apple.com/documentation/combine/publishers/sequence/max(by:)-1eehr
    /// this related to the simpler version MAX: https://developer.apple.com/documentation/combine/publishers/sequence/max()-3ikh2
    /// to MIN: https://developer.apple.com/documentation/combine/publishers/sequence/min()-9fdvw
    /// and MIN BY: https://developer.apple.com/documentation/combine/publishers/sequence/min(by:)-oi91
    func testSequenceMaxBy() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        struct Example {
            let id: String
            let rounds: Int
        }
        
        // the sequence to create a Sequence Publisher
        let sequence = [Example(id: "1", rounds: 4), Example(id: "3", rounds: 100)]

        // to assign the sequence received
        var values: [Example] = []
        
        // create a sequence publisher and subscribe
        let subscription = sequence.publisher
            .max(by: { lhs, rhs in
                /// this case would be more clear if we would have an struct for e
                return lhs.rounds > rhs.rounds
            })
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


        // wait for the publisher to be processed
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        // only the first value should be received
        XCTAssertEqual(values.count, 1)
        
    }
    
    /// Permits to choose 1 element from the sequence publisher, or a range of elements
    /// If the publisher finishes before the values are received, then the subscriber receives .finished
    /// https://developer.apple.com/documentation/combine/publishers/sequence/output(at:)-3r7zo
    func testSequenceOutput() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequence to create a Sequence Publisher
        let sequence = [1,2,3,4,5,6,7]

        // to assign the sequence received
        var values: [Int] = []
        
        // create a sequence publisher and subscribe
        let subscription = sequence.publisher
            .output(in: 5...20)
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

        // wait for the publisher to be processed
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        // only 6 and 7 should be received and then the publisher should complete
        XCTAssertEqual(values.count, 2)
        
    }
    
    /// Selects the first N elements of a sequence
    /// https://developer.apple.com/documentation/combine/publishers/sequence/prefix(_:)
    /// https://developer.apple.com/documentation/combine/publishers/sequence/prefix(while:)
    func testSequencePrefix() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequence to create a Sequence Publisher
        let sequence = [1,2,3,4,5,6,7]

        // to assign the sequence received
        var values: [Int] = []
        
        // create a sequence publisher and subscribe
        let subscription = sequence.publisher
            .prefix(2)
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

        // wait for the publisher to be processed
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        // only the first 2 values should be received
        XCTAssertEqual(values.count, 2)
        
    }
    

    /// Connect 2 publishers (with same input and output together
    /// delivering all elements from the first one and then from the second one
    /// This could be useful when you have 2 APIs call returning a set of date, then you can have a map on both APIs responses
    /// make the items of the same type, then use prepend to deliver them together
    /// https://developer.apple.com/documentation/combine/publishers/sequence/prepend(_:)-1r564
    func testSequencePrepend() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequence to create a Sequence Publisher
        let sequence1 = [1,2,3,4]
        let sequence2 = [5,6,7]

        // to assign the sequence received
        var values: [Int] = []
        
        // create a sequence publisher and subscribe
        let subscription = sequence1.publisher
            .prepend(sequence2)
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

        // wait for the publisher to be processed
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        // only the first 2 values should be received
        XCTAssertEqual(values.count, 7)
        
    }
    
    /// Proccesses all the elements and produce 1 output value
    /// For example: reading all bank transactions of the last week and calculating the total amount of money spent
    /// https://heckj.github.io/swiftui-notes/#reference-output
    func testSequenceReduce() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequence to create a Sequence Publisher
        let sequence = [1,2,3,4]

        // to assign the sequence received
        var finalValue: Int = 0
        
        // create a sequence publisher and subscribe
        let initialValue = 0
        let subscription = sequence.publisher
            .reduce( initialValue, { acc, current in
                acc + current
            })
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        XCTFail()
                }
                expectation.fulfill()
            } receiveValue: { value in
                finalValue = value
            }



        // wait for the publisher to be processed
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        // should return the sum of all elements
        XCTAssertEqual(finalValue, 10)
        
    }
    
    /// just removes the duplicated items
    /// https://developer.apple.com/documentation/combine/publishers/sequence/removeduplicates()-2uq6m
    func testSequenceRemoveDuplicates() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequence to create a Sequence Publisher
        let sequence = [1,2,3,4,1,1,1]

        // to assign the sequence received
        var values: [Int] = []
        
        // create a sequence publisher and subscribe
        let subscription = sequence.publisher
            .removeDuplicates()
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



        // wait for the publisher to be processed
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        // only 4 elements should persist after the removal of duplictes
        XCTAssertEqual(values.count, 4)
        
    }
    

    /// Replace the NIL elements with an element of the same type as the initial elements of the sequence
    /// https://developer.apple.com/documentation/combine/publishers/sequence/replacenil(with:)-4cqz2
    func testSequenceReplaceNil() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequence to create a Sequence Publisher
        let sequence = [1,2,3,4,nil]

        // to assign the sequence received
        var values: [Int?] = []
        
        // create a sequence publisher and subscribe
        let subscription = sequence.publisher
            .replaceNil(with: 0)
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



        // wait for the publisher to be processed
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        // 5 elements should exist still in the array, after nil is converted to 0
        XCTAssertEqual(values.count, 5)
        
    }
    
    func testSequenceScan() {
        
        // expect for the values to be received
        let expectation = XCTestExpectation(description: "")
        
        // the sequence to create a Sequence Publisher
        let sequence = ["H", "E", "I"]

        // to assign the sequence received
        var values: [String] = []
        
        // create a sequence publisher and subscribe
        let subscription = sequence.publisher
            .scan("", { acc, current in
                acc + current
            })
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



        // wait for the publisher to be processed
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(subscription)
        // All intermediate results are pushed by scan, till the sequence is completed
        XCTAssertEqual(values[0], "H")
        XCTAssertEqual(values[1], "HE")
        XCTAssertEqual(values[2], "HEI")

    }
    


}
