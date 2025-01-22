import AlaskanBullWorm
import Testing

struct ASMLineParserTests {
	@Test
	func asmLine() {
		let instructionParser = many1(.asciiLetter) <*> Instruction.init(rawValue:)
		let coreLocationPred = many1(.whitespace).drop() <+>
			(char(.exact("$")) <||> char(.exact("%"))) <+>
			many1(.visible)
		let coreLocationParser = coreLocationPred <*> Location.init(string:)

		let innerRelativeLocationPred = postfix(",", coreLocationPred) <&>
			many1(.whitespace).drop() <+>
			coreLocationPred
		let relativeLocationPred = many1(.whitespace).drop() <+> wrap("[", "]", innerRelativeLocationPred)

		let relativeLocationParser = relativeLocationPred <*> Location.init(array:)

		let locationParser = coreLocationParser <||> relativeLocationParser

		var src: Substring = "cp $5 [%raf, $7]"

		#expect(instructionParser.parse(&src) == Instruction.cp)
		#expect(src == " $5 [%raf, $7]")

		#expect(many0(locationParser).parse(&src) == [.literal(5), .relative])
		#expect(src.isEmpty)
	}
}

fileprivate enum Instruction: String {
	case cp, call, add

	init?(rawValue: Substring) {
		self.init(rawValue: String(rawValue))
	}
}

fileprivate enum Location: Equatable {
	case literal(Int), register(String), relative
	init?(string: some StringProtocol) {
		switch string.first {
			case "$": self = .literal(Int(string.dropFirst())!)
			case "%": self = .register(String(string.dropFirst()))
			case "[": self = .relative
			default:
				print("Unparseable string \(string)")
				return nil
		}
	}

	init?(array: Array<some StringProtocol>) {
		self = .relative
	}
}
