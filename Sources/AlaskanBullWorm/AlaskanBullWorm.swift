import Algorithms

public struct AlaskanBullWorm {
	public private(set) var remainder: Substring

	public init(_ initial: some StringProtocol) {
		self.remainder = Substring(initial)
	}

	private mutating func take(predicate: (Character) -> Bool) -> Substring? {
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
	public mutating func takeNonWhitespaces() -> Substring? {
		self.take(predicate: !\.isWhitespace)
	}

	@discardableResult
	public mutating func takeWhitespaces() -> Substring? {
		self.take(predicate: \.isWhitespace)
	}
}
