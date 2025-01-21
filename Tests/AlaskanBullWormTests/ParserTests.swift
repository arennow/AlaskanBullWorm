import AlaskanBullWorm
import Testing

struct ParserTests {
	@Test
	func basicParse() {
		let parser = CharPredicate.numeral <*> { Int($0) }

		var src: Substring = "123abc"
		#expect(parser.parse(&src) == 123)
		#expect(src == "abc")
	}

	@Test
	func failedTransformDoesntTake() {
		let parser = CharPredicate.numeral <*> { _ in Optional<Int>.none }

		var src: Substring = "123abc"
		#expect(parser(&src) == nil)
		#expect(src == "123abc")
	}

	@Test
	func exactStringParse() {
		let parser = ExactStringPredicate("abc") <*> { String($0) }

		var src: Substring = "abcdef"
		#expect(parser(&src) == "abc")
		#expect(src == "def")
	}

	@Test
	func anyParser() {
		let exactP = CharPredicate.numeral <*> { Int($0) }
		let doubleP = CharPredicate.char("d").drop() <+> CharPredicate.numeral <*> { Int($0).map { $0 * 2 } }
		let tripleP = CharPredicate.char("t").drop() <+> CharPredicate.numeral <*> { Int($0).map { $0 * 3 } }
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
		let parser = many1(CharPredicate.asciiLetter <&> CharPredicate.numeral)
		var src: Substring = "abc123def456"
		#expect(parser.parse(&src) == [["abc", "123"], ["def", "456"]])
		#expect(src.isEmpty)
	}

	@Test
	func and_compound() {
		let parser = CharPredicate.asciiLetter <&> CharPredicate.numeral <&> CharPredicate.char(";")
		var src: Substring = "abc123;def"
		#expect(parser.parse(&src) == ["abc", "123", ";"])
		#expect(src == "def")
	}
}
