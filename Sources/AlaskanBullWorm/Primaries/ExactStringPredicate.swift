public func exact(_ string: some StringProtocol & Sendable) -> some Parser<Substring> {
	InlineParser { input in
		guard input.hasPrefix(string) else { return nil }
		input.removeFirst(string.count)
		return Substring(string)
	}
}
