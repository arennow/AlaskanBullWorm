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
		#expect(abm.take(.whitespace) == " ")
		#expect(abm.take(.whitespace) == nil)
		#expect(abm.remainder.isEmpty)
	}

	@Test
	func skipWhitespaceTake() {
		var abm = AlaskanBullWorm("ab c def   g\t\thi ")

		#expect(abm.skipWhitespaceTake(.visible) == "ab")
		#expect(abm.skipWhitespaceTake(.visible) == "c")
		#expect(abm.skipWhitespaceTake(.visible) == "def")
		#expect(abm.skipWhitespaceTake(.visible) == "g")
		#expect(abm.skipWhitespaceTake(.visible) == "hi")
		#expect(abm.skipWhitespaceTake(.visible) == nil)
		#expect(abm.remainder == " ")
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

	@Test
	func skipTake() {
		var abm = AlaskanBullWorm("ab c def   g\t\thi ")

		#expect(abm.skipTake(skipRequired: true, .char("a"), .char("b")) == "b")
		#expect(abm.skipTake(.whitespace, .visible) == "c")
		#expect(abm.take(.whitespace) == " ")
		#expect(abm.remainder == "def   g\t\thi ")

		#expect(abm.skipTake(skipRequired: true, .whitespace, .visible) == nil)
		#expect(abm.remainder == "def   g\t\thi ")

		#expect(abm.skipTake(.visible, .char("\t")) == nil)
		#expect(abm.remainder == "def   g\t\thi ")

		#expect(abm.skipTake(.visible, takeRequired: false, .char("\t")) == nil)
		#expect(abm.remainder == "   g\t\thi ")
	}
}
