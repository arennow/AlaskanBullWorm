struct ThenPredicateAdapter<First: Predicate, Second: Predicate>: Predicate {
	let first: First
	let second: Second

	func take(from src: inout Substring) -> Substring? {
		let beforeFirst = src

		guard let firstResult = self.first.take(from: &src),
			  let secondResult = self.second.take(from: &src)
		else {
			src = beforeFirst
			return nil
		}

		return firstResult + secondResult
	}
}

public extension Predicate {
	func then(_ second: some Predicate) -> some Predicate {
		ThenPredicateAdapter(first: self, second: second)
	}
}
