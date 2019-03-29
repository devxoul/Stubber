# Stubber

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/Stubber.svg)](https://cocoapods.org/pods/Stubber)
[![Build Status](https://travis-ci.org/devxoul/Stubber.svg?branch=master)](https://travis-ci.org/devxoul/Stubber)
[![Codecov](https://img.shields.io/codecov/c/github/devxoul/Stubber.svg)](https://codecov.io/gh/devxoul/Stubber)

A minimal method stub for Swift.

## At a Glance

```swift
import Stubber

final class StubUserService: UserServiceProtocol {
  func follow(userID: Int) -> String {
    return Stubber.invoke(follow, args: userID)
  }

  func edit(userID: Int, name: String) -> Bool {
    return Stubber.invoke(edit, args: (userID, name))
  }
}

func testMethodCall() {
  // given 
  let userService = StubUserService()
  Stubber.register(userService.follow) { userID in "stub-\(userID)" } // stub
  
  // when
  userService.follow(userID: 123) // call
  
  // then
  XCTAssertEqual(Stubber.executions(userService.follow).count, 1)
  XCTAssertEqual(Stubber.executions(userService.follow)[0].arguments, 123)
  XCTAssertEqual(Stubber.executions(userService.follow)[0].result, "stub-123")
}
```

## Escaping Parameters

When a function contains an escaped parameter, use `escaping()` on arguments.

```diff
 func request(path: String, completion: @escaping (Result) -> Void) {
-  Stubber.invoke(request, args: (path, completion))
+  Stubber.invoke(request, args: escaping(path, completion))
 }
```

## Installation

```ruby
pod 'Stubber'
```

## License

Stubber is under MIT license. See the [LICENSE](LICENSE) for more info.
