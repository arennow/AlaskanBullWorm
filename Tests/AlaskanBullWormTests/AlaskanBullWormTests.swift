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
			XCTAssert(error is AlaskanBullWorm.Errors.NotEnoughRemiainder)
		}
		XCTAssertEqual(abm.remainder, "")
	}

	func testTakeLinesUntil_middle() throws {
		let src = "123\n456\n\n789"
		var abm = AlaskanBullWorm(source: src)

		let chunk = try abm.takeLines(until: { $0 == "" })
		XCTAssertEqual(chunk, ["123", "456"])
		XCTAssertEqual(abm.remainder, "789")
	}

	func testTakeLinesUntil_end() throws {
		let src = "123\n456\n789"
		var abm = AlaskanBullWorm(source: src)

		let chunk = try abm.takeLines(until: { $0 == "" })
		XCTAssertEqual(chunk, ["123", "456", "789"])
		XCTAssertEqual(abm.remainder, "")
	}

	func testProcessLinesToEnd() throws {
		let src = "123\n456\n789"
		var abm = AlaskanBullWorm(source: src)

		let output = try abm.processLinesToEnd { line in Int(line)! }
		XCTAssertEqual(output, [123, 456, 789])
		XCTAssertEqual(abm.remainder, "")
	}
}
