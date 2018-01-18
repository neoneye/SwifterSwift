//
//  CollectionExtensionsTests.swift
//  SwifterSwift
//
//  Created by Omar Albeik on 09/02/2017.
//  Copyright © 2017 SwifterSwift
//

import XCTest
@testable import SwifterSwift

final class CollectionExtensionsTests: XCTestCase {
	
	func testForEachInParallel() {
		let collection = [1, 2, 3, 4, 5]
		collection.forEachInParallel { item in
			XCTAssert(collection.contains(item))
		}
	}
	
	func testSafeSubscript() {
		let collection = [1, 2, 3, 4, 5]
		XCTAssertNotNil(collection[safe: 2])
		XCTAssertEqual(collection[safe: 2], 3)
		XCTAssertNil(collection[safe: 10])
	}
	
	func testDivided() {
		do {
			let input = [0, 1, 2, 3, 4, 5]
			let (even, odd) = input.divided2 { $0 % 2 == 0 }
			XCTAssertEqual(even, [0, 2, 4])
			XCTAssertEqual(odd, [1, 3, 5])

			// Parameter names + indexes
			let tuple = input.divided2 { $0 % 2 == 0 }
			XCTAssertEqual(tuple.matching, [0, 2, 4])
			XCTAssertEqual(tuple.0, [0, 2, 4])
			XCTAssertEqual(tuple.nonMatching, [1, 3, 5])
			XCTAssertEqual(tuple.1, [1, 3, 5])
		}

		do {
			let input: [String: Int] = ["a": 0, "b": 1, "c": 2, "d": 3, "e": 4, "f": 5]
			let tuple = input.divided2 { (_, value) in value % 2 == 0 }
			/// The tuple contains the following:
			///
			///     (
			///         matching: [(key: "e", value: 4), (key: "a", value: 0), (key: "c", value: 2)],
			///         nonMatching: [(key: "b", value: 1), (key: "f", value: 5), (key: "d", value: 3)]
			///     )

			var matchingDict = [String: Int]()
			for (key, value) in tuple.matching {
				matchingDict[key] = value
			}
			XCTAssertEqual(matchingDict, ["a": 0, "c": 2, "e": 4])

			var nonMatchingDict = [String: Int]()
			for (key, value) in tuple.nonMatching {
				nonMatchingDict[key] = value
			}
			XCTAssertEqual(nonMatchingDict, ["b": 1, "d": 3, "f": 5])
		}
	}

}
