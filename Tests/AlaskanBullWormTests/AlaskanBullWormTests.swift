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
}
