public struct AnyParser<Output>: Parser {
	public let innerParsers: [any Parser<Output>]

	public init(_ parsers: any Parser<Output>...) {
		self.innerParsers = parsers
	}

	public init(_ parsers: Array<any Parser<Output>>) {
		self.innerParsers = parsers
	}

	public func parse(_ input: inout Substring) -> Output? {
		for parser in self.innerParsers {
			if let out = parser.parse(&input) {
				return out
			}
		}
		return nil
	}
}

infix operator <||>: AdditionPrecedence

@_disfavoredOverload
public func <||> <T>(lhs: some Parser<T>, rhs: some Parser<T>) -> AnyParser<T> {
	AnyParser(lhs, rhs)
}

public func <||> <T>(lhs: AnyParser<T>, rhs: any Parser<T>) -> AnyParser<T> {
	AnyParser(lhs.innerParsers + [rhs])
}
