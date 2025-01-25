infix operator <&>: AdditionPrecedence

public func <&> <T>(lhs: some Parser<T>, rhs: some Parser<T>) -> some Parser<Array<T>> {
	InlineParser {
		guard let (l, r) = try checkPair(&$0, lhs, rhs) else {
			return nil
		}
		return [l, r]
	}
}

public func <&> <T>(lhs: some Parser<Array<T>>, rhs: some Parser<T>) -> some Parser<Array<T>> {
	InlineParser {
		guard var res = try checkPair(&$0, lhs, rhs) else {
			return nil
		}
		res.0.append(res.1)
		return res.0
	}
}
