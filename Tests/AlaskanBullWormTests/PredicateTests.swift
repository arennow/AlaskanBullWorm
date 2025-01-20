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
	func drop() {
		var src: Substring = "abc123"
		let pred: some Predicate = .asciiLetter.drop()
		#expect(pred.take(from: &src) == "")
		#expect(src == "123")
	}

	@Test
	func drop_includingFailures() {
		var src: Substring = "abc123"
		let pred: some Predicate = .whitespace.drop(allowFailures: true)
		#expect(pred.take(from: &src) == "")
		#expect(src == "abc123")
	}

	@Test
	func then() {
		do {
			var src: Substring = "abc"
			#expect((.char("a") <+> .char("b")).take(from: &src) == "ab")
			#expect(src == "c")
		}

		do {
			var src: Substring = "abc"
			#expect((.char("a") <+> .char("¿")).take(from: &src) == nil)
			#expect(src == "abc")
		}

		do {
			var src: Substring = "abc"
			#expect((.char("¿") <+> .char("b")).take(from: &src) == nil)
			#expect(src == "abc")
		}

		do {
			var src: Substring = "abc"
			#expect((.char("¿") <+> .char("¿")).take(from: &src) == nil)
			#expect(src == "abc")
		}
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
	func prefix_successful() {
		var src: Substring = "|abc"
		#expect(prefix("|", .visible).take(from: &src) == "abc")
		#expect(src.isEmpty)
	}

	@Test
	func prefix_failed() {
		var src: Substring = "<abc"
		#expect(prefix("|", .visible).take(from: &src) == nil)
		#expect(src == "<abc")
	}

	@Test
	func postfix_successful() {
		var src: Substring = "abc|"
		#expect(postfix("|", .visible).take(from: &src) == "abc")
		#expect(src.isEmpty)
	}

	@Test
	func postfix_failed() {
		var src: Substring = "abc>"
		#expect(postfix("|", .visible).take(from: &src) == nil)
		#expect(src == "abc>")
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
		let pred = any(of: .char("a"), .char("b"), .char("c")) <+>
			.whitespace.drop(allowFailures: true) <+>
			.numeral

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
