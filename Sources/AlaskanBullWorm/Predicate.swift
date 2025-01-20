public protocol Predicate {
	func parse(_ input: inout Substring) -> Substring?
}

public extension Predicate where Self == CharPredicate {
	static func custom(_ filter: @escaping (Character) -> Bool) -> Self { ._custom(filter) }
	static func char(_ c: Character) -> Self { ._char(c) }

	static var visible: Self { ._visible }
	static var whitespace: Self { ._whitespace }
	static var asciiLetter: Self { ._asciiLetter }
	static var numeral: Self { ._numeral }
}

public extension Predicate where Self == ExactStringPredicate {
	static func exact(_ needle: String) -> ExactStringPredicate {
		ExactStringPredicate(needle)
	}
}
