//
//  main.swift
//  Day01
//
//  Created by Ben Scheirman on 12/1/22.
//

import Foundation
import AOCShared

struct Day01: Challenge {
    let input: String

    let elfsAndCalories: [[Int]]

    init(input: String) {
        self.input = input

        let lines = input.split(separator: "\n", omittingEmptySubsequences: false)

        elfsAndCalories = lines.reduce(into: [[Int]]()) { acc, line  in
            if acc.isEmpty || line.isEmpty {
                acc.append([])
            }

            if let value = Int(line) {
                let index = acc.count - 1
                var items = acc[index]
                items.append(value)
                acc[index] = items
            }
        }
    }

    func part1() -> String {
        let sums = elfsAndCalories.map { $0.sum() }
        let max = sums.max() ?? 0
        return String(max)
    }

    func part2() -> String {
        let sums = elfsAndCalories.map { $0.sum() }
        let top3 = sums.sorted().reversed()[0..<3]
        return String(top3.sum())
    }

    func run() -> String {
        var output = ""
        output += "Part 1: \(part1())\n"
        output += "Part 2: \(part2())\n"
        return output
    }
}

