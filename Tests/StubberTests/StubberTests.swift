import XCTest
@testable import Stubber

class StubberTests: XCTestCase {
  override func setUp() {
    super.setUp()
    Stubber.clear()
  }

  func testExample() {
    let userService = StubUserService()

    Stubber.register(userService.follow) { userID in "stub-follow-\(userID)" }
    XCTAssertEqual(userService.follow(userID: 123), "stub-follow-123")
    XCTAssertEqual(Stubber.executions(userService.follow).count, 1)
    XCTAssertEqual(Stubber.executions(userService.follow)[0].arguments, 123)
    XCTAssertEqual(Stubber.executions(userService.follow)[0].result, "stub-follow-123")

    Stubber.register(userService.follow) { userID in "new-stub-follow-\(userID)" }
    XCTAssertEqual(userService.follow(userID: 456), "new-stub-follow-456")
    XCTAssertEqual(Stubber.executions(userService.follow).count, 1)
    XCTAssertEqual(Stubber.executions(userService.follow)[0].arguments, 456)
    XCTAssertEqual(Stubber.executions(userService.follow)[0].result, "new-stub-follow-456")

    Stubber.clear()
    XCTAssertEqual(Stubber.executions(userService.follow).isEmpty, true)

    Stubber.register(userService.unfollow) { userID in "stub-unfollow-\(userID)" }
    XCTAssertEqual(try! userService.unfollow(userID: 789), "stub-unfollow-789")
    XCTAssertEqual(Stubber.executions(userService.unfollow)[0].arguments, 789)
    XCTAssertEqual(Stubber.executions(userService.unfollow)[0].result, "stub-unfollow-789")
  }

  func testNoArgument() {
    let userService = StubUserService()
    let articleService = StubArticleService()
    Stubber.register(userService.foo) { "User" }
    Stubber.register(articleService.bar) { "Article" }
    XCTAssertEqual(userService.foo(), "User")
    XCTAssertEqual(articleService.bar(), "Article")
    XCTAssertEqual(Stubber.executions(userService.foo).count, 1)
    XCTAssertEqual(Stubber.executions(articleService.bar).count, 1)
  }
}

protocol UserServiceType {
  func foo() -> String
  func follow(userID: Int) -> String
  func unfollow(userID: Int) throws -> String
}

protocol ArticleServiceType {
  func bar() -> String
  func like(articleID: Int) -> String
}

final class StubUserService: UserServiceType {
  func foo() -> String {
    return Stubber.invoke(foo, args: ())
  }

  func follow(userID: Int) -> String {
    return Stubber.invoke(follow, args: userID)
  }

  func unfollow(userID: Int) throws -> String {
    return try Stubber.invoke(unfollow, args: userID)
  }
}

final class StubArticleService: ArticleServiceType {
  func bar() -> String {
    return Stubber.invoke(bar, args: ())
  }

  func like(articleID: Int) -> String {
    return Stubber.invoke(like, args: articleID)
  }
}
