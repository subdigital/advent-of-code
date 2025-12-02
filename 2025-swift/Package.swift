// swift-tools-version: 6.2

import PackageDescription
import Foundation

let days = [
    1
]

func dayName(_ day: Int) -> String {
    let d = day < 10 ? "0\(day)" : "\(day)"
    return "Day\(d)"
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
            resources: [
                .process("input.txt")
            ]
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
    name: "AdventOfCode2025",
    platforms: [.macOS(.v15), .iOS(.v26)],
    products: dayProducts + [
        .library(name: "AOCHelper", targets: ["AOCHelper"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.14.1")
    ],
    targets: dayTargets + [
        .target(name: "AOCHelper")
    ]
)
