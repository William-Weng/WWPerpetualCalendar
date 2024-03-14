// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWPerpetualCalendar",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "WWPerpetualCalendar", targets: ["WWPerpetualCalendar"]),
    ],
    dependencies: [
        .package(url: "https://github.com/William-Weng/WWOnBoardingViewController.git", from: "1.3.1"),
    ],
    targets: [
        .target(name: "WWPerpetualCalendar", dependencies: ["WWOnBoardingViewController"], resources: [.process("Storyboard"), .copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
