import AOCHelper
import Foundation

struct Bank {
    let batteries: [Int]

    private func formNumber(digits: [Int]) -> Int {
        digits
            .reversed()
            .enumerated()
            .reduce(0) { sum, digit in
                sum + Int(pow(Double(10), Double(digit.offset))) * digit.element
            }
    }

    func findLargestJoltage(max: Int = 2) -> Int {
        precondition(batteries.count >= max)

        var digits: [Int] = []
        var startIndex = 0
        var endIndex = batteries.count - (max - 1)

        while digits.count < max {
            let (digit, index) = batteries[startIndex..<endIndex].findHighestValue()
            startIndex = index + 1
            endIndex += 1
            digits.append(digit)
        }

        return formNumber(digits: digits)
    }
}

func parse(_ input: String) throws -> [Bank] {
    input.lines().map { line in
        Array(line).compactMap { c in Int.init(String(c)) }
    }
    .map(Bank.init)
}

enum Part1 {
    static func process(_ input: String) throws -> String {
        let banks = try parse(input)
        let joltage = banks.map { $0.findLargestJoltage() }.reduce(0, +)
        return "\(joltage)"
    }
}

extension Array<Int>.SubSequence {
    func findHighestValue() -> (val: Element, index: Index) {
        precondition(!self.isEmpty)
        var highest: (val: Int, index: Int) = (val: Int.min, index: Int.min)
        for index in self.indices {
            if self[index] > highest.val {
                highest.val = self[index]
                highest.index = index
            }
        }
        return highest
    }
}
