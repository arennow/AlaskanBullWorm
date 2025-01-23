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
		#expect(many1(.visible).parse(&src) == "abc")
		#expect(src == remaining)
	}

	@Test
	func takeExactString() {
		var src: Substring = "abcdef"
		#expect(exact("abc").parse(&src) == "abc")
		#expect(src == "def")
	}

	@Test
	func drop_success() {
		var src: Substring = "abc123"
		let pred = many1(.asciiLetter).drop()
		#expect(pred.parse(&src) != nil)
		#expect(src == "123")
	}

	@Test
	func drop_allowFailures() {
		var src: Substring = "abc123"
		let pred = many1(.whitespace).drop(allowFailures: true)
		#expect(pred.parse(&src) != nil)
		#expect(src == "abc123")
	}

	@Test
	func drop_disallowFailures() {
		var src: Substring = "abc123"
		let pred = many1(.whitespace).drop(allowFailures: false)
		#expect(pred.parse(&src) == nil)
		#expect(src == "abc123")
	}

	@Test(arguments: [
		("123", 123),
		("-123", -123)
	])
	func optional(input: String, output: Int) {
		let parser =
			char(.exact("-")).optional() <+>
			many1(.numeral) <*>
			{ Int($0) }

		var input = input[...]
		#expect(parser.parse(&input) == output)
		#expect(input.isEmpty)
	}

	@Test
	func then() {
		do {
			var src: Substring = "abc"
			#expect((char(.exact("a")) <+> char(.exact("b"))).parse(&src) == "ab")
			#expect(src == "c")
		}

		do {
			var src: Substring = "abc"
			#expect((char(.exact("a")) <+> char(.exact("¿"))).parse(&src) == nil)
			#expect(src == "abc")
		}

		do {
			var src: Substring = "abc"
			#expect((char(.exact("¿")) <+> char(.exact("b"))).parse(&src) == nil)
			#expect(src == "abc")
		}

		do {
			var src: Substring = "abc"
			#expect((char(.exact("¿")) <+> char(.exact("¿"))).parse(&src) == nil)
			#expect(src == "abc")
		}
	}

	@Test
	func wrapped_successful() {
		var src: Substring = "[abc]def"

		#expect(wrap("[", "]", many1(.visible)).parse(&src) == "abc")
		#expect(src == "def")
	}

	@Test
	func wrapped_successfulNested() {
		var src: Substring = "[(abc)]def"
		let pred = wrap("[", "]", wrap("(", ")", many1(.visible)))
		#expect(pred.parse(&src) == "abc")
		#expect(src == "def")
	}

	@Test
	func wrapped_failedInner() {
		var src: Substring = "[a c]"
		#expect(wrap("[", "]", many1(.visible)).parse(&src) == nil)
		#expect(src == "[a c]")
	}

	@Test
	func wrapped_failedLeading() {
		var src: Substring = "(abc]"
		#expect(wrap("[", "]", many1(.visible)).parse(&src) == nil)
		#expect(src == "(abc]")
	}

	@Test
	func wrapped_failedTrailing() {
		var src: Substring = "[abc)"
		#expect(wrap("[", "]", many1(.visible)).parse(&src) == nil)
		#expect(src == "[abc)")
	}

	@Test
	func prefix_successful() {
		var src: Substring = "|abc"
		#expect(prefix("|", many1(.visible)).parse(&src) == "abc")
		#expect(src.isEmpty)
	}

	@Test
	func prefix_failed() {
		var src: Substring = "<abc"
		#expect(prefix("|", many1(.visible)).parse(&src) == nil)
		#expect(src == "<abc")
	}

	@Test
	func postfix_successful() {
		var src: Substring = "abc|"
		#expect(postfix("|", many1(.visible)).parse(&src) == "abc")
		#expect(src.isEmpty)
	}

	@Test
	func postfix_failed() {
		var src: Substring = "abc>"
		#expect(postfix("|", many1(.visible)).parse(&src) == nil)
		#expect(src == "abc>")
	}

	@Test
	func anyPredicate() {
		let pred = many1(.numeral) <||> char(.exact("x"))

		var src: Substring = "x123a"
		#expect(pred.parse(&src) == "x")
		#expect(pred.parse(&src) == "123")
		#expect(pred.parse(&src) == nil)
		#expect(src == "a")
	}

	@Test
	func compoundPredicate() {
		let pred = (char(.exact("a")) <||> char(.exact("b")) <||> char(.exact("c"))) <+>
			many1(.whitespace).drop() <+>
			many1(.numeral)

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
