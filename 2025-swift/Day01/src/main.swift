import AOCHelper
import Foundation
import Parsing

enum Direction: String {
    case left = "L"
    case right = "R"
}

struct Instruction: CustomStringConvertible {
    let direction: Direction
    let amount: Int

    static func parse(_ line: Substring) -> Self {
        guard
            let char = line.first,
            let direction = Direction(rawValue: String(char)) else {
            fatalError("Can't parse direction: \(line)")
        }

        guard let amount = Int(line.dropFirst()) else {
            fatalError("Can't parse amount: \(line)")
        }

        return Instruction(direction: direction, amount: amount)
    }

    var description: String {
        "\(direction.rawValue): \(amount)"
    }
}

struct Dial {
    var current: Int
    let DIAL_SIZE = 100

    mutating func rotateLeft(_ amount: Int) -> Int {
        spin(-amount)
    }

    mutating func rotateRight(_ amount: Int) -> Int {
        spin(amount)
    }

    mutating private func spin(_ amount: Int) -> Int {
        let result = current + amount
        var revolutions = abs(result / DIAL_SIZE)

        if current != 0 && result < 0 {
            revolutions += 1
        }

        (current, _) = result.remainderReportingOverflow(dividingBy: DIAL_SIZE)
        while current < 0 {
            current += DIAL_SIZE
        }

        if result == 0 {
            revolutions += 1
        }

        return revolutions
    }
}

struct Parser {
    let input: String
    func parseInstructions() -> [Instruction] {
        input.lines()
            .map(Instruction.parse)
    }
}

func calculateCombination(dial: Dial, instructions: [Instruction]) -> Int {
    var dial = dial
    var zeroCount = 0
    for instruction in instructions {
        print("--------------- INSTRUCTION: \(instruction) -----------------")
        switch instruction.direction {
        case .left: zeroCount += dial.rotateLeft(instruction.amount)
        case .right: zeroCount += dial.rotateRight(instruction.amount)
        }
        print("    clicks: \(zeroCount)")
    }

    return zeroCount
}


let dial = Dial(current: 50)
let path = Bundle.module.path(forResource: "input", ofType: "txt")!
let input = try String(contentsOfFile: path, encoding: .utf8)
let parser = Parser(input: input)

let instructions = parser.parseInstructions()
print("instructions: \(instructions.map(\.description).joined(separator: "\n"))")

let combo = calculateCombination(dial: dial, instructions: instructions)
print("combo: \(combo)")
