enum Day2 {
    static func run() {
        let input = readFile("day2.input")
        let movements = input.lines.compactMap(Movement.parse)
        var tracker = PositionTracker()
        movements.forEach { 
            tracker.process($0)
        }

        print("Depth is now \(tracker.depth)")
        print("Pos is now \(tracker.position)")
        print("Day 2 answer: \(tracker.depth * tracker.position)")
    }
}

struct PositionTracker {
    private(set) var position = 0
    private(set) var depth = 0
    private(set) var aim = 0

    init() {
    }

    mutating func process(_ movement: Movement) {
        print("processing \(movement)")
        switch movement {
        case .forward(let x): 
            position += x
            depth += aim * x
        case .up(let x): aim -= x
        case .down(let x): aim += x
        }
    }
}

enum Movement {
    case forward(Int)
    case up(Int)
    case down(Int)

    static func parse(_ input: String) -> Self? {
        // forward 5
        let parts = input.split(separator: " ")
        guard parts.count == 2 else { return nil }
        guard let amount = Int(parts[1]) else { return nil }
        switch parts[0] {
        case "forward": return .forward(amount)
        case "up": return .up(amount)
        case "down": return .down(amount)
        default: return nil
        }
    }
}
