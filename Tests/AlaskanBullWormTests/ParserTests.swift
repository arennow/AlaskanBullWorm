import AlaskanBullWorm
import Testing

struct ParserTests {
	@Test
	func basicParse() {
		let parser = .numeral <*> { Int($0) }

		var src: Substring = "123abc"
		#expect(parser(&src) == 123)
		#expect(src == "abc")
	}

	@Test
	func failedTransformDoesntTake() {
		let parser = .numeral <*> { _ in Optional<Int>.none }

		var src: Substring = "123abc"
		#expect(parser(&src) == nil)
		#expect(src == "123abc")
	}

	@Test
	func exactStringParse() {
		let parser = .exact("abc") <*> { String($0) }

		var src: Substring = "abcdef"
		#expect(parser(&src) == "abc")
		#expect(src == "def")
	}

	@Test
	func anyParser() {
		let exactP = .numeral <*> { Int($0) }
		let doubleP = .char("d").drop().then(.numeral) <*> { Int($0).map { $0 * 2 } }
		let tripleP = .char("t").drop().then(.numeral) <*> { Int($0).map { $0 * 3 } }
		let allP = exactP <||> doubleP <||> tripleP

		var src: Substring = "10d10t10"
		#expect(allP.parse(&src) == 10)
		#expect(allP.parse(&src) == 20)
		#expect(allP.parse(&src) == 30)
		#expect(src.isEmpty)
	}

	@Test
	func many0Parser() {
		let manyP = many0(.exact("abc") <*> { String($0) })

		var src: Substring = "abcabcabcabc"
		#expect(manyP.parse(&src)?.count == 4)
		#expect(src.isEmpty)
	}

	@Test
	func many1Parser_success() {
		let manyP = many1(.exact("abc") <*> { String($0) })

		var src: Substring = "abcabcabcabc"
		#expect(manyP.parse(&src)?.count == 4)
		#expect(src.isEmpty)
	}

	@Test
	func many1Parser_failure() {
		let manyP = many1(.exact("abc") <*> { String($0) })

		var src: Substring = "def"
		#expect(manyP.parse(&src) == nil)
		#expect(src == "def")
	}

	@Test
	func asmLine() {
		enum Instruction: String {
			case cp, call, add

			init?(rawValue: Substring) {
				self.init(rawValue: String(rawValue))
			}
		}

		enum Location: Equatable {
			case literal(Int), register(String)
			init?(string: some StringProtocol) {
				switch string.first {
					case "$": self = .literal(Int(string.dropFirst())!)
					case "%": self = .register(String(string.dropFirst()))
					default: return nil
				}
			}
		}

		let instructionParser = .asciiLetter <*> Instruction.init(rawValue:)
		let locationPred = CharPredicate.whitespace.drop()
			.then(any(of: .char("$"), .char("%")))
			.then(.visible)
		let locationParser = locationPred <*> Location.init(string:)

		var src: Substring = "cp $5 %raf"

		#expect(instructionParser(&src) == Instruction.cp)
		#expect(src == " $5 %raf")

		#expect(many0(locationParser).parse(&src) == [.literal(5), .register("raf")])
		#expect(src.isEmpty)
	}
}
