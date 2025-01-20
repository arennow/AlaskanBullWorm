struct DropPredicateAdapter<Inner: Parser>: Parser {
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

public extension Parser {
	func drop(allowFailures: Bool = false) -> some Parser<Substring> {
		DropPredicateAdapter(inner: self, allowFailures: allowFailures)
	}
}
