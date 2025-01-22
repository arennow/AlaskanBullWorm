public extension Parser {
	func drop(allowFailures: Bool = true) -> some Parser<Void> {
		InlineParser { input in
			if self.parse(&input) != nil || allowFailures {
				return ()
			} else {
				return nil
			}
		}
	}
}
