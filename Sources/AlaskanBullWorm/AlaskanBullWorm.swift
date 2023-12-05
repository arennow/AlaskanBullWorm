public struct AlaskanBullWorm {
	public enum Errors: Error {
		case notEnoughRemainder
	}

	private(set) var remainder: Substring

	public init(source: String) {
		self.remainder = source[...]
	}

	public mutating func processLine<R>(_ processor: (Substring) throws -> R) throws -> R {
		let lineEndIndex = try self.indexOfNextLineEnd

		let out = try processor(self.remainder[..<lineEndIndex])
		self.remainder = self.remainder[lineEndIndex...].dropFirst()

		return out
	}

	public mutating func takeLine() throws -> Substring {
		try self.processLine { $0 }
	}

	public mutating func takeLines(until terminationPredicate: (Substring) -> Bool) throws -> Array<Substring> {
		var out = Array<Substring>()

		repeat {
			let line = try self.takeLine()
			if terminationPredicate(line) { break }
			out.append(line)
		} while !self.remainder.isEmpty

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
