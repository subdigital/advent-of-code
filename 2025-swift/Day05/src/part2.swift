import AOCHelper
import Foundation
import Parsing

func merge<T: Comparable>(_ r1: ClosedRange<T>, _ r2: ClosedRange<T>) -> ClosedRange<T> {
    (min(r1.lowerBound, r2.lowerBound))...(max(r1.upperBound, r2.upperBound))
}

enum Part2 {
    struct SparseRange<T: Comparable> {
        private(set) var ranges: [ClosedRange<T>] = []

        var count: Int {
            ranges.count
        }

        var lowerBound: T? {
            ranges.first?.lowerBound
        }

        var upperBound: T? {
            ranges.last?.upperBound
        }

        mutating func add(range: ClosedRange<T>) {
            if ranges.isEmpty {
                ranges.append(range)
                return
            }

            // quick win, can avoid iterating if we know this range is completely before/adfter our sparse range
            if let lowerBound, range.upperBound < lowerBound {
                ranges.insert(range, at: 0)
                return
            }

            if let upperBound, range.lowerBound > upperBound {
                ranges.append(range)
                return
            }

            var added = false
            for x in ranges.indices {
                // indices may have changed, so check
                guard ranges.indices.contains(x) else { break }

                // do we already have this range?
                if ranges[x] == range {
                    return
                }

                let r = ranges[x]
                // does the range overlap with this one?
                if r.overlaps(range) {
                    // merge with existing
                    ranges[x] = merge(r, range)
                    added = true

                    // does it also overlap with next?
                    if x < ranges.count - 1 && ranges[x].overlaps(ranges[x+1]) {
                        // merge & delete
                        ranges[x] = merge(ranges[x], ranges[x+1])
                        ranges.remove(at: x + 1)
                    }
                    break
                } else {
                    // do we insert here?
                    if range.upperBound < r.lowerBound {
                        assert(!ranges.contains(range))
                        // ranges.insert(range, at: x)
                        return
                    }
                }
            }

            if !added {
                ranges.append(range)
            }
        }
    }

    struct Inventory {
        var fresh: SparseRange<Int>

        init() {
            fresh = SparseRange()
        }

        init(fresh: [ClosedRange<Int>]) {
            var ranges = SparseRange<Int>()
            for range in fresh.sorted(by: { $0.lowerBound < $1.lowerBound }) {
                ranges.add(range: range)
            }
            self.fresh = ranges
        }

        func freshIngredientCount() -> Int {
            return fresh.ranges.map { $0.count }.reduce(0, +)
        }
    }

    static func rangeParser() -> some Parser<Substring, ClosedRange<Int>> {
        Parse(input: Substring.self) {
            Int.parser()
            "-"
            Int.parser()
        }.map { $0...$1 }
    }

    static func inventoryParser() -> some Parser<Substring, Inventory> {
        Parse(input: Substring.self) { fresh, _ in
            let inventory: Inventory = withBenchmark("collapsing ranges") {
                Inventory(fresh: fresh)
            }
            return inventory
        } with: {
            Many {
                rangeParser()
            } separator: {
                "\n"
            } terminator: {
                "\n\n"
            }
            Rest()
        }
    }

    static func parseRanges(_ input: String) -> [ClosedRange<Int>] {
        var ranges: [ClosedRange<Int>] = []
        for line in input.lines() {
            if let range = try? rangeParser().parse(line) {
                ranges.append(range)
            } else {
                break
            }
        }
        return ranges.sorted(by: { $0.lowerBound < $1.lowerBound })
    }

    static func solveBen(_ ranges: [ClosedRange<Int>]) -> Inventory {
        Inventory(fresh: ranges)
    }

    static func solveDad(_ ranges: [ClosedRange<Int>]) -> Int {
        var ranges = ranges
        var i = 0
        while i < ranges.count - 1 {
            var merged = false
            let range = ranges[i]
            if range.overlaps(ranges[i+1]) {
                ranges[i] = merge(range, ranges[i+1])
                ranges.remove(at: i+1)
                merged = true
            }

            if !merged {
                i += 1
            }
        }
        return ranges.map(\.count).reduce(0, +)
    }

    static func process(_ input: String) throws -> String {
        let ranges = withBenchmark("parsing") {
            parseRanges(input)
        }
        let answer = withBenchmark("dad's solution") {
            solveDad(ranges)
        }

        _ = withBenchmark("my solution") {
           solveBen(ranges)
        }
        return "\(answer)"
    }
}
