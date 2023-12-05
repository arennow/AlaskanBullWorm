@testable import AlaskanBullWorm
import XCTest

final class AlaskanBullWormTests: XCTestCase {
	func testProcessLine_multiple() throws {
		let src = "123\n456\n789"
		var abm = AlaskanBullWorm(source: src)

		let num = try abm.processLine { line in
			XCTAssertEqual(line, "123")
			return Int(line)
		}
		XCTAssertEqual(num, 123)
		XCTAssertEqual(abm.remainder, "456\n789")
	}

	func testProcessLine_single() throws {
		let src = "123"
		var abm = AlaskanBullWorm(source: src)

		let num = try abm.processLine { line in
			XCTAssertEqual(line, "123")
			return Int(line)
		}
		XCTAssertEqual(num, 123)
		XCTAssertEqual(abm.remainder, "")
	}

	func testProcessLine_empty() {
		var abm = AlaskanBullWorm(source: "")

		XCTAssertThrowsError(try abm.processLine { _ in }) { error in
			guard let abmError = error as? AlaskanBullWorm.Errors else {
				XCTFail("Unexpected error type")
				return
			}
			XCTAssertEqual(abmError, AlaskanBullWorm.Errors.notEnoughRemainder)
		}
		XCTAssertEqual(abm.remainder, "")
	}
}
