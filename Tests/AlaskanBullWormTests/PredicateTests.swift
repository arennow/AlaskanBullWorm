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

	@Test
	func wrapped_successful() {
		var src: Substring = "[abc]def"

		#expect(wrap("[", "]", .visible).take(from: &src) == "abc")
		#expect(src == "def")
	}

	@Test
	func wrapped_successfulNested() {
		var src: Substring = "[(abc)]def"

		let pred = wrap("[", "]", wrap("(", ")", .visible))

		#expect(pred.take(from: &src) == "abc")
		#expect(src == "def")
	}

	@Test
	func wrapped_failedInner() {
		var src: Substring = "[a c]"

		#expect(wrap("[", "]", .visible).take(from: &src) == nil)
		#expect(src == "[a c]")
	}

	@Test
	func wrapped_failedLeading() {
		var src: Substring = "(abc]"

		#expect(wrap("[", "]", .visible).take(from: &src) == nil)
		#expect(src == "(abc]")
	}

	@Test
	func wrapped_failedTrailing() {
		var src: Substring = "[abc)"

		#expect(wrap("[", "]", .visible).take(from: &src) == nil)
		#expect(src == "[abc)")
	}

	@Test
	func anyPredicate() {
		let pred = any(of: .numeral, .char("x"))

		var src: Substring = "x123a"
		#expect(pred.take(from: &src) == "x")
		#expect(pred.take(from: &src) == "123")
		#expect(pred.take(from: &src) == nil)
		#expect(src == "a")
	}

	@Test
	func compoundPredicate() {
		let pred = any(of: .char("a"), .char("b"), .char("c"))
			.then(.whitespace.drop(), require: .first)
			.then(.numeral)

		#expect(apply(pred, "a 12") == "a12")
		#expect(apply(pred, "b16") == "b16")
		#expect(apply(pred, "c\t\t19") == "c19")
		#expect(apply(pred, "d25") == nil)
	}
}

fileprivate func apply(_ predicate: some Predicate, _ src: String) -> Substring? {
	var src = src[...]
	return predicate.take(from: &src)
}
