import XCTest
@testable import Stubber

class StubberTests: XCTestCase {
  override func setUp() {
    super.setUp()
    Stubber.clear()
  }

  func test_argument0_defaultNo_returnVoid() {
    // given
    let f = StubClass().argument0_returnVoid_defaultNo
    Stubber.register(f) { _ in }

    // when
    f()

    // then
    XCTAssertEqual(Stubber.executions(f).count, 1)
  }

  func test_argument0_defaultVoid_returnVoid() {
    // given
    let f = StubClass().argument0_returnVoid_defaultVoid

    // when
    f()
    f()

    // then
    XCTAssertEqual(Stubber.executions(f).count, 2)
  }

  func test_argument1_defaultNo_returnInt() {
    // given
    let f = StubClass().argument1_returnInt_defaultNo
    Stubber.register(f) { _ in 10 }

    // when
    let result = f("Hello")

    // then
    XCTAssertEqual(Stubber.executions(f).count, 1)
    XCTAssertEqual(Stubber.executions(f)[0].arguments, "Hello")
    XCTAssertEqual(Stubber.executions(f)[0].result, 10)
    XCTAssertEqual(result, 10)
  }

  func test_argument1_defaultInt_returnInt() {
    // given
    let f = StubClass().argument1_returnInt_defaultInt

    // when
    let result = f("Hello, default!")

    // then
    XCTAssertEqual(Stubber.executions(f).count, 1)
    XCTAssertEqual(Stubber.executions(f)[0].arguments, "Hello, default!")
    XCTAssertEqual(Stubber.executions(f)[0].result, 0)
    XCTAssertEqual(result, 0)
  }

  func test_argument3_returnOptionalString_defaultNo() {
    // given
    let f = StubClass().argument3_returnOptionalString_defaultNo
    Stubber.register(f) { _ in "Test" }

    // when
    let result = f("Hello", 10, 20)

    // then
    XCTAssertEqual(Stubber.executions(f).count, 1)
    XCTAssertEqual(Stubber.executions(f)[0].arguments.0, "Hello")
    XCTAssertEqual(Stubber.executions(f)[0].arguments.1, 10)
    XCTAssertEqual(Stubber.executions(f)[0].arguments.2, 20)
    XCTAssertEqual(Stubber.executions(f)[0].result, "Test")
    XCTAssertEqual(result, "Test")
  }

  func test_argument3_returnOptionalString_defaultString() {
    // given
    let f = StubClass().argument3_returnOptionalString_defaultString

    // when
    let result = f("Hello", 10, 20)

    // then
    XCTAssertEqual(Stubber.executions(f).count, 1)
    XCTAssertEqual(Stubber.executions(f)[0].arguments.0, "Hello")
    XCTAssertEqual(Stubber.executions(f)[0].arguments.1, 10)
    XCTAssertEqual(Stubber.executions(f)[0].arguments.2, 20)
    XCTAssertEqual(Stubber.executions(f)[0].result, "default")
    XCTAssertEqual(result, "default")
  }

  func test_argument0_returnOptionalInt_defaultNil() {
    // given
    let f = StubClass().argument0_returnOptionalInt_defaultNil

    // when
    let result = f()

    XCTAssertEqual(Stubber.executions(f).count, 1)
    XCTAssertNil(Stubber.executions(f)[0].result)
    XCTAssertNil(result)
  }

  func test_argument2_returnString_defaultNo_throws() {
    // given
    let f = StubClass().argument2_returnString_defaultNo_throws
    Stubber.register(f) { _ in "Stubbed" }

    // when
    let result = try? f("Hello", 30)

    // then
    XCTAssertEqual(Stubber.executions(f).count, 1)
    XCTAssertEqual(Stubber.executions(f)[0].arguments.0, "Hello")
    XCTAssertEqual(Stubber.executions(f)[0].arguments.1, 30)
    XCTAssertEqual(Stubber.executions(f)[0].result, "Stubbed")
    XCTAssertEqual(result, "Stubbed")
  }

  /// ⚠️ Generic is not supported yet.
  func _test_argument_1_generic() {
    // given
    let f: (String) -> String = StubClass().argument_1_generic
    Stubber.register(f) { _ in "Stubbed" }

    // when
    let result = f("Hi")

    // then
    XCTAssertEqual(Stubber.executions(f).count, 1)
    XCTAssertEqual(Stubber.executions(f)[0].arguments, "Hello")
    XCTAssertEqual(Stubber.executions(f)[0].result, "Stubbed")
    XCTAssertEqual(result, "Stubbed")
  }
}
