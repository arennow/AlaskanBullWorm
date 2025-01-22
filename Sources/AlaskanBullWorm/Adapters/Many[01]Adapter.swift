public func many0<T>(_ inner: some Parser<T>) -> some Parser<Array<T>> {
	InlineParser { input in
		(0...).mapUntilNil { _ in
			inner.parse(&input)
		}
	}
}

public func many1<T>(_ inner: some Parser<T>) -> some Parser<Array<T>> {
	InlineParser { input in
		guard let zeroOut = many0(inner).parse(&input),
			  !zeroOut.isEmpty
		else { return nil }
		return zeroOut
	}
}
