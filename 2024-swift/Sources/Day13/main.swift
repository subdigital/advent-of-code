import AOCHelper
import Foundation
import Parsing

enum Day13 {
    struct ClawMachine: Equatable {
        let a: Point
        let b: Point
        let prize: Point

        static func parser() -> AnyParser<Substring, ClawMachine> {
            let point = Parse(input: Substring.self) {
                "X"
                OneOf {
                    "+"
                    "="
                }
                Int.parser()
                ", "
                "Y"
                OneOf {
                    "+"
                    "="
                }
                Int.parser()
            }.map { Point($0, $1) }

            return Parse(input: Substring.self) {
                "Button A: "
                point
                "\n"
                "Button B: "
                point
                "\n"
                "Prize: "
                point
            }
            .map {
                ClawMachine(a: $0, b: $1, prize: $2)
            }
            .eraseToAnyParser()
        }

        let maxIterations = 100

        func solve() -> (a: Int, b: Int)? {
            assert(a.x > 0 && a.y > 0 && b.x > 0 && b.y > 0)

            var countA = 0
            var countB = 0
            var current: Point

            let maxA = min(prize.x / a.x, prize.y / a.y)
            let maxB = min(prize.x / b.x, prize.y / b.y)

            let favorA = maxA < maxB
            if favorA {
                current = a * maxA
                countA = maxA
            } else {
                current = b * maxB
                countB = maxB
            }

            while true {
                if current == prize {
                    break
                }

                let remainder = prize - current
                if favorA {
                    if remainder.x % b.x == 0 && remainder.y % b.y == 0 &&
                        remainder.x / b.x == remainder.y / b.y
                    {
                        // we can solve this by pushing B
                        countB += remainder.x / b.x
                        break
                    } else {
                        countA -= 1
                        current -= a
                    }
                } else {
                    if remainder.x % a.x == 0 && remainder.y % a.y == 0 &&
                        remainder.x / a.x == remainder.y / a.y
                    {
                        // we can solve this by pushing A
                        countA += remainder.x / a.x
                        break
                    } else {
                        countB -= 1
                        current -= b
                    }
                }

                if countA < 0 || countB < 0 {
                    return nil
                }
            }

            return (a: countA, b: countB)
        }

        // courtesy of spiderhater4
        // https://www.reddit.com/r/adventofcode/comments/1hd5b6o/comment/m1tx7yy/
        func solveImproved() -> (a: Int, b: Int)? {
            let m = (prize.y * a.x - prize.x * a.y)
            let n = (b.y * a.x - b.x * a.y)

            guard m % n == 0 else { return nil }

            let countB = m / n
            let countA = (prize.x - countB * b.x) / a.x
            assert(countA == (prize.y - countB * b.y) / a.y)

            return (a: countA, b: countB)
        }
    }

    static func parse(_ input: String) throws -> [ClawMachine] {
        try Many {
            ClawMachine.parser()
        } separator: {
            "\n\n"
        }
        .parse(input.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    static func part1(_ input: String) throws -> String {
        let machines = try parse(input)

        let cost = machines
            .compactMap { machine in machine.solve() }
            .map { $0.a * 3 + $0.b }
            .reduce(0, +)

        return String(cost)
    }

    static func part2(_ input: String) throws -> String {
        let machines = try parse(input).map { machine in
            ClawMachine(
                a: machine.a,
                b: machine.b,
                prize: Point(
                    machine.prize.x + 10_000_000_000_000,
                    machine.prize.y + 10_000_000_000_000
                )
            )
        }

        let cost = machines
            .compactMap { machine in machine.solveImproved() }
            .map { $0.a * 3 + $0.b }
            .reduce(0, +)

        return String(cost)
    }
}

let input = try readInput(from: .module)
print("DAY 13 Part 1: ")
print(try Day13.part1(input))
print("---------------------")

print("DAY 13 Part 2: ")
print(try Day13.part2(input))
print("---------------------")
