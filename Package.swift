// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "advent-of-code",
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "advent-of-code",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
            ],
            resources: [
                .copy("resources")
            ]
        ),
        .testTarget(
            name: "advent-of-codeTests",
            dependencies: ["advent-of-code"]),
    ]
)

