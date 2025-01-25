struct InlineParser<T>: Parser {
	let parser: @Sendable (inout Substring) throws -> T?

	func parse(_ input: inout Substring) throws -> T? {
		let before = input
		do {
			if let out = try self.parser(&input) {
				return out
			} else {
				input = before
				return nil
			}
		} catch {
			input = before
			throw error
		}
	}
}
