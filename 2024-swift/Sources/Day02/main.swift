import Parsing
import Foundation
import AOCHelper

struct Report {
    var levels: [Int]

    var isSafe: Bool {
        guard levels.count >= 2 else { return false }

        let isDecreasing = levels[0] > levels[1]

        return zip(levels, levels.dropFirst())
            .allSatisfy { a, b in
                let diff = (a - b) * (isDecreasing ? 1 : -1)
                let isSafe = diff >= 1 && diff <= 3
                return isSafe
            }
    }
}

enum Day02 {
    private static func parseReports(_ input: String) throws -> [Report] {
        let reportParser = Parse(input: Substring.self) {
            Many(element: {
                Int.parser()
            }, separator: {
                " "
            })
        }.map { levels in
            Report(levels: levels)
        }

        return try Many(
            element: { reportParser },
            separator: { "\n" }
        ).parse(input)
    }

    static func part1(_ input: String) throws -> String {
        let safeReports = try parseReports(input).filter(\.isSafe)
        return "\(safeReports.count)"
    }

    static func part2(_ input: String) throws -> String {
        let reports = try parseReports(input)
        var count = 0

        for report in reports {
            for i in 0..<report.levels.count {
                var copy = report
                copy.levels.remove(at: i)
                if copy.isSafe {
                    count += 1
                    break
                }
            } }

        return "\(count)"
    }
}

let input = try readInput(from: .module)
print("DAY 02 Part 1: ")
try print(Day02.part1(input))
print("---------------------")
print("DAY 01 Part 2: ")
try print(Day02.part2(input))
print("---------------------")
