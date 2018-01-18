//
//  CollectionExtensions.swift
//  SwifterSwift
//
//  Created by Sergey Fedortsov on 19.12.16.
//  Copyright © 2016 SwifterSwift
//

// MARK: - Methods
public extension Collection {
	
	private func indicesArray() -> [Self.Index] {
		var indices: [Self.Index] = []
		var anIndex = startIndex
		while anIndex != endIndex {
			indices.append(anIndex)
			anIndex = index(after: anIndex)
		}
		return indices
	}
	
	/// SwifterSwift: Performs `each` closure for each element of collection in parallel.
	///
	///		array.forEachInParallel { item in
	///			print(item)
	///		}
	///
	/// - Parameter each: closure to run for each element.
	public func forEachInParallel(_ each: (Self.Iterator.Element) -> Void) {
		let indices = indicesArray()
		
		DispatchQueue.concurrentPerform(iterations: indices.count) { (index) in
			let elementIndex = indices[index]
			each(self[elementIndex])
		}
	}
	
	/// SwifterSwift: Safe protects the array from out of bounds by use of optional.
	///
	///		let arr = [1, 2, 3, 4, 5]
	///		arr[safe: 1] -> 2
	///		arr[safe: 10] -> nil
	///
	/// - Parameter index: index of element to access element.
	public subscript(safe index: Index) -> Iterator.Element? {
		return indices.contains(index) ? self[index] : nil
	}

	/// SwifterSwift: Separates an array into 2 arrays based on a predicate.
	///
	///     [0, 1, 2, 3, 4, 5].divided { $0 % 2 == 0 } -> ( [0, 2, 4], [1, 3, 5] )
	///
	/// - Parameter condition: condition to evaluate each element against.
	/// - Returns: Two arrays, the first containing the elements for which the specified condition evaluates to true, the second containing the rest.
	public func divided2(by condition: (Iterator.Element) throws -> Bool) rethrows -> (matching: [Iterator.Element], nonMatching: [Iterator.Element]) {
		//Inspired by: http://ruby-doc.org/core-2.5.0/Enumerable.html#method-i-partition
		var matching: [Iterator.Element] = []
		var nonMatching: [Iterator.Element] = []
		for element in self {
			if try condition(element) {
				matching.append(element)
			} else {
				nonMatching.append(element)
			}
		}
		return (matching, nonMatching)
	}

}

// MARK: - Methods (Int)
public extension Collection where Index == Int, IndexDistance == Int {
	
	/// SwifterSwift: Random item from array.
	public var randomItem: Iterator.Element {
		let index = Int(arc4random_uniform(UInt32(count)))
		return self[index]
	}
	
}

// MARK: - Methods (Integer)
public extension Collection where Iterator.Element == Int, Index == Int {
	
	/// SwifterSwift: Average of all elements in array.
	///
	/// - Returns: the average of the array's elements.
	public func average() -> Double {
		// http://stackoverflow.com/questions/28288148/making-my-function-calculate-average-of-array-swift
		return isEmpty ? 0 : Double(reduce(0, +)) / Double(endIndex-startIndex)
	}
	
}
