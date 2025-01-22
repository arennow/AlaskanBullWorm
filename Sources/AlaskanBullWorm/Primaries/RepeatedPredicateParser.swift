import Algorithms

public struct RepeatedPredicateParser: Parser {
	let predicate: (Character) -> Bool

	init(_ predicate: @escaping (Character) -> Bool) {
		self.predicate = predicate
	}

	init(_ intoPred: some IntoPredicate) {
		self.init(intoPred.into())
	}

	public func parse(_ src: inout Substring) -> Substring? {
		var rangeEndIndex = src.startIndex

		let indexSequence = chain(src.indices.dropFirst(), CollectionOfOne(src.endIndex))
		for (i, c) in zip(indexSequence, src) {
			if self.predicate(c) {
				rangeEndIndex = i
			} else {
				break
			}
		}

		guard rangeEndIndex > src.startIndex else {
			return nil
		}

		let takenRange = src.startIndex..<rangeEndIndex

		let outSubstring = src[takenRange]
		src.removeSubrange(takenRange)
		return outSubstring
	}
}

public protocol IntoPredicate {
	func into() -> (Character) -> Bool
}
