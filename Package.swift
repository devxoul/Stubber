// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "Stubber",
  products: [
    .library(name: "Stubber", targets: ["Stubber"]),
  ],
  targets: [
    .target(name: "Stubber"),
    .testTarget(name: "StubberTests", dependencies: ["Stubber"]),
  ]
)
