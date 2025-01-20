struct DropPredicateAdapter<Inner: Predicate>: Predicate {
	let inner: Inner
	let allowFailures: Bool

	func parse(_ src: inout Substring) -> Substring? {
		if self.inner.parse(&src) != nil || self.allowFailures {
			return ""
		} else {
			return nil
		}
	}
}

public extension Predicate {
	func drop(allowFailures: Bool = false) -> some Predicate {
		DropPredicateAdapter(inner: self, allowFailures: allowFailures)
	}
}
