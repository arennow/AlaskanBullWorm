import Algorithms

public struct AlaskanBullWorm {
	public typealias Predicate = (Character) -> Bool

	public private(set) var remainder: Substring

	public init(_ initial: some StringProtocol) {
		self.remainder = Substring(initial)
	}

	private mutating func take(predicate: Predicate) -> Substring? {
		var rangeEndIndex = self.remainder.startIndex

		let indexSequence = chain(self.remainder.indices.dropFirst(), CollectionOfOne(self.remainder.endIndex))
		for (i, c) in zip(indexSequence, self.remainder) {
			if predicate(c) {
				rangeEndIndex = i
			} else {
				break
			}
		}

		guard rangeEndIndex > self.remainder.startIndex else {
			return nil
		}

		let takenRange = self.remainder.startIndex..<rangeEndIndex

		let outSubstring = self.remainder[takenRange]
		self.remainder.removeSubrange(takenRange)
		return outSubstring
	}

	@discardableResult
	public mutating func takeVisible() -> Substring? {
		self.take(predicate: !\.isWhitespace)
	}

	@discardableResult
	public mutating func takeWhitespaces() -> Substring? {
		self.take(predicate: \.isWhitespace)
	}

	@discardableResult
	public mutating func takeSpacedVisible() -> Substring? {
		self.takeWhitespaces()
		return self.takeVisible()
	}

	@discardableResult
	public mutating func takeChar(_ c: Character) -> Substring? {
		self.take(predicate: { $0 == c })
	}

	@discardableResult
	public mutating func takeWrapped(l: Character, r: Character, innerPredicate: Predicate) -> Substring? {
		let before = self
		func restore() { self = before }

		let compositePredicate: Predicate = { c in
			c != r && innerPredicate(c)
		}

		guard self.takeChar(l) != nil,
			  let out = self.take(predicate: compositePredicate),
			  self.takeChar(r) != nil
		else {
			restore()
			return nil
		}

		return out
	}
}
