import AlaskanBullWorm
import Testing

struct PredicateTests {
	@Test(arguments: [
		("abc def", " def"),
		("abc ", " "),
		("abc", ""),
	])
	func takeVisible(src: Substring, remaining: Substring) throws {
		var src = src
		#expect(try many1(.visible).parse(&src) == "abc")
		#expect(src == remaining)
	}

	@Test
	func takeExactString() throws {
		var src: Substring = "abcdef"
		#expect(try exact("abc").parse(&src) == "abc")
		#expect(src == "def")
	}

	@Test
	func drop_success() throws {
		var src: Substring = "abc123"
		let pred = many1(.asciiLetter).drop()
		#expect(try pred.parse(&src) != nil)
		#expect(src == "123")
	}

	@Test
	func drop_allowFailures() throws {
		var src: Substring = "abc123"
		let pred = many1(.whitespace).drop(allowFailures: true)
		#expect(try pred.parse(&src) != nil)
		#expect(src == "abc123")
	}

	@Test
	func drop_disallowFailures() throws {
		var src: Substring = "abc123"
		let pred = many1(.whitespace).drop(allowFailures: false)
		#expect(try pred.parse(&src) == nil)
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
		#expect(try parser.parse(&input) == output)
		#expect(input.isEmpty)
	}

	@Test
	func then() throws {
		do {
			var src: Substring = "abc"
			#expect(try (char(.exact("a")) <+> char(.exact("b"))).parse(&src) == "ab")
			#expect(src == "c")
		}

		do {
			var src: Substring = "abc"
			#expect(try (char(.exact("a")) <+> char(.exact("¿"))).parse(&src) == nil)
			#expect(src == "abc")
		}

		do {
			var src: Substring = "abc"
			#expect(try (char(.exact("¿")) <+> char(.exact("b"))).parse(&src) == nil)
			#expect(src == "abc")
		}

		do {
			var src: Substring = "abc"
			#expect(try (char(.exact("¿")) <+> char(.exact("¿"))).parse(&src) == nil)
			#expect(src == "abc")
		}
	}

	@Test
	func wrapped_successful() throws {
		var src: Substring = "[abc]def"

		#expect(try wrap("[", "]", many1(.visible)).parse(&src) == "abc")
		#expect(src == "def")
	}

	@Test
	func wrapped_successfulNested() throws {
		var src: Substring = "[(abc)]def"
		let pred = wrap("[", "]", wrap("(", ")", many1(.visible)))
		#expect(try pred.parse(&src) == "abc")
		#expect(src == "def")
	}

	@Test
	func wrapped_failedInner() throws {
		var src: Substring = "[a c]"
		#expect(try wrap("[", "]", many1(.visible)).parse(&src) == nil)
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
		#expect(try wrap("[", "]", many1(.visible)).parse(&src) == nil)
		#expect(src == "(abc]")
	}

	@Test
	func wrapped_failedTrailing() throws {
		var src: Substring = "[abc)"
		#expect(try wrap("[", "]", many1(.visible)).parse(&src) == nil)
		#expect(src == "[abc)")
	}

	@Test
	func prefix_successful() throws {
		var src: Substring = "|abc"
		#expect(try prefix("|", many1(.visible)).parse(&src) == "abc")
		#expect(src.isEmpty)
	}

	@Test
	func prefix_failed() throws {
		var src: Substring = "<abc"
		#expect(try prefix("|", many1(.visible)).parse(&src) == nil)
		#expect(src == "<abc")
	}

	@Test
	func postfix_successful() throws {
		var src: Substring = "abc|"
		#expect(try postfix("|", many1(.visible)).parse(&src) == "abc")
		#expect(src.isEmpty)
	}

	@Test
	func postfix_failed() throws {
		var src: Substring = "abc>"
		#expect(try postfix("|", many1(.visible)).parse(&src) == nil)
		#expect(src == "abc>")
	}

	@Test
	func anyPredicate() throws {
		let pred = many1(.numeral) <||> char(.exact("x"))

		var src: Substring = "x123a"
		#expect(try pred.parse(&src) == "x")
		#expect(try pred.parse(&src) == "123")
		#expect(try pred.parse(&src) == nil)
		#expect(src == "a")
	}

	@Test
	func anyPredicateRethrows() throws {
		let pred = many1(.numeral) <*> { _ in throw TestError() } <||> char(.exact("x"))

		var src: Substring = "x123a"
		#expect(try pred.parse(&src) == "x")
		#expect(throws: TestError()) { try pred.parse(&src) == "123" }
		#expect(src == "123a")
	}

	@Test
	func compoundPredicate() throws {
		let pred = (char(.exact("a")) <||> char(.exact("b")) <||> char(.exact("c"))) <+>
			many1(.whitespace).drop() <+>
			many1(.numeral)

		#expect(try apply(pred, "a 12") == "a12")
		#expect(try apply(pred, "b16") == "b16")
		#expect(try apply(pred, "c\t\t19") == "c19")
		#expect(try apply(pred, "d25") == nil)
	}
}

fileprivate func apply(_ predicate: some Parser<Substring>, _ src: String) throws -> Substring? {
	var src = src[...]
	return try predicate.parse(&src)
}
