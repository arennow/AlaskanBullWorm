import AlaskanBullWorm
import Testing

struct TestError: Error, Equatable {}

struct Run<T: Equatable & Sendable>: Sendable {
	let input: Substring
	let output: T?
	let remainder: Substring

	init(_ input: some StringProtocol, output: T?, _ remainder: some StringProtocol) {
		self.input = Substring(input)
		self.output = output
		self.remainder = Substring(remainder)
	}

	init(_ input: some StringProtocol, _ output: (any StringProtocol)?, _ remainder: some StringProtocol) where T == Substring {
		self.init(input, output: output.map { Substring($0) }, remainder)
	}

	func test(_ parser: some Parser<T>) throws {
		var input = self.input
		try #expect(parser.parse(&input) == self.output)
		#expect(input == self.remainder)
	}
}
