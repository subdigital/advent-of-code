enum Day7 {
    static func run() {
        let input = readFile("day7.input")
        let positions = input.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap(Int.init)

        let aligner = HorizontalAligner(positions)
        let (pos, cost) = aligner.minimumCostToAlign()
        print("aligning on: \(pos)")
        print("min cost is: \(cost)")
    }
}

struct HorizontalAligner {
    let positions: [Int]

    init(_ positions: [Int]) {
        self.positions = positions
    }

    private func costToMoveDistance(_ distance: Int) -> Int {
        let n = Float(distance)
        return Int(n * (n+1)/2)
    }

    func costToMove(to target: Int) -> Int {
        let costs = positions.map { pos -> Int in 
            guard pos != target else { return 0 }
            // 1 -> 1 => 1
            // 2 -> 1 + 2 => 3
            // 3 -> 1 + 2 + 3 => 6
            // 4 -> 1 + 2 + 3 + 4 => 10
            // 5 -> 1 + 2 + 3 + 4 + 5 => 10
            let distance = abs(target - pos)
            let cost = costToMoveDistance(distance)
            return cost
        }

        return costs.reduce(0, +)
    }

    func minimumCostToAlign() -> (pos: Int, cost: Int) {
        guard let minPos = positions.min(),
            let maxPos = positions.max() else {
                return (0, 0)
            }

        var pos: Int = 0
        var minCost: Int = Int.max
        (minPos...maxPos).forEach { p in 
            let cost = costToMove(to: p)
            if cost < minCost {
                minCost = cost
                pos = p
            }
        }
        return (pos, minCost)
    }
}

