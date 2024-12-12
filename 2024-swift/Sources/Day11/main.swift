import AOCHelper
import Foundation
import Parsing

//  0     1    12
//  |     |     ^
//  1   2024  1   2
//  |     ^  2024 4048


// 0 -> 1 -> 2024 -> [20, 24] -> [2, 0, 2, 4] -> [4048, 1, 4048, 8,096]

enum Day11 {
    struct Simulation {
        private(set) var nums: [Int]

        class Cache {
            let num: Int
            var expansions: [[Int]]

            init(num: Int) {
                self.num = num
                expansions = [[num]]
            }
        }

        private var caches: [Int: Cache] = [:]

        init(nums: [Int]) {
            self.nums = nums
        }

        func computeSingleStep(num: Int) -> [Int] {
            var newNums: [Int] = []
            let digits = String(num)
            if num == 0 {
                newNums.append(1)
            } else if digits.count % 2 == 0 {
                // even digits
                let start = digits.startIndex
                let mid = digits.index(start, offsetBy: digits.count / 2)
                let leftPart = Int(digits[start..<mid])!
                let rightPart = Int(digits[mid...])!
                newNums.append(leftPart)
                newNums.append(rightPart)
            } else {
                newNums.append(2024 * num)
            }

            return newNums
        }

        mutating func compute(num: Int, times: Int) -> [Int] {
            let cache: Cache
            if let existing = caches[num] {
                cache = existing
            } else {
                cache = Cache(num: num)
                caches[num] = cache
            }

            // 0:
                //1: 0 -> 1
                //2: 1 -> 2024
                //3: 2024 -> [20, 24]
                //4: 20 24 -> [2, 0, 2, 4]
                //5: 2, 0*, 2*, 4 -> [4048, 1*, 4048*, 8096]

            // 1:
                // 1 -> 2024
                // 2024 -> [20, 24]

            let missing = times - cache.expansions.count + 1
            for i in 0..<missing {
                let expansion = cache.expansions.last!
                let remainingIterations = missing - i
                var newNums: [Int] = []
                if remainingIterations == 1 {
                    newNums += computeSingleStep(num: num)
                } else {
                    newNums += compute(num: num, times: remainingIterations - 1)
                }
                cache.expansions.append(newNums)
            }

            return cache.expansions[times]
        }

        mutating func blink(_ times: Int = 1) {
            nums = nums.flatMap { n in
                compute(num: n, times: times)
            }
        }
    }

    static func parse(_ input: String) throws -> [Int] {
        try Many {
            Int.parser()
        } separator: {
            Whitespace()
        }.parse(input.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    static func part1(_ input: String) throws -> String {
        var sim = Simulation(nums: try parse(input))
        for _ in 0..<25 {
            sim.blink()
        }
        return String(sim.nums.count)
    }

    static func part2(_ input: String) throws -> String {
        var sim = Simulation(nums: try parse(input))
        for i in 1...75 {
            print("Blink #\(i)")
            sim.blink()
        }
        return String(sim.nums.count)
    }
}

let input = try readInput(from: .module)
print("DAY 11 Part 1: ")
print(try Day11.part1(input))
print("---------------------")

print("DAY 11 Part 2: ")
print(try Day11.part2(input))
print("---------------------")
