import Parsing
import Foundation
import AOCHelper

struct Report {
    let levels: [Int]

    func isSafe() -> Bool {
        guard levels.count >= 2 else { return false }

        let isDecreasing = levels[0] > levels[1]

        return zip(levels, levels.dropFirst())
            .allSatisfy { a, b in
                let diff = (a - b) * (isDecreasing ? 1 : -1)
                let isSafe = diff >= 1 && diff <= 3
                return isSafe
            }
    }

    func part2_isSafe(tolerance: Int = 0) -> Bool {
        guard levels.count >= 2 else { return false }

        var isDecreasing = levels[0] > levels[1]

        // 7 10 6 5
        // 10 7 6 5
        // 7 10 6 5

        func isSafe(_ a: Int, _ b: Int, _ isDecreasing: Bool) -> Bool {
            let diff = (a - b) * (isDecreasing ? 1 : -1)
            let isSafe = diff >= 1 && diff <= 3
            return isSafe
        }

        var tolerance = tolerance
        var i = 0
        while i < levels.count - 1 {
            var current = levels[i]
            let next = levels[i + 1]
            var safe = isSafe(current, next, isDecreasing)

            // can we skip this number?

            // check for last 2 numbers case
            if !safe && tolerance > 0 && i == levels.count - 2  {
                break
            }

            // otherwise peek ahead to see if we can skip the next number (or this one)
            if !safe && tolerance > 0 && (i + 2) < levels.count {
                let next = levels[i + 2]
                tolerance -= 1
                safe = isSafe(current, next, isDecreasing)

                if safe {
                    // skip the number
                    i += 2
                    continue
                }

                // we need to recheck for isDecreasing because we could be replacing
                // the number that we used to determine the value
                if i == 0 {
                    isDecreasing = levels[1] > levels[2]
                }

                // can we skip the current number?
                current = levels[i + 1]

                // check previous continuity
                safe = i > 0 ? isSafe(levels[i - 1], current, isDecreasing) : true
                safe = safe && isSafe(current, next, isDecreasing)
            }

            guard safe else { return false }

            i += 1
        }

        print("Levels was determined safe: \(levels)")

        return true
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
        let safeReports = try parseReports(input).filter {
            $0.part1_isSafe()
        }

        return "\(safeReports.count)"
    }

    static func part2(_ input: String) throws -> String {
        let safeReports = try parseReports(input).filter {
            $0.part2_isSafe(tolerance: 1)
        }

        return "\(safeReports.count)"
    }
}

let input = try readInput(from: .module)
print("DAY 02 Part 1: ")
try print(Day02.part1(input))
print("---------------------")
print("DAY 01 Part 2: ")
try print(Day02.part2(input))
print("---------------------")
