import Algorithms

public enum CharPredicate: Parser {
	case custom((Character) -> Bool)
	case visible
	case whitespace
	case asciiLetter
	case numeral
	case char(Character)

	private var rawPredicate: (Character) -> Bool {
		switch self {
			case .custom(let p): p
			case .visible: !\.isWhitespace
			case .whitespace: \.isWhitespace
			case .asciiLetter: \.isASCII && \.isLetter
			case .numeral: \.isWholeNumber
			case .char(let c): { $0 == c }
		}
	}

	public func parse(_ src: inout Substring) -> Substring? {
		var rangeEndIndex = src.startIndex

		let indexSequence = chain(src.indices.dropFirst(), CollectionOfOne(src.endIndex))
		for (i, c) in zip(indexSequence, src) {
			if self.rawPredicate(c) {
				rangeEndIndex = i
			} else {
				break
			}
		}

		guard rangeEndIndex > src.startIndex else {
			return nil
		}

		let takenRange = src.startIndex..<rangeEndIndex

		let outSubstring = src[takenRange]
		src.removeSubrange(takenRange)
		return outSubstring
	}
}
