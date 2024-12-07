import AOCHelper
import Foundation
import Parsing

enum Day05 {
    struct OrderingRule: Equatable, CustomDebugStringConvertible {
        let a: Int
        let b: Int

        init(_ a: Int, _ b: Int) {
            self.a = a
            self.b = b
        }

        var debugDescription: String {
            "\(a)|\(b)"
        }
    }

    struct OrderingRules {
        let rules: [OrderingRule]

        func correctOrder(_ update: [Int]) -> [Int] {
            guard update.count > 0 else { return [] }

            let validRules = rules.filter {
                update.contains($0.a) && update.contains($0.b)
            }

            var ordered = [update[0]]
            for page in update.dropFirst() {
                for (index, x) in ordered.enumerated() {
                    // should we insert before this number?
                    if validRules.contains(where: { $0.a == page && $0.b == x }) {
                        ordered.insert(page, at: index)
                        break
                    } else if index == ordered.count - 1 {
                        ordered.append(page)
                    }
                }
            }

            return ordered
        }

        func isInCorrectOrder(_ update: [Int]) -> Bool {
            guard !update.isEmpty else { return false }

            return update == correctOrder(update)
        }
    }

    struct OrderingRuleParser: Parser {
        var body: AnyParser<Substring, OrderingRule> {
            Parse {
                Int.parser()
                "|"
                Int.parser()
            }
            .map(OrderingRule.init)
            .eraseToAnyParser()
        }
    }

    struct UpdatesParser: Parser {
        var body: AnyParser<Substring, [Int]> {
            Many {
                Int.parser()
            } separator: {
                ","
            }.eraseToAnyParser()
        }
    }

    static func parse(_ input: String) throws -> ([OrderingRule], [[Int]]) {
        try Parse {
            Many {
                OrderingRuleParser()
            } separator: {
                "\n"
            }

            "\n\n"

            Many {
                UpdatesParser()
            } separator: {
                "\n"
            }
        }
        .map { orderingRules, updates in
            (orderingRules, updates)
        }
        .parse(input)
    }

    static func part1(_ input: String) throws -> String {
        let (orderingRules, updates) = try parse(input)
        let rules = OrderingRules(rules: orderingRules)

        let sum = updates.filter { rules.isInCorrectOrder($0)}
            .map {
                guard $0.count > 0 else { return 0 }

                let mid = Int($0.count / 2)
                return $0[mid]
            }
            .reduce(0, +)

        return String(sum)
    }

    static func part2(_ input: String) throws -> String {
        let (orderingRules, updates) = try parse(input)
        let rules = OrderingRules(rules: orderingRules)

        let sum = updates
            .filter { !rules.isInCorrectOrder($0) }
            .map {
                print("Before correction: \($0)")
                return $0
            }
            .map { rules.correctOrder($0) }
            .map {
                print("After correction: \($0)")
                return $0
            }
            .map {
                guard $0.count > 0 else { return 0 }

                let mid = Int($0.count / 2)
                return $0[mid]
            }
            .reduce(0, +)

        return String(sum)
    }
}

let input = try readInput(from: .module)
print("DAY 05 Part 1: ")
print(try Day05.part1(input))
print("---------------------")
print("DAY 05 Part 2: ")
print(try Day05.part2(input))
print("---------------------")
