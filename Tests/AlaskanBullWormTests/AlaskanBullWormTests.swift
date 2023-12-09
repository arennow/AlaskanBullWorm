@testable import AlaskanBullWorm
import XCTest

final class AlaskanBullWormTests: XCTestCase {
	func testProcessLine_multiple() throws {
		let src = "123\n456\n789"
		var abw = AlaskanBullWorm(source: src)

		let num = try abw.processLine { line in
			XCTAssertEqual(line, "123")
			return Int(line)
		}
		XCTAssertEqual(num, 123)
		XCTAssertEqual(abw.remainder, "456\n789")
	}

	func testProcessLine_single() throws {
		let src = "123"
		var abw = AlaskanBullWorm(source: src)

		let num = try abw.processLine { line in
			XCTAssertEqual(line, "123")
			return Int(line)
		}
		XCTAssertEqual(num, 123)
		XCTAssertEqual(abw.remainder, "")
	}

	func testProcessLine_empty() {
		var abw = AlaskanBullWorm(source: "")

		XCTAssertThrowsError(try abw.processLine { _ in }) { error in
			XCTAssert(error is AlaskanBullWorm.Errors.NotEnoughRemiainder)
		}
		XCTAssertEqual(abw.remainder, "")
	}

	func testTakeLinesUntil_middle() throws {
		let src = "123\n456\n\n789"
		var abw = AlaskanBullWorm(source: src)

		let chunk = try abw.takeLines(until: { $0 == "" })
		XCTAssertEqual(chunk, ["123", "456"])
		XCTAssertEqual(abw.remainder, "789")
	}

	func testTakeLinesUntil_end() throws {
		let src = "123\n456\n789"
		var abw = AlaskanBullWorm(source: src)

		let chunk = try abw.takeLines(until: { $0 == "" })
		XCTAssertEqual(chunk, ["123", "456", "789"])
		XCTAssertEqual(abw.remainder, "")
	}

	func testProcessLinesToEnd() throws {
		let src = "123\n456\n789"
		var abw = AlaskanBullWorm(source: src)

		let output = try abw.processLinesToEnd { line in Int(line)! }
		XCTAssertEqual(output, [123, 456, 789])
		XCTAssertEqual(abw.remainder, "")
	}
}
