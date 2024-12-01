// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode2024",
    products: [
        .executable(name: "Day01", targets: ["Day01"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "Day01",
            dependencies: [],
            resources: [.process("input.txt")]
        ),
        .testTarget(name: "Day01Tests", dependencies: ["Day01"], path: "Tests/Day01"),
    ]
)
