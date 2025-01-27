import AlaskanBullWorm
import Testing

struct ParserTests {
	@Test
	func basicParse() throws {
		let parser = many1(.numeral) <*> { Int($0) }

		var src: Substring = "123abc"
		try #expect(parser.parse(&src) == 123)
		#expect(src == "abc")
	}

	@Test
	func failedTransformDoesntTake() throws {
		let parser = many1(.numeral) <*> { _ in Optional<Int>.none }

		var src: Substring = "123abc"
		try #expect(parser.parse(&src) == nil)
		#expect(src == "123abc")
	}

	@Test
	func throwingTransformDoesntTake() throws {
		let parser = many1(.numeral) <*> { _ in throw TestError() }

		var src: Substring = "123abc"
		#expect(throws: TestError()) { try parser.parse(&src) }
		#expect(src == "123abc")
	}

	@Test
	func exactStringParse() throws {
		let parser = exact("abc") <*> { String($0) }

		var src: Substring = "abcdef"
		try #expect(parser.parse(&src) == "abc")
		#expect(src == "def")
	}

	@Test
	func anyParser() throws {
		let exactP = many1(.numeral) <*> { Int($0) }
		let doubleP = char(.exact("d")).drop(allowFailures: false) <+> many1(.numeral) <*> { Int($0).map { $0 * 2 } }
		let tripleP = char(.exact("t")).drop(allowFailures: false) <+> many1(.numeral) <*> { Int($0).map { $0 * 3 } }
		let allP = exactP <||> doubleP <||> tripleP

		var src: Substring = "10d10t10"
		try #expect(allP.parse(&src) == 10)
		try #expect(allP.parse(&src) == 20)
		try #expect(allP.parse(&src) == 30)
		#expect(src.isEmpty)
	}

	@Test
	func many0Parser() throws {
		let manyP = many0(exact("abc") <*> { String($0) })

		var src: Substring = "abcabcabcabc"
		try #expect(manyP.parse(&src)?.count == 4)
		#expect(src.isEmpty)
	}

	@Test
	func many0CharPredicate() throws {
		let manyP = many0(.numeral)

		var src: Substring = "abc"
		try #expect(manyP.parse(&src) == "")
		#expect(src == "abc")
	}

	@Test
	func many1Parser_success() throws {
		let manyP = many1(exact("abc") <*> { String($0) })

		var src: Substring = "abcabcabcabc"
		try #expect(manyP.parse(&src)?.count == 4)
		#expect(src.isEmpty)
	}

	@Test
	func many1Parser_failure() throws {
		let manyP = many1(exact("abc") <*> { String($0) })

		var src: Substring = "def"
		try #expect(manyP.parse(&src) == nil)
		#expect(src == "def")
	}

	@Test
	func and_simple() throws {
		let parser = many1(many1(.asciiLetter) <&> many1(.numeral))
		var src: Substring = "abc123def456¿"
		try #expect(parser.parse(&src) == [["abc", "123"], ["def", "456"]])
		#expect(src == "¿")
	}

	@Test
	func and_compound() throws {
		let parser = many1(.asciiLetter) <&> many1(.numeral) <&> char(.exact(";"))
		var src: Substring = "abc123;def"
		try #expect(parser.parse(&src) == ["abc", "123", ";"])
		#expect(src == "def")
	}

	@Test
	func char_success() throws {
		var src: Substring = "a1b2"
		try #expect(char(.asciiLetter).parse(&src) == "a")
		#expect(src == "1b2")
		try #expect(char(.asciiLetter).parse(&src) == nil)
		#expect(src == "1b2")
	}

	@Test
	func tupleTransform() throws {
		let intParser = char(.numeral) <*> { Int($0) }
		let additionParser = (intParser, intParser) <*> { $0 + $1 }

		var src: Substring = "45"
		try #expect(additionParser.parse(&src) == 9)
		#expect(src.isEmpty)
	}

	@Test
	func tupleJoin() throws {
		let intParser = char(.numeral) <*> { Int($0) }
		let additionParser = intParser <~> intParser <~> intParser <*> { $0 + $1 + $2 }

		var src: Substring = "456"
		try #expect(additionParser.parse(&src) == 15)
		#expect(src.isEmpty)
	}

	@Test(arguments: [
		Run("abcd", "abc", "d"),
		Run(" abcd", "abc", "d"),
		Run("  abcd", "abc", "d"),
		Run("\t\t\tabcd", "abc", "d"),
	])
	func leftWhitespace(run: Run<Substring>) throws {
		try run.test(<<exact("abc"))
	}

	@Test(arguments: [
		Run("abc", "abc", ""),
		Run("abc ", "abc", ""),
		Run("abc  ", "abc", ""),
		Run("abc\t\t\t\t", "abc", ""),
	])
	func rightWhitespace(run: Run<Substring>) throws {
		try run.test(exact("abc")>>)
	}

	@Test(arguments: [
		Run(" abc", "abc", ""),
		Run(" abc ", "abc", ""),
		Run(" abc  ", "abc", ""),
		Run(" abc\t\t\t\t", "abc", ""),
	])
	func bothWhitespace(run: Run<Substring>) throws {
		try run.test(<<exact("abc")>>)
	}
}
