import AOCHelper
import Parsing
import Foundation
import RegexBuilder

enum Day03 {
    struct Mul: Equatable {
        let x: Int
        let y: Int
    }

    static var mulParser: some Parser<Substring, Mul> {
        Parse {
            "mul("
            Int.parser()
            ","
            Int.parser()
            ")"
        }.map(Mul.init)
    }

    static func parseMulsRegex(_ input: String) throws -> [Mul] {
        let pattern = Regex {
            "mul("
            Capture {
                Repeat(.digit, 1...3)
            }
            ","
            Capture {
                Repeat(.digit, 1...3)
            }
            ")"
        }

        let muls = input.matches(of: pattern).map { match in
            let x = Int(match.output.1)!
            let y = Int(match.output.2)!
            return (x, y)
        }

        return muls.map { Mul(x: $0, y: $1) }
    }

    static func part1(_ input: String) throws -> String {
        let muls = try parseMulsRegex(input)
        let sum = muls
            .map { $0.x * $0.y }
            .reduce(0, +)

        return String(sum)
    }

    static func part2(_ input: String) throws -> String {
        let scanner = Scanner(string: input)

        var enabled = true
        var muls = [Mul]()

        while !scanner.isAtEnd {
            var foundCommand = false

            if let str = scanner.scanUpToString("do") {
                if let _ = scanner.scanString("do()") {
                    foundCommand = true

                    if enabled {
                        muls += try parseMulsRegex(str)
                    }
                    enabled = true
                } else if let _ = scanner.scanString("don't()") {
                    foundCommand = true
                    if enabled {
                        muls += try parseMulsRegex(str)
                    }
                    enabled = false
                } else {
                    if enabled {
                        muls += try parseMulsRegex(str)
                    }
                }
            }

            if !foundCommand {
                let str = String(scanner.string[scanner.currentIndex...])
                if enabled {
                    muls += try parseMulsRegex(str)
                }
            }
        }

        let sum = muls
            .map { $0.x * $0.y }
            .reduce(0, +)

        return String(sum)    }
}

let input = try readInput(from: .module)
print("DAY 03 Part 1: ")
try print(Day03.part1(input))
print("---------------------")
print("DAY 03 Part 2: ")
try print(Day03.part2(input))
print("---------------------")
