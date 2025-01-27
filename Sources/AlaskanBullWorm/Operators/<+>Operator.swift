infix operator <+>: AdditionPrecedence

public func <+> (lhs: some Parser<Substring>, rhs: some Parser<Substring>) -> some Parser<Substring> {
	InlineParser { src in
		guard let (l, r) = try checkPair(&src, lhs, rhs) else { return nil }
		return l + r
	}
}

public func <+> <T>(lhs: some Parser<Void>, rhs: some Parser<T>) -> some Parser<T> {
	InlineParser { src in
		guard let (_, r) = try checkPair(&src, lhs, rhs) else { return nil }
		return r
	}
}

public func <+> <T>(lhs: some Parser<T>, rhs: some Parser<Void>) -> some Parser<T> {
	InlineParser { src in
		guard let (l, _) = try checkPair(&src, lhs, rhs) else { return nil }
		return l
	}
}
