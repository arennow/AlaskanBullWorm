public enum Predicate {
	case visible
	case whitespace
	case char(Character)

	public var rawPredicate: AlaskanBullWorm.RawPredicate {
		switch self {
			case .visible: !\.isWhitespace
			case .whitespace: \.isWhitespace
			case .char(let c): { $0 == c }
		}
	}
}
