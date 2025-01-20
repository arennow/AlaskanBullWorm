struct AnyPredicateAdapter: Predicate {
	let innerPredicates: Array<any Predicate>

	init(innerPredicates: Array<any Predicate>) {
		self.innerPredicates = innerPredicates
	}

	func parse(_ src: inout Substring) -> Substring? {
		for predicate in self.innerPredicates {
			if let out = predicate.parse(&src) {
				return out
			}
		}
		return nil
	}
}

public func any(of predicates: any Predicate...) -> some Predicate {
	AnyPredicateAdapter(innerPredicates: predicates)
}
