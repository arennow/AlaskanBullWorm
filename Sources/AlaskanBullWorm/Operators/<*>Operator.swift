infix operator <*>: AdditionPrecedence

public func <*> <I, O>(lhs: any Parser<I>, rhs: @escaping (I) -> O?) -> some Parser<O> {
	InlineParser { input in
		lhs.parse(&input).flatMap(rhs)
	}
}

public func <*> <I1, I2, O>(lhs: (some Parser<I1>, some Parser<I2>), rhs: @escaping (I1, I2) -> O?) -> some Parser<O> {
	InlineParser { input in
		guard
			let i1 = lhs.0.parse(&input),
			let i2 = lhs.1.parse(&input)
		else { return nil }
		return rhs(i1, i2)
	}
}

public func <*> <I1, I2, I3, O>(lhs: (some Parser<I1>, some Parser<I2>, some Parser<I3>), rhs: @escaping (I1, I2, I3) -> O?) -> some Parser<O> {
	InlineParser { input in
		guard
			let i1 = lhs.0.parse(&input),
			let i2 = lhs.1.parse(&input),
			let i3 = lhs.2.parse(&input)
		else { return nil }
		return rhs(i1, i2, i3)
	}
}

public func <*> <I1, I2, I3, I4, O>(lhs: (some Parser<I1>, some Parser<I2>, some Parser<I3>, some Parser<I4>), rhs: @escaping (I1, I2, I3, I4) -> O?) -> some Parser<O> {
	InlineParser { input in
		guard
			let i1 = lhs.0.parse(&input),
			let i2 = lhs.1.parse(&input),
			let i3 = lhs.2.parse(&input),
			let i4 = lhs.3.parse(&input)
		else { return nil }
		return rhs(i1, i2, i3, i4)
	}
}

public func <*> <I1, I2, I3, I4, I5, O>(lhs: (some Parser<I1>, some Parser<I2>, some Parser<I3>, some Parser<I4>, some Parser<I5>), rhs: @escaping (I1, I2, I3, I4, I5) -> O?) -> some Parser<O> {
	InlineParser { input in
		guard
			let i1 = lhs.0.parse(&input),
			let i2 = lhs.1.parse(&input),
			let i3 = lhs.2.parse(&input),
			let i4 = lhs.3.parse(&input),
			let i5 = lhs.4.parse(&input)
		else { return nil }
		return rhs(i1, i2, i3, i4, i5)
	}
}
