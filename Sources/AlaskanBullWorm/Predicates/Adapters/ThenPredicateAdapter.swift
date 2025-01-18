struct ThenPredicateAdapter<First: Predicate, Second: Predicate>: Predicate {
	let first: First
	let second: Second
	let requirements: InfixRequirements

	init(first: First, second: Second, requirements: InfixRequirements) {
		self.first = first
		self.second = second
		self.requirements = requirements
	}

	func take(from src: inout Substring) -> Substring? {
		let beforeFirst = src

		let firstResult = self.first.take(from: &src)
		if firstResult == nil, self.requirements.contains(.first) {
			src = beforeFirst
			return nil
		}

		let beforeSecond = src

		let secondResult = self.second.take(from: &src)
		if secondResult == nil, self.requirements.contains(.second) {
			if self.requirements.contains(.first) {
				src = beforeFirst
			} else {
				src = beforeSecond
			}
			return nil
		}

		return (firstResult ?? "") + (secondResult ?? "")
	}
}

public struct InfixRequirements: RawRepresentable, OptionSet {
	public let rawValue: UInt8

	public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}

	public static let first = Self(rawValue: 1 << 0)
	public static let second = Self(rawValue: 1 << 1)
	public static let both: Self = [.first, .second]
}

public extension Predicate {
	func then(_ second: some Predicate, require requirements: InfixRequirements = .both) -> some Predicate {
		ThenPredicateAdapter(first: self, second: second, requirements: requirements)
	}
}
