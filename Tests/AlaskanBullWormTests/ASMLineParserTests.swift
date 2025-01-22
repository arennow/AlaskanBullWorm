import AlaskanBullWorm
import Testing

struct ASMLineParserTests {
	@Test
	func asmLine() {
		let instructionParser = CharPredicate.asciiLetter <*> Instruction.init(rawValue:)
		let coreLocationPred = CharPredicate.whitespace.drop() <+>
			(CharPredicate.char("$") <||> CharPredicate.char("%")) <+>
			CharPredicate.visible
		let coreLocationParser = coreLocationPred <*> Location.init(string:)

		let innerRelativeLocationPred = postfix(",", coreLocationPred) <&>
			CharPredicate.whitespace.drop() <+>
			coreLocationPred
		let relativeLocationPred = CharPredicate.whitespace.drop() <+> wrap("[", "]", innerRelativeLocationPred)

		let relativeLocationParser = relativeLocationPred <*> Location.init(array:)

		let locationParser = coreLocationParser <||> relativeLocationParser

		var src: Substring = "cp $5 [%raf, $7]"

		#expect(instructionParser(&src) == Instruction.cp)
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
