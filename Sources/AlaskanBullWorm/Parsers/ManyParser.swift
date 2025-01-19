public struct Many0Parser<Output>: Parser {
	let innerParser: any Parser<Output>

	public init(_ innerParser: any Parser<Output>) {
		self.innerParser = innerParser
	}

	public func parse(_ input: inout Substring) -> Array<Output>? {
		(0...).mapUntilNil { _ in
			self.innerParser.parse(&input)
		}
	}
}

public struct Many1Parser<Output>: Parser {
	let innerParser: any Parser<Output>

	public init(_ innerParser: any Parser<Output>) {
		self.innerParser = innerParser
	}

	public func parse(_ input: inout Substring) -> Array<Output>? {
		let before = input
		guard let zeroOut = Many0Parser(self.innerParser).parse(&input),
			  !zeroOut.isEmpty
		else {
			input = before
			return nil
		}
		return zeroOut
	}
}

public typealias many0<T> = Many0Parser<T>
public typealias many1<T> = Many1Parser<T>

extension Sequence {
	func mapUntilNil<T, E: Error>(_ transform: (Element) throws(E) -> T?) throws(E) -> Array<T> {
		var outArr = Array<T>()
		for element in self {
			if let new = try transform(element) {
				outArr.append(new)
			} else {
				break
			}
		}
		return outArr
	}
}
