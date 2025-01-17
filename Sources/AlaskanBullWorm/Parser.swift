public struct Parser<T> {
	public let predicate: Predicate
	public let transform: Transform<T>

	public init(predicate: Predicate, transform: @escaping Transform<T>) {
		self.predicate = predicate
		self.transform = transform
	}

	public func parse(_ input: inout Substring) -> T? {
		let before = input

		let out = self.predicate.take(from: &input).flatMap(self.transform)
		if out == nil {
			// Just roll back
			input = before
		}
		return out
	}

	public func callAsFunction(_ input: inout Substring) -> T? {
		self.parse(&input)
	}
}

infix operator <*>

public func <*> <T>(lhs: Predicate, rhs: @escaping Transform<T>) -> Parser<T> {
	.init(predicate: lhs, transform: rhs)
}
