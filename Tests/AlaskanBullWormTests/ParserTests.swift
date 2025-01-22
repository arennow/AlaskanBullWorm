import AlaskanBullWorm
import Testing

struct ParserTests {
	@Test
	func basicParse() {
		let parser = many1(.numeral) <*> { Int($0) }

		var src: Substring = "123abc"
		#expect(parser.parse(&src) == 123)
		#expect(src == "abc")
	}

	@Test
	func failedTransformDoesntTake() {
		let parser = many1(.numeral) <*> { _ in Optional<Int>.none }

		var src: Substring = "123abc"
		#expect(parser.parse(&src) == nil)
		#expect(src == "123abc")
	}

	@Test
	func exactStringParse() {
		let parser = ExactStringPredicate("abc") <*> { String($0) }

		var src: Substring = "abcdef"
		#expect(parser.parse(&src) == "abc")
		#expect(src == "def")
	}

	@Test
	func anyParser() {
		let exactP = many1(.numeral) <*> { Int($0) }
		let doubleP = char(.exact("d")).drop(allowFailures: false) <+> many1(.numeral) <*> { Int($0).map { $0 * 2 } }
		let tripleP = char(.exact("t")).drop(allowFailures: false) <+> many1(.numeral) <*> { Int($0).map { $0 * 3 } }
		let allP = exactP <||> doubleP <||> tripleP

		var src: Substring = "10d10t10"
		#expect(allP.parse(&src) == 10)
		#expect(allP.parse(&src) == 20)
		#expect(allP.parse(&src) == 30)
		#expect(src.isEmpty)
	}

	@Test
	func many0Parser() {
		let manyP = many0(ExactStringPredicate("abc") <*> { String($0) })

		var src: Substring = "abcabcabcabc"
		#expect(manyP.parse(&src)?.count == 4)
		#expect(src.isEmpty)
	}

	@Test
	func many1Parser_success() {
		let manyP = many1(ExactStringPredicate("abc") <*> { String($0) })

		var src: Substring = "abcabcabcabc"
		#expect(manyP.parse(&src)?.count == 4)
		#expect(src.isEmpty)
	}

	@Test
	func many1Parser_failure() {
		let manyP = many1(ExactStringPredicate("abc") <*> { String($0) })

		var src: Substring = "def"
		#expect(manyP.parse(&src) == nil)
		#expect(src == "def")
	}

	@Test
	func and_simple() {
		let parser = many1(many1(.asciiLetter) <&> many1(.numeral))
		var src: Substring = "abc123def456¿"
		#expect(parser.parse(&src) == [["abc", "123"], ["def", "456"]])
		#expect(src == "¿")
	}

	@Test
	func and_compound() {
		let parser = many1(.asciiLetter) <&> many1(.numeral) <&> char(.exact(";"))
		var src: Substring = "abc123;def"
		#expect(parser.parse(&src) == ["abc", "123", ";"])
		#expect(src == "def")
	}

	@Test
	func char_success() {
		var src: Substring = "a1b2"
		#expect(char(.asciiLetter).parse(&src) == "a")
		#expect(src == "1b2")
		#expect(char(.asciiLetter).parse(&src) == nil)
		#expect(src == "1b2")
	}
}
