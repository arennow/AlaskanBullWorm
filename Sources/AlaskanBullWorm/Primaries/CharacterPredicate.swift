public enum CharacterPredicate: IntoPredicate {
	case custom((Character) -> Bool)
	case visible
	case whitespace
	case asciiLetter
	case numeral
	case char(Character)

	public func into() -> (Character) -> Bool {
		switch self {
			case .custom(let p): p
			case .visible: !\.isWhitespace
			case .whitespace: \.isWhitespace
			case .asciiLetter: \.isASCII && \.isLetter
			case .numeral: \.isWholeNumber
			case .char(let c): { $0 == c }
		}
	}
}

public func char(_ pred: CharacterPredicate) -> some Parser<Substring> {
	InlineParser { input in
		guard let first = input.first else { return nil }
		if pred.into()(first) {
			let out = input[..<input.index(after: input.startIndex)]
			input.removeFirst()
			return out
		} else {
			return nil
		}
	}
}
