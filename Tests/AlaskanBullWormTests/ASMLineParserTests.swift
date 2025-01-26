import AlaskanBullWorm
import Testing

struct ASMLineParserTests {
	@Test
	func asmLine() throws {
		let instructionParser = many1(.asciiLetter) <*> Instruction.init(rawValue:)
		let coreLocationPred =
			<<(char(.exact("$")) <||> char(.exact("%"))) <+>
			many1(.visible)
		let coreLocationParser = coreLocationPred <*> Location.init(string:)

		let innerRelativeLocationPred = postfix(",", coreLocationParser) <&>
		<<coreLocationParser
		let relativeLocationPred = <<wrap("[", "]", innerRelativeLocationPred)

		let relativeLocationParser = relativeLocationPred <*> Location.init(array:)

		let locationParser = coreLocationParser <||> relativeLocationParser
		let locationsParser = many0(locationParser)

		let lineParser = instructionParser <~> locationsParser <*> ASMLine.init

		var src: Substring = "cp $5 [%raf, $7]"
		let line = try #require(try lineParser.parse(&src))

		#expect(line.instruction == .cp)
		#expect(line.locations == [.literal(5), .relative(base: .register("raf"), offset: .literal(7))])
		#expect(src.isEmpty)
	}
}

fileprivate struct ASMLine {
	let instruction: Instruction
	let locations: Array<Location>
}

fileprivate enum Instruction: String {
	case cp, call, add

	init?(rawValue: Substring) {
		self.init(rawValue: String(rawValue))
	}
}

fileprivate indirect enum Location: Equatable {
	case literal(Int), register(String), relative(base: Location, offset: Location)
	init?(string: some StringProtocol) {
		switch string.first {
			case "$": self = .literal(Int(string.dropFirst())!)
			case "%": self = .register(String(string.dropFirst()))
			default:
				print("Unparseable string \(string)")
				return nil
		}
	}

	init?(array: Array<Location>) {
		var array = array
		guard let offset = array.popLast(),
			  let base = array.popLast(),
			  array.isEmpty
		else { return nil }

		self = .relative(base: base, offset: offset)
	}
}
