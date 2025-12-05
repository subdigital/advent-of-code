import AOCHelper
import Foundation
import Parsing

enum Part2 {
    static func process(_ input: String) throws -> String {
        let banks = try parse(input)
        let joltage = banks.map { $0.findLargestJoltage(max: 12) }.reduce(0, +)
        return "\(joltage)"
    }
}
