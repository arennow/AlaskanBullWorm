public protocol Parser<Output> {
	associatedtype Output

	func parse(_ input: inout Substring) -> Output?
}
