struct InlineParser<T>: Parser {
	let parser: (inout Substring) -> T?

	func parse(_ input: inout Substring) -> T? {
		let before = input
		if let out = self.parser(&input) {
			return out
		} else {
			input = before
			return nil
		}
	}
}
