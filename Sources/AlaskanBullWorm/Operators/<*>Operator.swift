infix operator <*>: AdditionPrecedence

public func <*> <I, O>(lhs: any Parser<I>, rhs: @escaping (I) -> O?) -> some Parser<O> {
	InlineParser { input in
		lhs.parse(&input).flatMap(rhs)
	}
}
