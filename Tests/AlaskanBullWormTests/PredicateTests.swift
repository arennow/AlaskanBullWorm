import AlaskanBullWorm
import Testing

struct PredicateTests {
	@Test(arguments: [
		("abc def", " def"),
		("abc ", " "),
		("abc", ""),
	])
	func takeVisible(src: Substring, remaining: Substring) {
		var src = src
		#expect(CharPredicate.visible.take(from: &src) == "abc")
		#expect(src == remaining)
	}

	@Test
	func takeExactString() {
		var src: Substring = "abcdef"
		#expect(ExactStringPredicate("abc").take(from: &src) == "abc")
		#expect(src == "def")
	}

	@Test
	func dropThenTake_simple() {
		var src: Substring = "abc123"
		let pred: some Predicate = .asciiLetter.drop().then(.numeral)
		#expect(pred.take(from: &src) == "123")
		#expect(src == "")
	}

	@Test
	func dropThenTake_complex() {
		var src: Substring = "ab c def   g\t\thi "

		#expect(CharPredicate.char("a").drop().then(.char("b"), require: .both).take(from: &src) == "b")
		#expect(CharPredicate.whitespace.drop().then(.visible).take(from: &src) == "c")
		#expect(CharPredicate.whitespace.take(from: &src) == " ")
		#expect(src == "def   g\t\thi ")

		#expect(CharPredicate.whitespace.drop().then(.visible, require: .both).take(from: &src) == nil)
		#expect(src == "def   g\t\thi ")

		#expect(CharPredicate.visible.drop().then(.char("¿")).take(from: &src) == nil)
		#expect(src == "def   g\t\thi ")

		#expect(CharPredicate.visible.drop().then(.char("¿"), require: .second).take(from: &src) == nil)
		#expect(src == "   g\t\thi ")
	}
}
