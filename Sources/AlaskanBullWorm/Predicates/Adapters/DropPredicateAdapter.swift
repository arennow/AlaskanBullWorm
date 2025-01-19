struct DropPredicateAdapter<Inner: Predicate>: Predicate {
	let inner: Inner

	func take(from src: inout Substring) -> Substring? {
		if self.inner.take(from: &src) != nil {
			return ""
		} else {
			return nil
		}
	}
}

public extension Predicate {
	func drop() -> some Predicate {
		DropPredicateAdapter(inner: self)
	}
}
