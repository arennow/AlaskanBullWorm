public struct ExactStringPredicate: Predicate {
	public let needle: String

	public init(_ needle: String) {
		self.needle = needle
	}

	public func take(from src: inout Substring) -> Substring? {
		guard src.hasPrefix(self.needle) else { return nil }
		src.removeFirst(self.needle.count)
		return self.needle[...]
	}
}
