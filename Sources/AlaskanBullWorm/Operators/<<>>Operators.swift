prefix operator <<
public prefix func << <T>(rhs: some Parser<T>) -> some Parser<T> {
	many0(.whitespace).drop(allowFailures: true) <+> rhs
}

postfix operator >>
public postfix func >> <T>(rhs: some Parser<T>) -> some Parser<T> {
	rhs <+> many0(.whitespace).drop(allowFailures: true)
}
