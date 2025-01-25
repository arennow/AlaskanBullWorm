infix operator <*>: AdditionPrecedence

public func <*> <I, O>(lhs: any Parser<I>, rhs: @Sendable @escaping (I) throws -> O?) -> some Parser<O> {
	InlineParser { input in
		try lhs.parse(&input).flatMap(rhs)
	}
}

public func <*> <I1, I2, O>(lhs: (some Parser<I1>, some Parser<I2>), rhs: @Sendable @escaping (I1, I2) throws -> O?) -> some Parser<O> {
	InlineParser { input in
		guard
			let i1 = try lhs.0.parse(&input),
			let i2 = try lhs.1.parse(&input)
		else { return nil }
		return try rhs(i1, i2)
	}
}

public func <*> <I1, I2, I3, O>(lhs: (some Parser<I1>, some Parser<I2>, some Parser<I3>), rhs: @Sendable @escaping (I1, I2, I3) throws -> O?) -> some Parser<O> {
	InlineParser { input in
		guard
			let i1 = try lhs.0.parse(&input),
			let i2 = try lhs.1.parse(&input),
			let i3 = try lhs.2.parse(&input)
		else { return nil }
		return try rhs(i1, i2, i3)
	}
}

public func <*> <I1, I2, I3, I4, O>(lhs: (some Parser<I1>, some Parser<I2>, some Parser<I3>, some Parser<I4>), rhs: @Sendable @escaping (I1, I2, I3, I4) throws -> O?) -> some Parser<O> {
	InlineParser { input in
		guard
			let i1 = try lhs.0.parse(&input),
			let i2 = try lhs.1.parse(&input),
			let i3 = try lhs.2.parse(&input),
			let i4 = try lhs.3.parse(&input)
		else { return nil }
		return try rhs(i1, i2, i3, i4)
	}
}

public func <*> <I1, I2, I3, I4, I5, O>(lhs: (some Parser<I1>, some Parser<I2>, some Parser<I3>, some Parser<I4>, some Parser<I5>), rhs: @Sendable @escaping (I1, I2, I3, I4, I5) throws -> O?) -> some Parser<O> {
	InlineParser { input in
		guard
			let i1 = try lhs.0.parse(&input),
			let i2 = try lhs.1.parse(&input),
			let i3 = try lhs.2.parse(&input),
			let i4 = try lhs.3.parse(&input),
			let i5 = try lhs.4.parse(&input)
		else { return nil }
		return try rhs(i1, i2, i3, i4, i5)
	}
}
