prefix func ! <T>(_ p: @Sendable @escaping (T) -> Bool) -> @Sendable (T) -> Bool { { !p($0) } }
func && <T>(_ l: @Sendable @escaping (T) -> Bool, _ r: @Sendable @escaping (T) -> Bool) -> @Sendable (T) -> Bool { { l($0) && r($0) } }

func checkPair<L: Parser, R: Parser>(_ input: inout Substring, _ l: L, _ r: R) -> (L.Output, R.Output)? {
	guard let lResult = l.parse(&input),
		  let rResult = r.parse(&input)
	else { return nil }
	return (lResult, rResult)
}
