import AlaskanBullWorm
import Testing

struct AlaskanBullWormTests {
	@Test
	func whitespaceSeparated_manual() {
		var abm = AlaskanBullWorm("ab c def   g\t\thi ")

		#expect(abm.take(.visible) == "ab")
		#expect(abm.take(.whitespace) != nil)
		#expect(abm.take(.visible) == "c")
		#expect(abm.take(.whitespace) != nil)
		#expect(abm.take(.visible) == "def")
		#expect(abm.take(.whitespace) != nil)
		#expect(abm.take(.visible) == "g")
		#expect(abm.take(.whitespace) != nil)
		#expect(abm.take(.visible) == "hi")
		#expect(abm.take(.whitespace) != nil)
		#expect(abm.take(.whitespace) == nil)
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

		#expect(abm.take(.char("b")) == nil)
		#expect(abm.take(.char("a")) == "a")
		#expect(abm.take(.char("b")) == "b")
		#expect(abm.take(.char("c")) == nil)
	}

	@Test
	func wrapped_successful() {
		var abm = AlaskanBullWorm("[abc]def")

		#expect(abm.takeWrapped(l: "[", r: "]", innerPredicate: .visible) == "abc")
		#expect(abm.take(.visible) == "def")
		#expect(abm.remainder.isEmpty)
	}

	@Test
	func wrapped_failedInner() {
		var abm = AlaskanBullWorm("[a c]")

		#expect(abm.takeWrapped(l: "[", r: "]", innerPredicate: .visible) == nil)
		#expect(abm.remainder == "[a c]")
	}

	@Test
	func wrapped_failedTrailing() {
		var abm = AlaskanBullWorm("[abc)")

		#expect(abm.takeWrapped(l: "[", r: "]", innerPredicate: .visible) == nil)
		#expect(abm.remainder == "[abc)")
	}
}
