import Testing
@testable import Day03

import Foundation
import Parsing
import RegexBuilder

struct Day03Tests {
    @Test
    func part1() throws {
        let input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
        let output = try Day03.part1(input)
        #expect(output == "161")
    }

    @Test
    func part2() throws {
        let input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
        let output = try Day03.part2(input)
        #expect(output == "48")
    }

    @Test
    func parsing() {
        let val =
        Optionally {
            CharacterSet.alphanumerics
                .union(.whitespaces)
                .union(.punctuationCharacters)
                .union(.symbols)
        }
        .parse("x 1 ^&")
        #expect(val == "x 1 ^&")
    }

    @Test
    func parseMul() throws {
        let input = "mul(2,4)"
        let mul = try Day03.mulParser.parse(input)

        #expect(mul == Day03.Mul(x: 2, y: 4))
    }

    @Test
    func parseMulTwice() throws {
        let input = "mul(2,4)mul(5,6)"
        let muls = try Many {
            Day03.mulParser
        }.parse(input)

        #expect(muls == [
            Day03.Mul(x: 2, y: 4),
            Day03.Mul(x: 5, y: 6)
        ])
    }

    @Test(.disabled("not yet working"))
    func parseMulTwiceWithGarbageInFront() throws {
        let input = "xmul(2,4)mmmmmul(5,6)"
        let muls = try Many {
            OneOf {
                Day03.mulParser.map { $0 as Day03.Mul? }
                Many { CharacterSet.alphanumerics }.map { _ in nil }
            }
        }
        .parse(input)

        #expect(muls == [
            Day03.Mul(x: 2, y: 4),
            Day03.Mul(x: 5, y: 6)
        ])
    }

    @Test
    func regexTest() throws {
        let input = "xmul(2,4)mmmmmul(5,6)"
        let pattern = Regex {
            "mul("
            Capture { One(.digit) }
            ","
            Capture { One(.digit) }
            ")"
        }

        let muls = input.matches(of: pattern).map { match in
            let x = Int(match.output.1)!
            let y = Int(match.output.2)!
            return (x, y)
        }

        #expect(muls.count == 2)
        print(muls)
    }
}
