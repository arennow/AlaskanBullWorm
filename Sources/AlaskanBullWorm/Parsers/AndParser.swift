infix operator <&>: AdditionPrecedence

public func <&> <T>(lhs: some Parser<T>, rhs: some Parser<T>) -> some Parser<Array<T>> {
	InlineParser {
		guard let (l, r) = check(&$0, lhs, rhs) else {
			return nil
		}
		return [l, r]
	}
}

public func <&> <T>(lhs: some Parser<Array<T>>, rhs: some Parser<T>) -> some Parser<Array<T>> {
	InlineParser {
		guard var res = check(&$0, lhs, rhs) else {
			return nil
		}
		res.0.append(res.1)
		return res.0
	}
}

fileprivate func check<L: Parser, R: Parser>(_ input: inout Substring, _ l: L, _ r: R) -> (L.Output, R.Output)? {
	guard let lResult = l.parse(&input),
		  let rResult = r.parse(&input)
	else { return nil }
	return (lResult, rResult)
}
