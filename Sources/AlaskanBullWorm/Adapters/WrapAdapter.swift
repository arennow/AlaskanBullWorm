struct WrapAdapter<Inner: Parser>: Parser {
	let inner: Inner
	let wrapperLeft: Character?
	let wrapperRight: Character?

	func parse(_ src: inout Substring) throws -> Inner.Output? {
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

		switch Result(catching: { try self.inner.parse(&innerSrc) }) {
			case .success(.some(let match)):
				// We assume that if `innerSrc` is empty, the inner predicate matched
				// to the end of the inner string (in addition to just not failing)
				guard innerSrc.isEmpty else { fallthrough }

				if let wrapperRightIndex {
					src.removeSubrange(src.startIndex...wrapperRightIndex)
				} else {
					src.removeAll()
				}
				return match

			case .success(.none):
				src = before
				return nil

			case .failure(let err):
				src = before
				throw err
		}
	}
}

public func wrap<T>(_ l: Character, _ r: Character, _ inner: some Parser<T>) -> some Parser<T> {
	WrapAdapter(inner: inner, wrapperLeft: l, wrapperRight: r)
}

public func prefix<T>(_ p: Character, _ inner: some Parser<T>) -> some Parser<T> {
	WrapAdapter(inner: inner, wrapperLeft: p, wrapperRight: nil)
}

public func postfix<T>(_ p: Character, _ inner: some Parser<T>) -> some Parser<T> {
	WrapAdapter(inner: inner, wrapperLeft: nil, wrapperRight: p)
}
