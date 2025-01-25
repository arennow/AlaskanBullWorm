public struct __AnySubParser<Output>: Parser {
	let innerParsers: [any Parser<Output>]

	public func parse(_ input: inout Substring) throws -> Output? {
		for parser in self.innerParsers {
			if let out = try parser.parse(&input) {
				return out
			}
		}
		return nil
	}
}

infix operator <||>: AdditionPrecedence

@_disfavoredOverload
public func <||> <T>(lhs: any Parser<T>, rhs: any Parser<T>) -> __AnySubParser<T> {
	__AnySubParser(innerParsers: [lhs, rhs])
}

public func <||> <T>(lhs: __AnySubParser<T>, rhs: any Parser<T>) -> __AnySubParser<T> {
	__AnySubParser(innerParsers: lhs.innerParsers + CollectionOfOne(rhs))
}
