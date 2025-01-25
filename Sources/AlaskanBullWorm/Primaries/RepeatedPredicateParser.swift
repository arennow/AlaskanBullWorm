import Algorithms

struct RepeatedPredicateParser: Parser {
	let predicate: @Sendable (Character) -> Bool

	init(_ predicate: @Sendable @escaping (Character) -> Bool) {
		self.predicate = predicate
	}

	init(_ intoPred: some IntoPredicate) {
		self.init(intoPred.into())
	}

	public func parse(_ src: inout Substring) throws -> Substring? {
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

protocol IntoPredicate {
	func into() -> @Sendable (Character) -> Bool
}
