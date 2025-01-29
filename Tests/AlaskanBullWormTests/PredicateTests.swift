import AlaskanBullWorm
import Testing

struct PredicateTests {
	@Test(arguments: [
		Run("abc def", "abc", " def"),
		Run("abc ", "abc", " "),
		Run("abc", "abc", ""),
	])
	func takeVisible(run: Run<Substring>) throws {
		try run.test(many1(.visible))
	}

	@Test(arguments: [
		Run("abc def", "abc", " def"),
		Run("a_b-c$", "a_b-c", "$"),
		Run("ab|c", "ab", "|c"),
		Run("ab(c)", "ab", "(c)"),
		Run("a1(c)", "a1", "(c)"),
	])
	func takeAsciiIdentifier(run: Run<Substring>) throws {
		try run.test(many1(.asciiIdentifier))
	}

	@Test
	func takeExactString() throws {
		var src: Substring = "abcdef"
		try #expect(exact("abc").parse(&src) == "abc")
		#expect(src == "def")
	}

	@Test
	func drop_success() throws {
		var src: Substring = "abc123"
		let pred = many1(.asciiLetter).drop()
		try #expect(pred.parse(&src) != nil)
		#expect(src == "123")
	}

	@Test
	func drop_allowFailures() throws {
		var src: Substring = "abc123"
		let pred = many1(.whitespace).drop(allowFailures: true)
		try #expect(pred.parse(&src) != nil)
		#expect(src == "abc123")
	}

	@Test
	func drop_disallowFailures() throws {
		var src: Substring = "abc123"
		let pred = many1(.whitespace).drop(allowFailures: false)
		try #expect(pred.parse(&src) == nil)
		#expect(src == "abc123")
	}

	@Test(arguments: [
		("123", 123),
		("-123", -123),
	])
	func optional(input: String, output: Int) throws {
		let parser =
			char(.exact("-")).optional() <+>
			many1(.numeral) <*>
			{ Int($0) }

		var input = input[...]
		try #expect(parser.parse(&input) == output)
		#expect(input.isEmpty)
	}

	@Test
	func then() throws {
		do {
			var src: Substring = "abc"
			try #expect((char(.exact("a")) <+> char(.exact("b"))).parse(&src) == "ab")
			#expect(src == "c")
		}

		do {
			var src: Substring = "abc"
			try #expect((char(.exact("a")) <+> char(.exact("¿"))).parse(&src) == nil)
			#expect(src == "abc")
		}

		do {
			var src: Substring = "abc"
			try #expect((char(.exact("¿")) <+> char(.exact("b"))).parse(&src) == nil)
			#expect(src == "abc")
		}

		do {
			var src: Substring = "abc"
			try #expect((char(.exact("¿")) <+> char(.exact("¿"))).parse(&src) == nil)
			#expect(src == "abc")
		}
	}

	@Test
	func wrapped_successful() throws {
		var src: Substring = "[abc]def"

		try #expect(wrap("[", "]", many1(.visible)).parse(&src) == "abc")
		#expect(src == "def")
	}

	@Test
	func wrapped_successfulNested() throws {
		var src: Substring = "[(abc)]def"
		let pred = wrap("[", "]", wrap("(", ")", many1(.visible)))
		try #expect(pred.parse(&src) == "abc")
		#expect(src == "def")
	}

	@Test
	func wrapped_failedInner() throws {
		var src: Substring = "[a c]"
		try #expect(wrap("[", "]", many1(.visible)).parse(&src) == nil)
		#expect(src == "[a c]")
	}

	@Test
	func wrapped_throwsInner() throws {
		var src: Substring = "[a c]"
		#expect(throws: TestError.self) {
			try wrap("[", "]", (many1(.visible)) <*> { _ in throw TestError() }).parse(&src)
		}
		#expect(src == "[a c]")
	}

	@Test
	func wrapped_failedLeading() throws {
		var src: Substring = "(abc]"
		try #expect(wrap("[", "]", many1(.visible)).parse(&src) == nil)
		#expect(src == "(abc]")
	}

	@Test
	func wrapped_failedTrailing() throws {
		var src: Substring = "[abc)"
		try #expect(wrap("[", "]", many1(.visible)).parse(&src) == nil)
		#expect(src == "[abc)")
	}

	@Test
	func prefix_successful() throws {
		var src: Substring = "|abc"
		try #expect(prefix("|", many1(.visible)).parse(&src) == "abc")
		#expect(src.isEmpty)
	}

	@Test
	func prefix_failed() throws {
		var src: Substring = "<abc"
		try #expect(prefix("|", many1(.visible)).parse(&src) == nil)
		#expect(src == "<abc")
	}

	@Test
	func postfix_successful() throws {
		var src: Substring = "abc|"
		try #expect(postfix("|", many1(.visible)).parse(&src) == "abc")
		#expect(src.isEmpty)
	}

	@Test
	func postfix_failed() throws {
		var src: Substring = "abc>"
		try #expect(postfix("|", many1(.visible)).parse(&src) == nil)
		#expect(src == "abc>")
	}

	@Test
	func anyPredicate() throws {
		let pred = many1(.numeral) <||> char(.exact("x"))

		var src: Substring = "x123a"
		try #expect(pred.parse(&src) == "x")
		try #expect(pred.parse(&src) == "123")
		try #expect(pred.parse(&src) == nil)
		#expect(src == "a")
	}

	@Test
	func anyPredicateRethrows() throws {
		let pred = many1(.numeral) <*> { _ in throw TestError() } <||> char(.exact("x"))

		var src: Substring = "x123a"
		try #expect(pred.parse(&src) == "x")
		#expect(throws: TestError()) { try pred.parse(&src) == "123" }
		#expect(src == "123a")
	}

	@Test(arguments: [
		Run("a 12", "a12", ""),
		Run("b16", "b16", ""),
		Run("c\t\t19", "c19", ""),
		Run("d25", nil, "d25"),
	])
	func compoundPredicate(run: Run<Substring>) throws {
		let pred = (char(.exact("a")) <||> char(.exact("b")) <||> char(.exact("c")))
		<+>
		<<many1(.numeral)

		try run.test(pred)
	}
}
