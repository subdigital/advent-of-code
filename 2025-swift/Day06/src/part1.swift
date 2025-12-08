import AOCHelper
import Foundation
import Parsing


enum Operator: String {
    case add = "+"
    case mul = "*"

    var fn: (Int, Int) -> Int {
        switch self {
            case .add: return (+)
            case .mul: return (*)
        }
    }
}

enum Part1 {
    struct CephalopodCalculator {
        private(set) var totals: [Int] = []
        let operators: [Operator]

        init(operators: [Operator]) {
            self.operators = operators
        }

        mutating func add(line: [Int]) {
            if totals.isEmpty {
                totals = line
            } else {
                assert(line.count == operators.count)
                totals = totals.enumerated().map {
                    operators[$0].fn(line[$0], $1)
                }
            }
        }
    }
    static func process(_ input: String) throws -> String {
        let lines = input.lines().reversed()
        let operators = lines.first!
            .split(whereSeparator: \.isWhitespace)
            .compactMap { Operator(rawValue: String($0)) }

        var calculator = CephalopodCalculator(operators: operators)
        for line in lines.dropFirst() {
            let nums =  line.split(whereSeparator: \.isWhitespace)
                .compactMap { Int(String($0)) }
            calculator.add(line: nums)
        }
        let sum = calculator.totals.reduce(0, +)
        return "\(sum)"
    }
}
