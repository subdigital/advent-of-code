import Foundation
import AOCHelper

enum Day01 {
    static func part1(_ input: String) -> String {
        let lines = input.split(separator: "\n")

        let lists = lines.map { line in
            let pair = line.split(maxSplits: 2, whereSeparator: \.isWhitespace)
            return (
                Int(pair[0])!,
                Int(pair[1])!
            )
        }.reduce(into: ([Int](), [Int]())) { partialResult, pair in
            partialResult.0.append(pair.0)
            partialResult.1.append(pair.1)
        }

        let sum = zip(lists.0.sorted(), lists.1.sorted())
            .map { pair in
                abs(pair.0 - pair.1)
            }
            .reduce(0, +)

        return "\(sum)"
    }

    static func part2(_ input: String) -> String {
        let lines = input.split(separator: "\n")

        struct Container {
            var list: [Int] = []
            var numberLookup: [Int: Int] = [:]
        }

        let container = lines.map { line in
            let pair = line.split(maxSplits: 2, whereSeparator: \.isWhitespace)
            return (
                Int(pair[0])!,
                Int(pair[1])!
            )
        }.reduce(into: Container()) { container, pair in
            container.list.append(pair.0)
            container.numberLookup[pair.1, default: 0] += 1
        }

        let sum = container.list
            .map { num in
                num * container.numberLookup[num, default: 0]
            }
            .reduce(0, +)

        return "\(sum)"
    }
}

let input = try readInput(from: .module)
print("DAY 01 Part 1: ")
print(Day01.part1(input))
print("---------------------")
print("DAY 01 Part 2: ")
print(Day01.part2(input))
print("---------------------")
