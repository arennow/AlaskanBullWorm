public func many0<T>(_ inner: some Parser<T>) -> some Parser<Array<T>> {
	InlineParser { input in
		try (0...).mapUntilNil { _ in
			try inner.parse(&input)
		}
	}
}

public func many1<T>(_ inner: some Parser<T>) -> some Parser<Array<T>> { manyN(n: 1, inner) }
public func many2<T>(_ inner: some Parser<T>) -> some Parser<Array<T>> { manyN(n: 2, inner) }

fileprivate func manyN<T>(n: Int, _ inner: some Parser<T>) -> some Parser<Array<T>> {
	InlineParser { input in
		guard let zeroOut = try many0(inner).parse(&input),
			  zeroOut.count >= n
		else { return nil }
		return zeroOut
	}
}

public func many0(_ charPred: CharacterPredicate) -> some Parser<Substring> {
	InlineParser { input in
		try many1(charPred).parse(&input) ?? ""
	}
}

public func many1(_ charPred: CharacterPredicate) -> some Parser<Substring> {
	RepeatedPredicateParser(charPred)
}
