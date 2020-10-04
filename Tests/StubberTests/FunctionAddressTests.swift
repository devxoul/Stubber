//
//  FunctionAddressTests.swift
//  StubberTests
//
//  Created by Suyeol Jeon on 2020/10/04.
//

import XCTest
@testable import Stubber

class FunctionAddressTests: XCTestCase {
  func test_argument0_defaultNo_returnVoid() {
    XCTAssertEqual(
      functionAddress(of: StubClass().argument0_returnVoid_defaultNo),
      functionAddress(of: StubClass().argument0_returnVoid_defaultNo)
    )
  }
}
