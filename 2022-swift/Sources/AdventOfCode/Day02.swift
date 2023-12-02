//
//  main.swift
//  Day02
//
//  Created by Ben Scheirman on 12/2/22.
//

import Foundation
import AOCShared

struct Day02: Challenge {
    let input: String

    enum Result: Int {
        case win = 6
        case loss = 0
        case draw = 3

        init?<S: StringProtocol>(char: S) {
            switch char {
            case "X": self = .loss
            case "Y": self = .draw
            case "Z": self = .win
            default: return nil
            }
        }
    }

    enum Shape: Int {
        case rock = 1
        case paper = 2
        case scissors = 3

        var beats: Shape {
            switch self {
            case .scissors: return .paper
            case .paper: return .rock
            case .rock: return .scissors
            }
        }

        var beatenBy: Shape {
            switch self {
            case .scissors: return .rock
            case .paper: return .scissors
            case .rock: return .paper
            }
        }

        func play(_ other: Shape) -> Result {
            switch (self, other) {
            case (_, beats):
                return .win

            case (self, self):
                return .draw

            default:
                return .loss
            }
        }

        init?<S: StringProtocol>(char: S) {
            switch char {
            case "A", "X": self = .rock
            case "B", "Y": self = .paper
            case "C", "Z": self = .scissors
            default: return nil
            }
        }
    }

    func run() -> String {
        var output = ""
        output += "Part 1: \(part1())\n"
        output += "Part 2: \(part2())"

        return output
    }

    func part1() -> String {
        let scores = input.split(separator: "\n")
            .map { line in
                let shapes = line.split(separator: " ")
                    .compactMap(Shape.init(char:))

                assert(shapes.count == 2)
                return (shapes[0], shapes[1])
            }
            .map(computeRoundScore)

        return String(scores.sum())
    }

    func part2() -> String {
        let scores = input.split(separator: "\n")
            .compactMap { line in
                let chars = line.split(separator: " ")
                assert(chars.count == 2)

                guard let otherShape = Shape(char: chars[0]) else { return nil }
                guard let neededResult = Result(char: chars[1]) else { return nil }

                return (otherShape, neededResult)
            }
            .map(computeRoundScore)

        return String(scores.sum())
    }

    private func computeRoundScore(shapes: (Shape, Shape)) -> Int {
        let myValue = shapes.1.rawValue
        let result = shapes.1.play(shapes.0)
        return myValue + result.rawValue
    }

    private func computeRoundScore(_ args: (other: Shape, neededResult: Result)) -> Int {
        func neededShape() -> Shape {
            switch args.neededResult {
            case .win: return args.other.beatenBy
            case .draw: return args.other
            case .loss: return args.other.beats
            }
        }

        let score = computeRoundScore(shapes: (args.other, neededShape()))
        return score
    }
}

