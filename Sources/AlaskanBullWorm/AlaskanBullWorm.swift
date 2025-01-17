import Algorithms

public struct AlaskanBullWorm {
	public typealias RawPredicate = (Character) -> Bool

	public private(set) var remainder: Substring

	public init(_ initial: some StringProtocol) {
		self.remainder = Substring(initial)
	}

	@discardableResult
	public mutating func take(_ predicate: Predicate) -> Substring? {
		self.take(predicate.rawPredicate)
	}

	@discardableResult
	public mutating func take(_ rawPredicate: RawPredicate) -> Substring? {
		var rangeEndIndex = self.remainder.startIndex

		let indexSequence = chain(self.remainder.indices.dropFirst(), CollectionOfOne(self.remainder.endIndex))
		for (i, c) in zip(indexSequence, self.remainder) {
			if rawPredicate(c) {
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
	@available(*, deprecated, message: "Clearly on its way out")
	public mutating func takeSpacedVisible() -> Substring? {
		self.take(.whitespace)
		return self.take(.visible)
	}

	@discardableResult
	public mutating func takeWrapped(l: Character, r: Character, innerPredicate: Predicate) -> Substring? {
		let before = self
		func restore() { self = before }

		let compositePredicate: RawPredicate = { c in
			c != r && innerPredicate.rawPredicate(c)
		}

		guard self.take(.char(l)) != nil,
			  let out = self.take(compositePredicate),
			  self.take(.char(r)) != nil
		else {
			restore()
			return nil
		}

		return out
	}
}
