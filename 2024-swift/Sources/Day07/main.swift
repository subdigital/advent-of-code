import AOCHelper
import Foundation
import Parsing

enum Day07 {
    static func parseInput(_ input: String) throws -> [(Int, [Int])] {
        let line: some Parser<Substring, (Int, [Int])> = Parse {
            Int.parser()
            ": "
            Many {
                Int.parser()
            } separator: {
                " "
            }
        }

        return try Parse {
            Many(element: {
                line
            }, separator: {
                "\n"
            }, terminator: {
                Whitespace(1...)
            })
        }.parse(input)
    }

    static func part1(_ input: String) throws -> String {
        let lines = try parseInput(input)
        let matchingLines = lines.filter { line in
            testLineAddMul(result: line.0, operands: line.1)
        }

        let sum = matchingLines.map(\.0).reduce(0, +)

        return String(sum)
    }

    static func part2(_ input: String) async throws -> String {
        let lines = try parseInput(input)

        return await withTaskGroup(of: Int.self) { group in
            for line in lines {
                group.addTask {
                    if testLineAddMulConcat(result: line.0, operands: line.1) {
                        return line.0
                    } else {
                        return 0
                    }
                }
            }

            var sum = 0
            for await result in group {
                sum += result
            }

            return String(sum)
        }
    }

    static func testLineAddMul(result: Int, operands: [Int]) -> Bool {
        print("testLine: \(result): \(operands)")
        defer { print("\n") }

        guard operands.count > 0 else { return false }
        guard operands.count > 1 else { return operands[0] == result }

        // 10: 5 4 1
        var totals: [Int] = [operands[0]]
        for num in operands.dropFirst() {
            for total in totals {
                let a = total + num
                let m = total * num

                if a == result || m == result {
                    print("✅")
                    return true
                }

                totals.append(a)
                totals.append(m)
            }
        }

        print("⛔")
        return false
    }

    static func testLineAddMulConcat(result: Int, operands: [Int]) -> Bool {
        print("testLine: \(result): \(operands)")
        defer { print("\n") }

        guard operands.count > 0 else { return false }
        guard operands.count > 1 else { return operands[0] == result }

        // 47: 5 4 1 2
        // 5
            // 9
            // 54
            // 20
                // 10
                // 9
                // 91

                // 55
                // 541
                // 54

                // ...
                // ...

        var totals: [Int] = [operands[0]]
        var nextIterationTotals: [Int] = []
        for num in operands.dropFirst() {
            nextIterationTotals = []
            for total in totals {
                let a = total + num
                let m = total * num
                let c = Int(String(total) + String(num))

                nextIterationTotals.append(a)
                nextIterationTotals.append(m)
                c.flatMap { nextIterationTotals.append($0) }
            }

            totals = nextIterationTotals
        }

        if nextIterationTotals.contains(result) {
            print("✅")
            return true
        }


        print("⛔")
        return false
    }
}

let input = try readInput(from: .module)
print("DAY 07 Part 1: ")
print(try Day07.part1(input))
print("---------------------")

print("DAY 07 Part 2: ")
print(try await Day07.part2(input))
print("---------------------")
