// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let days = [
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
]

func dayName(_ day: Int) -> String {
    "Day\(String(format: "%02d", day))"
}

func executable(day: Int) -> Product {
    let name = dayName(day)
    return .executable(name: name, targets: [name])
}

func target(day: Int) -> [Target] {
    let name = dayName(day)
    return [
        .executableTarget(
            name: name,
            dependencies: [
                .product(name: "Parsing", package: "swift-parsing"),
                .target(name: "AOCHelper")
            ],
            resources: [.process("input.txt")]
        ),
        .testTarget(
            name: "\(name)Tests",
            dependencies: [ .target(name: name) ],
            path: "Tests/\(name)"
        ),
    ]
}

let dayProducts = days.map(executable)
let dayTargets = days.flatMap(target)

let package = Package(
    name: "AdventOfCode2024",
    platforms: [.macOS(.v14), .iOS(.v16)],
    products: dayProducts + [
        .library(name: "AOCHelper", targets: ["AOCHelper"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.13.0")
    ],
    targets: dayTargets + [
        .target(name: "AOCHelper")
    ]
)
