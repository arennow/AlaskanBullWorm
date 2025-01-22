public extension Parser {
	func drop<O>(allowFailures: Bool = false, replacement: O = Substring()) -> some Parser<O> {
		InlineParser { input in
			if self.parse(&input) != nil || allowFailures {
				return replacement
			} else {
				return nil
			}
		}
	}
}
