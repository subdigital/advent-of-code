import AOCHelper
import Foundation
import Parsing

enum Part2 {
    static func isRepeating(_ val: Int) -> Bool {
        // match the capture group more than once. neat!
        let regex = /^(\d+)\1+$/
        if try! regex.wholeMatch(in: String(val)) != nil {
            return true
        } else {
            return false
        }
    }

    static func findRepeating(in range: ClosedRange<Int>) -> [Int] {
        range.filter(isRepeating)
    }

    static func parseRange(_ str: Substring) -> ClosedRange<Int> {
        let parts = str
            .split(separator: "-", maxSplits: 1, omittingEmptySubsequences: true)
            .map { Int($0)! }

        assert(parts.count == 2)
        return parts[0]...parts[1]
    }

    static func process(_ input: String) -> String {
        let ranges = input.split(separator: ",").map(parseRange)
        let repeating = ranges.map(findRepeating).flatMap { $0 }
        let sum = repeating.reduce(0, +)
        return "\(sum)"
    }
}
