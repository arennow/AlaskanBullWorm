import Algorithms

public enum CharPredicate: Parser {
	case _custom((Character) -> Bool)
	case _visible
	case _whitespace
	case _asciiLetter
	case _numeral
	case _char(Character)

	private var rawPredicate: (Character) -> Bool {
		switch self {
			case ._custom(let p): p
			case ._visible: !\.isWhitespace
			case ._whitespace: \.isWhitespace
			case ._asciiLetter: \.isASCII && \.isLetter
			case ._numeral: \.isWholeNumber
			case ._char(let c): { $0 == c }
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
