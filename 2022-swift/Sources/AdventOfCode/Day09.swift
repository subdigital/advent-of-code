import AOCShared
import Foundation

struct Day09: Challenge {

    struct Rope {
        var segments: [RopeSegment]

        var head: RopeSegment {
            segments.first!
        }

        var tail: RopeSegment {
            segments.last!
        }

        init(pos: Coord, numSegments: Int) {
            assert(numSegments > 1)

            segments = [
                RopeSegment(pos: pos, tail: nil)
            ]

            for _ in 1..<numSegments {
                let segment = RopeSegment(pos: pos, tail: segments.first!)
                segments.insert(segment, at: 0)
            }
        }

        mutating func move(_ dir: Direction) {
            var vector: Coord = .zero
            switch dir {
            case .left: vector.x = -1
            case .right: vector.x = 1
            case .up: vector.y -= 1
            case .down: vector.y += 1
            }

            segments[0].move(by: vector)
        }
    }

    class RopeSegment {
        var pos: Coord
        var tail: RopeSegment?

        var x: Int { pos.x }
        var y: Int { pos.y }

        init(pos: Coord, tail: RopeSegment? = nil) {
            self.pos = pos
            self.tail = tail
        }

        func move(by vector: Coord) {
            pos += vector
            adjustTail()
        }

        func adjustTail() {
            guard let tail else { return }

            // move tail
            let vector = pos - tail.pos
            let isAdjacent = abs(vector.x) <= 1 && abs(vector.y) <= 1

            if !isAdjacent {
                self.tail!.move(by: vector.normalized)
            }
        }
    }

    struct Coord: Equatable, CustomStringConvertible {
        var x: Int
        var y: Int

        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }

        var description: String {
            "\(x), \(y)"
        }

        var normalized: Self {
            .init(
                x == 0 ? 0 : x / abs(x),
                y == 0 ? 0 : y / abs(y)
            )
        }
    }

    struct Grid {
        var width: Int = 10
        var height: Int = 10

        var origin = Coord(0, 0)

        var isFirst = true

        mutating func render(rope: Rope) {
            if !isFirst {
                clear()
            }
            isFirst = false

            for row in 0..<height {
                for col in 0..<width {
                    let coord = Coord(col+origin.x, row+origin.y)
                    let char: Character =
                        rope.segments.enumerated()
                            .first(where: { (index, segment) in 
                                segment.pos == coord
                            })
                            .flatMap { (index, _) -> Character in
                                if index == 0 {
                                    return "H"
                                } else {
                                    return "\(index)".first!
                                }
                            }
                        ?? "."
                    print(char, terminator: "")
                }
                print("")
            }
        }

        func clear() {
            for _ in 0..<height {
                moveCursorUp(n: 1)
                clearLine(.entire)
            }
        }
    }

    let input: String

    func run() -> String {
        var output = ""
        output.append("Part 1: \(part1())\n")
        output.append("Part 2: \(part2())")

        return output
    }

    struct Command: CustomStringConvertible {
        let direction: Direction
        var count: Int

        static func parse(_ str: some StringProtocol) -> Command {
            let parts = str.split(separator: " ", maxSplits: 2).map { String($0) }
            let dir = Direction(rawValue: parts[0])!
            let count = Int(parts[1])!
            return Command(direction: dir, count: count)
        }

        var description: String {
            "\(direction) => \(count)"
        }
    }

    enum Direction: String {
        case up = "U"
        case down = "D"
        case left = "L"
        case right = "R"
    }

    private func run(grid: inout Grid, rope: inout Rope, renderGrid: Bool, pauseBetweenSteps: Bool = false) -> Int {
        var tailPositions: Set<Coord> = []

        let commands = input.lines().map(Command.parse)
        let stepTime: TimeInterval = commands.count < 10 ? 0.1 : 0

        for var command in commands  {
            while command.count > 0 {
                rope.move(command.direction)

                // make sure the rope head is in view
                if rope.head.x < grid.origin.x {
                    grid.origin.x -= 1
                } else if rope.head.x >= grid.origin.x + grid.width {
                    grid.origin.x += 1
                }

                if rope.head.y < grid.origin.y {
                    grid.origin.y -= 1
                } else if rope.head.y >= grid.origin.y + grid.height {
                    grid.origin.y += 1
                }

                tailPositions.insert(rope.tail.pos)

                if renderGrid {
                    grid.render(rope: rope)
                    clearLine(.entire)
                    print("CMD: \(command),  Grid origin: \(grid.origin)")
                    moveCursorUp()
                    if pauseBetweenSteps {
                        let input = readLine()
                        moveCursorUp(n: 1)
                        if input?.trimmingCharacters(in: .whitespacesAndNewlines) == "q" {
                            exit(0)
                        }
                    } else {
                        Thread.sleep(forTimeInterval: stepTime)
                    }
                }

                command.count -= 1
            }
        }

        if renderGrid {
            print("Tail positions:")
            for pos in tailPositions {
                print(pos)
            }
        }

        return tailPositions.count
    }

    private func part1() -> String {
        var grid = Grid()
        var rope = Rope(pos: Coord(2, 4), numSegments: 2)
        let total = run(grid: &grid, rope: &rope, renderGrid: false)
        return "Tail visited: \(total)"
    }

    private func part2() -> String {
        var grid = Grid()
        var rope = Rope(pos: Coord(2, 4), numSegments: 10)
        let total = run(grid: &grid, rope: &rope, renderGrid: true, pauseBetweenSteps: false)
        return "Tail visited: \(total)"
    }
}

extension Day09.Coord: AdditiveArithmetic {
    static var zero: Self = .init(0, 0)

    static func + (a: Self, b: Self) -> Self {
        .init(a.x + b.x, a.y + b.y)
    }

    static func += (a: inout Self, b: Self) {
        a.x += b.x
        a.y += b.y
    }

    static func - (a: Self, b: Self) -> Self {
        .init(a.x - b.x, a.y - b.y)
    }

    static func -= (a: inout Self, b: Self) {
        a.x -= b.x
        a.y -= b.y
    }
}

extension Day09.Coord: Hashable {}
