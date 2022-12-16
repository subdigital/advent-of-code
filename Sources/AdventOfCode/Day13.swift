import Foundation
import Algorithms

struct Day13: Challenge {
    let input: String

    func run() -> String {
        var output = ""

        // output.append("Part 1: \(part1())\n")
        output.append("Part 2: \(part2())")

        return output
    }

    enum Signal: Equatable {
        case int(Int)
        case list([Signal])

        static func parse(_ string: some StringProtocol) -> Self {
            let scanner = Scanner(string: String(string))
            return parse(using: scanner)!
        }

        private static func parse(using scanner: Scanner, indentLevel: Int = 0) -> Self? {
            // [1]
            // [1,2]
            // [[1], 2]
            // [[1],[2,3,4]]

            // eat any commas
            _ = scanner.scanString(",")

            if let _ = scanner.scanString("[") {
                // parse list
                var list: [Signal] = []
                while let signal = parse(using: scanner, indentLevel: indentLevel + 1) {
                    list.append(signal)
                }
                return .list(list)
            } else if let _ = scanner.scanString("]") {
                // end of list
                return nil
            } else {
                var int: Int = 0
                if scanner.scanInt(&int) {
                    return .int(int)
                } else {
                    return nil
                }
            }
        }
    }

    func comparison(_ left: Signal, _ right: Signal, indent: Int = 0) -> ComparisonResult {
        let ind = Array(repeating: " ", count: indent + 1).joined()
        switch (left, right) {
        case let (.int(l), .int(r)):
            print("\(ind)- Compare \(l) with \(r)")
            if l == r {
                return .orderedSame
            }
            return l < r ? .orderedAscending : .orderedDescending

        case let (.list(l), .list(r)):
            print("\(ind)- Compare \(l) with \(r)")
            // [1, 2, 3, 4]   [1, 2, 3]
            var leftList = l
            var rightList = r
            while !leftList.isEmpty && !rightList.isEmpty {
                let leftSignal = leftList.remove(at: 0)
                let rightSignal = rightList.remove(at: 0)
                let result = comparison(leftSignal, rightSignal, indent: indent + 1)
                if result != .orderedSame {
                    return result
                }
            }
            // all elements were in order
            if l.count == r.count {
                return .orderedSame
            }
            return l.count < r.count ? .orderedAscending : .orderedDescending

        case (.list, _):
            print("\(ind)- Mixed types, convert right to list and retry")
            return comparison(left, .list([right]), indent: indent + 1)

        case (_, .list):
            print("\(ind)- Mixed types, convert left to list and retry")
            return comparison(.list([left]), right, indent: indent + 1)
        }
    }

    func part1() -> String {
        let signals = input.lines().filter { !$0.isEmpty }.map(Signal.parse)

        var indices: [Int] = []
        for (index, pair) in signals.chunks(ofCount: 2).enumerated() {
            let left = pair.first!
            let right = pair.last!
            print("L: ", left)
            print("R: ", right)
            if comparison(left, right) != .orderedDescending {
                print("ORDERED")
                indices.append(index + 1)
            } else {
                print("(not ordered)")
            }
            print("-----")
            print("")
        }

        return "Sum of ordered indices: \(indices.reduce(0, +))"
    }

    func part2() -> String {
        let dividerPacket1 = Signal.list([.list([.int(2)])])
        let dividerPacket2 = Signal.list([.list([.int(6)])])
        let signals = input.lines()
            .filter { !$0.isEmpty }
            .map(Signal.parse)
            + [dividerPacket1, dividerPacket2]

        let sorted = signals.sorted(by: { a, b in
            comparison(a, b) != .orderedDescending
        })

        print("sorted:")
        var signalProduct = 1
        sorted.enumerated().forEach { (index, signal) in
            print("\(index + 1):", signal)
            if signal == dividerPacket1 || signal == dividerPacket2 {
                signalProduct *= (index + 1)
            }
        }
        print(sorted)

        return "Product of indices of signal packet is: \(signalProduct)"
    }

}

extension Day13.Signal: CustomStringConvertible {
    var description: String {
        switch self {
        case .int(let x): return "\(x)"
        case .list(let signals):
            return "[" + signals.map(\.description).joined(separator: ",") + "]"
        }
    }
}
