prefix func ! <T>(_ p: @Sendable @escaping (T) -> Bool) -> @Sendable (T) -> Bool { { !p($0) } }
func && <T>(_ l: @Sendable @escaping (T) -> Bool, _ r: @Sendable @escaping (T) -> Bool) -> @Sendable (T) -> Bool { { l($0) && r($0) } }
func || <T>(_ l: @Sendable @escaping (T) -> Bool, _ r: @Sendable @escaping (T) -> Bool) -> @Sendable (T) -> Bool { { l($0) || r($0) } }

func checkPair<L: Parser, R: Parser>(_ input: inout Substring, _ l: L, _ r: R) throws -> (L.Output, R.Output)? {
	guard let lResult = try l.parse(&input),
		  let rResult = try r.parse(&input)
	else { return nil }
	return (lResult, rResult)
}
