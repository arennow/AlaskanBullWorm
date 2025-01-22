public struct Many0Adapter<Output>: Parser {
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

public struct Many1Adapter<Output>: Parser {
	let innerParser: any Parser<Output>

	public init(_ innerParser: any Parser<Output>) {
		self.innerParser = innerParser
	}

	public func parse(_ input: inout Substring) -> Array<Output>? {
		let before = input
		guard let zeroOut = Many0Adapter(self.innerParser).parse(&input),
			  !zeroOut.isEmpty
		else {
			input = before
			return nil
		}
		return zeroOut
	}
}

public typealias many0<T> = Many0Adapter<T>
public typealias many1<T> = Many1Adapter<T>
