import AlaskanBullWorm
import Testing

struct AlaskanBullWormTests {
	@Test
	func whitespaceSeparated_manual() {
		var abm = AlaskanBullWorm("ab c def   g\t\thi ")

		#expect(abm.takeVisible() == "ab")
		#expect(abm.takeWhitespaces() != nil)
		#expect(abm.takeVisible() == "c")
		#expect(abm.takeWhitespaces() != nil)
		#expect(abm.takeVisible() == "def")
		#expect(abm.takeWhitespaces() != nil)
		#expect(abm.takeVisible() == "g")
		#expect(abm.takeWhitespaces() != nil)
		#expect(abm.takeVisible() == "hi")
		#expect(abm.takeWhitespaces() != nil)
		#expect(abm.takeWhitespaces() == nil)
		#expect(abm.remainder.isEmpty)
	}

	@Test
	func whitespaceSeparated() {
		var abm = AlaskanBullWorm("ab c def   g\t\thi ")

		#expect(abm.takeSpacedVisible() == "ab")
		#expect(abm.takeSpacedVisible() == "c")
		#expect(abm.takeSpacedVisible() == "def")
		#expect(abm.takeSpacedVisible() == "g")
		#expect(abm.takeSpacedVisible() == "hi")
		#expect(abm.takeSpacedVisible() == nil)
	}

	@Test
	func char() {
		var abm = AlaskanBullWorm("ab c def   g\t\thi ")

		#expect(abm.takeChar("b") == nil)
		#expect(abm.takeChar("a") == "a")
		#expect(abm.takeChar("b") == "b")
		#expect(abm.takeChar("c") == nil)
	}

	@Test
	func wrapped_successful() {
		var abm = AlaskanBullWorm("[abc]def")

		#expect(abm.takeWrapped(l: "[", r: "]", innerPredicate: { !$0.isWhitespace }) == "abc")
		#expect(abm.takeVisible() == "def")
		#expect(abm.remainder.isEmpty)
	}

	@Test
	func wrapped_failedInner() {
		var abm = AlaskanBullWorm("[a c]")

		#expect(abm.takeWrapped(l: "[", r: "]", innerPredicate: { !$0.isWhitespace }) == nil)
		#expect(abm.remainder == "[a c]")
	}

	@Test
	func wrapped_failedTrailing() {
		var abm = AlaskanBullWorm("[abc)")

		#expect(abm.takeWrapped(l: "[", r: "]", innerPredicate: { !$0.isWhitespace }) == nil)
		#expect(abm.remainder == "[abc)")
	}
}
