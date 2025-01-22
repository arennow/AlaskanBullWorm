public struct ExactStringPredicate: Parser {
	public let needle: String

	public init(_ needle: String) {
		self.needle = needle
	}

	public func parse(_ src: inout Substring) -> Substring? {
		guard src.hasPrefix(self.needle) else { return nil }
		src.removeFirst(self.needle.count)
		return self.needle[...]
	}
}
