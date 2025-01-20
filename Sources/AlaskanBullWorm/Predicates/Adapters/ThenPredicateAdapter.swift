struct ThenPredicateAdapter<First: Predicate, Second: Predicate>: Predicate {
	let first: First
	let second: Second

	func parse(_ src: inout Substring) -> Substring? {
		let beforeFirst = src

		guard let firstResult = self.first.parse(&src),
			  let secondResult = self.second.parse(&src)
		else {
			src = beforeFirst
			return nil
		}

		return firstResult + secondResult
	}
}

infix operator <+>: MultiplicationPrecedence

public func <+> (lhs: some Predicate, rhs: some Predicate) -> some Predicate {
	ThenPredicateAdapter(first: lhs, second: rhs)
}
