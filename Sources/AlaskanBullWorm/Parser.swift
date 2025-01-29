public protocol Parser<Output>: Sendable {
	associatedtype Output

	func parse(_ input: inout Substring) throws -> Output?
}

public extension Parser {
	func drop(allowFailures: Bool) -> some Parser<Void> {
		InlineParser { input in
			if try self.parse(&input) != nil || allowFailures {
				return ()
			} else {
				return nil
			}
		}
	}

	func optional() -> some Parser<Substring> where Output == Substring {
		InlineParser { input in
			try self.parse(&input) ?? ""
		}
	}
}
