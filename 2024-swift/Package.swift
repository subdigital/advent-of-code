// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode2024",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: "Day01", targets: ["Day01"]),
        .executable(name: "Day02", targets: ["Day02"]),
        .library(name: "AOCHelper", targets: ["AOCHelper"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.13.0")
    ],
    targets: [
        .target(name: "AOCHelper"),

        .executableTarget(
            name: "Day01",
            dependencies: [
                "AOCHelper",
            ],
            resources: [.process("input.txt")]
        ),
        .testTarget(name: "Day01Tests", dependencies: ["Day01"], path: "Tests/Day01"),

        .executableTarget(
            name: "Day02",
            dependencies: [
                .product(name: "Parsing", package: "swift-parsing"),
                .target(name: "AOCHelper")
            ],
            resources: [.process("input.txt")]
        ),
        .testTarget(name: "Day02Tests", dependencies: ["Day02"], path: "Tests/Day02"),
    ]
)
