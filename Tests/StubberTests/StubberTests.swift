import XCTest
@testable import Stubber

class StubberTests: XCTestCase {
  func testExample() {
    let userService = StubUserService()
    userService.stub(userService.follow) { userID in "stub-follow-\(userID)" }
    XCTAssertEqual(userService.follow(userID: 123), "stub-follow-123")
  }
}

protocol UserServiceType {
  func follow(userID: Int) -> String
  func unfollow(userID: Int) -> String
}

final class StubUserService: UserServiceType, Stub {
  func follow(userID: Int) -> String {
    return self.stubbed(follow, args: userID)
  }

  func unfollow(userID: Int) -> String {
    return self.stubbed(unfollow, args: userID)
  }
}
