import XCTest
@testable import MallocTrace

final class MallocTraceTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MallocTrace().text, "Hello, World!")
    }
}
