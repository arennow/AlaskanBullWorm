struct Bookend<Inner: Sequence>: Sequence {
	private let inner: Inner
	private let final: Inner.Element?

	init(_ inner: Inner, with final: Inner.Element) {
		self.inner = inner
		self.final = final
	}

	struct Iterator: IteratorProtocol {
		private var innerIterator: Inner.Iterator
		private var final: Inner.Element?

		fileprivate init(innerIterator: Inner.Iterator, final: Inner.Element? = nil) {
			self.innerIterator = innerIterator
			self.final = final
		}

		mutating func next() -> Inner.Element? {
			self.innerIterator.next() ?? self.final.take()
		}
	}

	func makeIterator() -> Iterator {
		Iterator(innerIterator: self.inner.makeIterator(),
				 final: self.final)
	}
}
