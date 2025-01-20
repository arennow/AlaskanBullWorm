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
		#expect(CharPredicate.visible.parse(&src) == "abc")
		#expect(src == remaining)
	}

	@Test
	func takeExactString() {
		var src: Substring = "abcdef"
		#expect(ExactStringPredicate("abc").parse(&src) == "abc")
		#expect(src == "def")
	}

	@Test
	func drop() {
		var src: Substring = "abc123"
		let pred: some Parser<Substring> = .asciiLetter.drop()
		#expect(pred.parse(&src) == "")
		#expect(src == "123")
	}

	@Test
	func drop_includingFailures() {
		var src: Substring = "abc123"
		let pred: some Parser<Substring> = .whitespace.drop(allowFailures: true)
		#expect(pred.parse(&src) == "")
		#expect(src == "abc123")
	}

	@Test
	func then() {
		do {
			var src: Substring = "abc"
			#expect((.char("a") <+> .char("b")).parse(&src) == "ab")
			#expect(src == "c")
		}

		do {
			var src: Substring = "abc"
			#expect((.char("a") <+> .char("¿")).parse(&src) == nil)
			#expect(src == "abc")
		}

		do {
			var src: Substring = "abc"
			#expect((.char("¿") <+> .char("b")).parse(&src) == nil)
			#expect(src == "abc")
		}

		do {
			var src: Substring = "abc"
			#expect((.char("¿") <+> .char("¿")).parse(&src) == nil)
			#expect(src == "abc")
		}
	}

	@Test
	func wrapped_successful() {
		var src: Substring = "[abc]def"

		#expect(wrap("[", "]", .visible).parse(&src) == "abc")
		#expect(src == "def")
	}

	@Test
	func wrapped_successfulNested() {
		var src: Substring = "[(abc)]def"
		let pred = wrap("[", "]", wrap("(", ")", .visible))
		#expect(pred.parse(&src) == "abc")
		#expect(src == "def")
	}

	@Test
	func wrapped_failedInner() {
		var src: Substring = "[a c]"
		#expect(wrap("[", "]", .visible).parse(&src) == nil)
		#expect(src == "[a c]")
	}

	@Test
	func wrapped_failedLeading() {
		var src: Substring = "(abc]"
		#expect(wrap("[", "]", .visible).parse(&src) == nil)
		#expect(src == "(abc]")
	}

	@Test
	func wrapped_failedTrailing() {
		var src: Substring = "[abc)"
		#expect(wrap("[", "]", .visible).parse(&src) == nil)
		#expect(src == "[abc)")
	}

	@Test
	func prefix_successful() {
		var src: Substring = "|abc"
		#expect(prefix("|", .visible).parse(&src) == "abc")
		#expect(src.isEmpty)
	}

	@Test
	func prefix_failed() {
		var src: Substring = "<abc"
		#expect(prefix("|", .visible).parse(&src) == nil)
		#expect(src == "<abc")
	}

	@Test
	func postfix_successful() {
		var src: Substring = "abc|"
		#expect(postfix("|", .visible).parse(&src) == "abc")
		#expect(src.isEmpty)
	}

	@Test
	func postfix_failed() {
		var src: Substring = "abc>"
		#expect(postfix("|", .visible).parse(&src) == nil)
		#expect(src == "abc>")
	}

	@Test
	func anyPredicate() {
		let pred = .numeral <||> .char("x")

		var src: Substring = "x123a"
		#expect(pred.parse(&src) == "x")
		#expect(pred.parse(&src) == "123")
		#expect(pred.parse(&src) == nil)
		#expect(src == "a")
	}

	@Test
	func compoundPredicate() {
		let pred = (CharPredicate.char("a") <||> CharPredicate.char("b") <||> CharPredicate.char("c")) <+>
			.whitespace.drop(allowFailures: true) <+>
			.numeral

		#expect(apply(pred, "a 12") == "a12")
		#expect(apply(pred, "b16") == "b16")
		#expect(apply(pred, "c\t\t19") == "c19")
		#expect(apply(pred, "d25") == nil)
	}
}

fileprivate func apply(_ predicate: some Parser<Substring>, _ src: String) -> Substring? {
	var src = src[...]
	return predicate.parse(&src)
}
