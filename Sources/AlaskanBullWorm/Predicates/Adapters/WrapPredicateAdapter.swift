struct WrapPredicateAdapter<Inner: Parser<Substring>>: Parser {
	let inner: Inner
	let wrapperLeft: Character?
	let wrapperRight: Character?

	func parse(_ src: inout Substring) -> Substring? {
		let before = src

		if let wl = self.wrapperLeft {
			if src.first == wl {
				src.removeFirst()
			} else {
				return nil
			}
		}

		let wrapperRightIndex: Substring.Index?
		if let wr = self.wrapperRight {
			guard let ind = src.firstIndex(of: wr)
			else {
				src = before
				return nil
			}
			wrapperRightIndex = ind
		} else {
			wrapperRightIndex = nil
		}

		var innerSrc = if let wrapperRightIndex {
			src[..<wrapperRightIndex]
		} else {
			src
		}
		// We assume that if `innerSrc` is empty, the inner predicate matched
		// to the end of the inner string (in addition to just not failing)
		guard let match = self.inner.parse(&innerSrc), innerSrc.isEmpty else {
			src = before
			return nil
		}

		if let wrapperRightIndex {
			src.removeSubrange(src.startIndex...wrapperRightIndex)
		} else {
			src.removeAll()
		}

		return match
	}
}

public func wrap(_ l: Character, _ r: Character, _ inner: some Parser<Substring>) -> some Parser<Substring> {
	WrapPredicateAdapter(inner: inner, wrapperLeft: l, wrapperRight: r)
}

public func prefix(_ p: Character, _ inner: some Parser<Substring>) -> some Parser<Substring> {
	WrapPredicateAdapter(inner: inner, wrapperLeft: p, wrapperRight: nil)
}

public func postfix(_ p: Character, _ inner: some Parser<Substring>) -> some Parser<Substring> {
	WrapPredicateAdapter(inner: inner, wrapperLeft: nil, wrapperRight: p)
}
