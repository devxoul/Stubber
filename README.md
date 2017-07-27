# Stubber

![Swift](https://img.shields.io/badge/Swift-3.1-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/Stubber.svg)](https://cocoapods.org/pods/Stubber)
[![Build Status](https://travis-ci.org/devxoul/Stubber.svg?branch=master)](https://travis-ci.org/devxoul/Stubber)
[![Codecov](https://img.shields.io/codecov/c/github/devxoul/Stubber.svg)](https://codecov.io/gh/devxoul/Stubber)

A minimal method stub for Swift.

## At a Glance

```swift
import Stubber

final class StubUserService: UserServiceProtocol, Stub {
  func follow(userID: Int) -> String {
    return stubbed(follow, args: userID)
  }

  func edit(userID: Int, name: String) -> Bool {
    return stubbed(edit, args: (userID, name))
  }
}

func testMethodCall() {
  let userService = StubUserService()
  userService.stub(userService.follow) { userID in "stub-\(userID)" } // stub
  userService.follow(userID: 123) // call
  XCTAssertEqual(userService.executions(userService.follow).count, 1)
  XCTAssertEqual(userService.executions(userService.follow)[0].arguments, 123)
  XCTAssertEqual(userService.executions(userService.follow)[0].result, "stub-123")
}
```

## Installation

```ruby
pod 'Stubber'
```

## License

Stubber is under MIT license. See the [LICENSE](LICENSE) for more info.
