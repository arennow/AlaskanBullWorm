infix operator <~>: AdditionPrecedence

public func <~> <T1, T2>(lhs: some Parser<T1>, rhs: some Parser<T2>) -> some Parser<(T1, T2)> {
	InlineParser { input in
		checkPair(&input, lhs, rhs)
	}
}

public func <~> <T1, T2, T3>(lhs: some Parser<(T1, T2)>, rhs: some Parser<T3>) -> some Parser<(T1, T2, T3)> {
	InlineParser { input in
		guard let leftTup = lhs.parse(&input),
			  let right = rhs.parse(&input)
		else { return nil }
		return (leftTup.0, leftTup.1, right)
	}
}

public func <~> <T1, T2, T3, T4>(lhs: some Parser<(T1, T2, T3)>, rhs: some Parser<T4>) -> some Parser<(T1, T2, T3, T4)> {
	InlineParser { input in
		guard let leftTup = lhs.parse(&input),
			  let right = rhs.parse(&input)
		else { return nil }
		return (leftTup.0, leftTup.1, leftTup.2, right)
	}
}

public func <~> <T1, T2, T3, T4, T5>(lhs: some Parser<(T1, T2, T3, T4)>, rhs: some Parser<T5>) -> some Parser<(T1, T2, T3, T4, T5)> {
	InlineParser { input in
		guard let leftTup = lhs.parse(&input),
			  let right = rhs.parse(&input)
		else { return nil }
		return (leftTup.0, leftTup.1, leftTup.2, leftTup.3, right)
	}
}
