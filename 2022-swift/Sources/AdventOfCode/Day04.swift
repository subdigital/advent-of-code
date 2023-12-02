import AOCShared

struct Day04: Challenge {
    let input: String

    func run() -> String {
        var output = ""
        output += "Part 1: \(part1())\n"
        output += "Part 2: \(part2())"
        
        return output
    }

    private func part1() -> String {
        let ranges = input.lines()
            .map { line in
                line.split(separator: ",")
                    .map(parseRange)
            }
            .filter { rangePairs in
                let left = rangePairs[0]
                let right = rangePairs[1]
                return left.entirelyContains(right) || right.entirelyContains(left)
            }
            .count

        return "ranges: \(ranges)"
    }

    private func part2() -> String {
        let ranges = input.lines()
            .map { line in
                line.split(separator: ",")
                    .map(parseRange)
            }
            .filter { rangePairs in
                let left = rangePairs[0]
                let right = rangePairs[1]
                return left.overlaps(right)
            }
            .count

        return "ranges: \(ranges)"
    }

    private func parseRange<S: StringProtocol>(_ input: S) -> ClosedRange<Int> {
        let parts = input.split(separator: "-")
        assert(parts.count == 2)

        guard
            let lower = Int(parts[0]),
            let upper = Int(parts[1])
        else {
            fatalError("Could not parse: \(input) as a range of ints")
        }
    
        return lower...upper
    }
}

extension ClosedRange where ClosedRange.Bound: Comparable {
    func entirelyContains(_ other: Self) -> Bool {
        lowerBound <= other.lowerBound && upperBound >= other.upperBound
    }

    func overlaps(_ other: Self) -> Bool {
        contains(other.lowerBound) || contains(other.upperBound) || other.contains(lowerBound) || other.contains(upperBound)
    }
}
