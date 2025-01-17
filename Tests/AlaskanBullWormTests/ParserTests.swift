import AlaskanBullWorm
import Testing

struct ParserTests {
	@Test
	func basicParse() {
		let parser = .custom(\.isWholeNumber) <*> { Int($0) }

		var src: Substring = "123abc"
		#expect(parser(&src) == 123)
		#expect(src == "abc")
	}

	@Test
	func failedTransformDoesntTake() {
		let parser = .custom(\.isWholeNumber) <*> { _ in Optional<Int>.none }

		var src: Substring = "123abc"
		#expect(parser(&src) == nil)
		#expect(src == "123abc")
	}
}
