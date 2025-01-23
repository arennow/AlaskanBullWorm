extension Sequence {
	func mapUntilNil<T, E: Error>(_ transform: (Element) throws(E) -> T?) throws(E) -> Array<T> {
		var outArr = Array<T>()
		for element in self {
			if let new = try transform(element) {
				outArr.append(new)
			} else {
				break
			}
		}
		return outArr
	}
}
