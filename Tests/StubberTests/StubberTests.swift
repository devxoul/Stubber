import XCTest
@testable import Stubber

class StubberTests: XCTestCase {
  func testExample() {
    let userService = StubUserService()
    Stubber.stub(userService.follow) { userID in "stub-follow-\(userID)" }
    XCTAssertEqual(userService.follow(userID: 123), "stub-follow-123")
    XCTAssertEqual(Stubber.executions(userService.follow).count, 1)
    XCTAssertEqual(Stubber.executions(userService.follow)[0].arguments, 123)
    XCTAssertEqual(Stubber.executions(userService.follow)[0].result, "stub-follow-123")

    Stubber.stub(userService.follow) { userID in "new-stub-follow-\(userID)" }
    XCTAssertEqual(userService.follow(userID: 456), "new-stub-follow-456")
    XCTAssertEqual(Stubber.executions(userService.follow).count, 1)
    XCTAssertEqual(Stubber.executions(userService.follow)[0].arguments, 456)
    XCTAssertEqual(Stubber.executions(userService.follow)[0].result, "new-stub-follow-456")

    Stubber.clear()
    XCTAssertEqual(Stubber.executions(userService.follow).isEmpty, true)
  }
}

protocol UserServiceType {
  func follow(userID: Int) -> String
  func unfollow(userID: Int) -> String
}

final class StubUserService: UserServiceType {
  func follow(userID: Int) -> String {
    return Stubber.stubbed(follow, args: userID)
  }

  func unfollow(userID: Int) -> String {
    return Stubber.stubbed(unfollow, args: userID)
  }
}
