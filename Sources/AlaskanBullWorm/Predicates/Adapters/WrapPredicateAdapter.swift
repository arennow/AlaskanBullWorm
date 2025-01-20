struct WrapPredicateAdapter<Inner: Predicate>: Predicate {
	let inner: Inner
	let wrapperLeft: Character
	let wrapperRight: Character

	func take(from src: inout Substring) -> Substring? {
		let before = src

		guard src.first == self.wrapperLeft,
			  let wrapperRightIndex = src.dropFirst().firstIndex(of: self.wrapperRight)
		else { return nil }

		src.removeFirst()

		var innerSrc = src[..<wrapperRightIndex]
		// We assume that if `innerSrc` is empty, the inner predicate matched
		// to the end of the inner string (in addition to just not failing)
		guard let match = self.inner.take(from: &innerSrc), innerSrc.isEmpty else {
			src = before
			return nil
		}

		src.removeSubrange(src.startIndex...wrapperRightIndex)
		return match
	}
}

public func wrap(_ l: Character, _ r: Character, _ inner: some Predicate) -> some Predicate {
	WrapPredicateAdapter(inner: inner, wrapperLeft: l, wrapperRight: r)
}
