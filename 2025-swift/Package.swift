// swift-tools-version: 6.2

import PackageDescription
import Foundation

func getDays() throws -> [Int] {
    if ProcessInfo.processInfo.environment["AUTODETECT_PACKAGES"] == "1" {
        print("Autodetecting packages")
        let days = try FileManager.default.contentsOfDirectory(atPath: ".")
                .filter { $0.starts(with: "Day") }
                .map { $0.replacingOccurrences(of: "Day", with: "") }
                .map(Int.init)
                .compactMap { $0 }
                .sorted()
        return days
    } else {
        // this dynamic method doesn't work with Xcode, so if you need to run with a debugger, replace with a static array...
        let days = [1, 2, 3, 4, 5, 6, 7]
        return days
    }
}

let days = try getDays()


func dayName(_ day: Int) -> String {
    String(format: "Day%02d", day)
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
            path: name,
            exclude: ["tests"], // ugh
            sources: ["src"],
            resources: [
                .process("input.txt")
            ],
        ),
        .testTarget(
            name: "\(name)Tests",
            dependencies: [ .target(name: name) ],
            path: name,
            exclude: ["src", "input.txt"], // ugh
            sources: ["tests"]
        ),
    ]
}

let helper = Target.target(
    name: "AOCHelper",
    path: "lib/AOCHelper",
    sources: ["src"]
)

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
    targets: dayTargets + [helper]
)
