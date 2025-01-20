struct InlineParser<T>: Parser {
	let parser: (inout Substring) -> T?

	func parse(_ input: inout Substring) -> T? {
		self.parser(&input)
	}
}
