struct AlaskanBullWorm {
	enum Errors: Error {
		case notEnoughRemainder
	}

	private(set) var remainder: Substring

	init(source: String) {
		self.remainder = source[...]
	}

	mutating func processLine<R>(_ processor: (Substring) throws -> R) throws -> R {
		let lineEndIndex = try self.indexOfNextLineEnd

		let out = try processor(self.remainder[..<lineEndIndex])
		self.remainder = self.remainder[lineEndIndex...].dropFirst()

		return out
	}
}

private extension AlaskanBullWorm {
	var indexOfNextLineEnd: Substring.Index {
		get throws {
			guard !self.remainder.isEmpty else { throw Errors.notEnoughRemainder }
			return self.remainder.firstIndex(of: "\n") ?? self.remainder.endIndex
		}
	}
}
