public enum CharacterPredicate: Sendable, IntoPredicate {
	case custom(@Sendable (Character) -> Bool)
	case any
	case anyExcept(Character)
	case exact(Character)
	case visible
	case whitespace
	case asciiLetter
	/// ASCII characters that can be used in general-purpose identifiers.
	/// Equivalent to `[A-Za-z_\-]+`
	case asciiIdentifier
	case numeral

	public func into() -> @Sendable (Character) -> Bool {
		switch self {
			case .custom(let p): p
			case .any: { _ in true }
			case .anyExcept(let c): { $0 != c }
			case .exact(let c): { $0 == c }
			case .visible: !\.isWhitespace
			case .whitespace: \.isWhitespace
			case .asciiLetter: \.isASCII && \.isLetter
			case .asciiIdentifier: Self.asciiLetter.into() || { ["_", "-"].contains($0) }
			case .numeral: \.isWholeNumber
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
