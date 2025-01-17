import AlaskanBullWorm
import Testing

struct AlaskanBullWormTests {
	@Test
	func whitespaceSeparated() {
		var abm = AlaskanBullWorm("ab c def   g\t\thi ")

		#expect(abm.takeNonWhitespaces() == "ab")
		#expect(abm.takeWhitespaces() != nil)
		#expect(abm.takeNonWhitespaces() == "c")
		#expect(abm.takeWhitespaces() != nil)
		#expect(abm.takeNonWhitespaces() == "def")
		#expect(abm.takeWhitespaces() != nil)
		#expect(abm.takeNonWhitespaces() == "g")
		#expect(abm.takeWhitespaces() != nil)
		#expect(abm.takeNonWhitespaces() == "hi")
		#expect(abm.takeWhitespaces() != nil)
		#expect(abm.takeWhitespaces() == nil)
		#expect(abm.remainder.isEmpty)
	}
}
