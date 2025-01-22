infix operator <+>: MultiplicationPrecedence

public func <+> (lhs: some Parser<Substring>, rhs: some Parser<Substring>) -> some Parser<Substring> {
	InlineParser { src in
		guard let (l, r) = checkPair(&src, lhs, rhs) else { return nil }
		return l + r
	}
}

public func <+> <T>(lhs: some Parser<Void>, rhs: some Parser<T>) -> some Parser<T> {
	InlineParser { src in
		guard let (_, r) = checkPair(&src, lhs, rhs) else { return nil }
		return r
	}
}
