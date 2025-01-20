struct ThenPredicateAdapter<First: Parser<Substring>, Second: Parser<Substring>>: Parser {
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

public func <+> (lhs: some Parser<Substring>, rhs: some Parser<Substring>) -> some Parser<Substring> {
	ThenPredicateAdapter(first: lhs, second: rhs)
}
