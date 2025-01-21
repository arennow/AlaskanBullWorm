public struct TransformParser<Input, Output>: Parser {
	public let predicate: any Parser<Input>
	public let transform: (Input) -> Output?

	public init(predicate: any Parser<Input>, transform: @escaping (Input) -> Output?) {
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

public func <*> <I, O>(lhs: any Parser<I>, rhs: @escaping (I) -> O?) -> TransformParser<I, O> {
	.init(predicate: lhs, transform: rhs)
}
