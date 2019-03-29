// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "Stubber",
  platforms: [
    .macOS(.v10_10), .iOS(.v8), .tvOS(.v9), .watchOS(.v2)
  ],
  products: [
    .library(name: "Stubber", targets: ["Stubber"]),
  ],
  targets: [
    .target(name: "Stubber"),
    .testTarget(name: "StubberTests", dependencies: ["Stubber"]),
  ],
  swiftLanguageVersions: [.v5]
)
