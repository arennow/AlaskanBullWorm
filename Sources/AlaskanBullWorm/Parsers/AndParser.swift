infix operator <&>: AdditionPrecedence

public func <&> <T>(lhs: some Parser<T>, rhs: some Parser<T>) -> some Parser<Array<T>> {
	InlineParser {
		guard let (l, r) = checkAndRestore(&$0, lhs, rhs) else {
			return nil
		}
		return [l, r]
	}
}

public func <&> <T>(lhs: some Parser<Array<T>>, rhs: some Parser<T>) -> some Parser<Array<T>> {
	InlineParser {
		guard var res = checkAndRestore(&$0, lhs, rhs) else {
			return nil
		}
		res.0.append(res.1)
		return res.0
	}
}

fileprivate func checkAndRestore<L: Parser, R: Parser>(_ input: inout Substring, _ l: L, _ r: R) -> (L.Output, R.Output)? {
	let before = input
	guard let lResult = l.parse(&input),
		  let rResult = r.parse(&input)
	else {
		input = before
		return nil
	}
	return (lResult, rResult)
}
