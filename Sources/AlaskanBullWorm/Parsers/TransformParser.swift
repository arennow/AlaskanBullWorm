public struct TransformParser<Output>: Parser {
	public let predicate: any Predicate
	public let transform: Transform<Output>

	public init(predicate: any Predicate, transform: @escaping Transform<Output>) {
		self.predicate = predicate
		self.transform = transform
	}

	public func parse(_ input: inout Substring) -> Output? {
		let before = input

		let out = self.predicate.parse(&input).flatMap(self.transform)
		if out == nil {
			// Just roll back
			input = before
		}
		return out
	}

	public func callAsFunction(_ input: inout Substring) -> Output? {
		self.parse(&input)
	}
}

infix operator <*>: AdditionPrecedence

public func <*> <T>(lhs: any Predicate, rhs: @escaping Transform<T>) -> TransformParser<T> {
	.init(predicate: lhs, transform: rhs)
}
