import AOCHelper
import Foundation

enum Part1 {
    static func isRepeating(_ val: Int) -> Bool {
        let valStr = String(val)
        guard valStr.count.isMultiple(of: 2) else {
            return false
        }

        let mid = valStr.index(valStr.startIndex, offsetBy: valStr.count / 2)
        var l = valStr.startIndex
        var r = mid

        while r != valStr.endIndex {
            if valStr[l] != valStr[r] {
                return false
            }

            l = valStr.index(after: l)
            r = valStr.index(after: r)
        }

        return true
    }

    static func findRepeating(in range: ClosedRange<Int>) -> Set<Int> {
        Set(range.filter(isRepeating))
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
