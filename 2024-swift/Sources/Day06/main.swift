import AOCHelper
import Foundation
import Parsing

extension Point {
    static func cornerPoint(_ a: Point, _ b: Point, direction: Direction) -> Point {
        if direction.isVertical {
            Point(a.x, b.y)
        } else {
            Point(b.x, a.y)
        }
    }
}

extension Grid where T: Equatable {
    func findOne(for target: T) -> Point {
        for y in 0..<rows {
            for x in 0..<cols {
                if self[x, y] == target {
                    return Point(x, y)
                }
            }
        }

        fatalError("Not found")
    }

    func look(from pos: Point, for target: T, dir: Direction) -> Point? {
        var next = pos + dir.offset
        while isInside(next) {
            if self[next.x, next.y] == target {
                return next
            }

            next = next + dir.offset
        }

        return nil 
    }

    mutating func swap(_ a: Point, _ b: Point) {
        let temp = self[a.x, a.y]
        self[a.x, a.y] = self[b.x, b.y]
        self[b.x, b.y] = temp
    }
}

enum Day06 {
    enum Cell: Character, CustomStringConvertible {
        case empty = "."
        case obstacle = "#"
        case `guard` = "^"
        case visited = "X"
        case travelHorizontal = "-"
        case travelVertical = "|"
        case travelBoth = "+"
        case potentialBlock = "O"

        var description: String {
            String(rawValue)
        }
    }

    private static func parseGrid(_ input: String) -> Grid<Cell> {
        let data = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lines.map { line in line.compactMap(Cell.init) }

        return Grid(data: data)
    }

    static func part1(_ input: String) -> String {
        var grid = parseGrid(input)
        var guardPos = grid.findOne(for: .guard)
        var dir = Direction.up
        var visited = Set<Point>()

        while true {
            visited.insert(guardPos)

            let nextPos = guardPos + dir.offset
            guard grid.isInside(nextPos) else { break }

            if grid.isInside(nextPos) && grid[nextPos] == .obstacle {
                dir = dir.turnRight()
            } else {
                grid[guardPos] = .visited
                grid[nextPos] = .guard

                guardPos = nextPos
            }
        }

        print(grid)
        return "\(visited.count)"
    }

    static func part2(_ input: String) -> String {
        var grid = parseGrid(input)
        var guardPos = grid.findOne(for: .guard)
        var dir = Direction.up
        var visited = Set<Point>()

        var potentialBlocks: Set<Point> = []

        while true {
            visited.insert(guardPos)

            // are we in a potential loop?
            // . A . . . .
            // . . . . . B
            // D . . . . .
            // . . . . C .
            let a = grid.look(from: guardPos, for: .obstacle, dir: dir)
            let d = grid.look(from: guardPos, for: .obstacle, dir: dir.mirror())

            var potentialBlock: Point?

            if let a {
                // is there a block to the right of the one ahead?
                if let b = grid.look(
                    from: a + dir.mirror().offset,
                    for: .obstacle,
                    dir: dir.turnRight()
                ) {
                    // search for C or D
                    if let c = grid.look(
                        from: b + dir.turnRight().mirror().offset,
                        for: .obstacle,
                        dir: dir.turnRight().turnRight()
                    ) {
                        // we can insert D!
                        let posLeftOfA = a + dir.turnRight().mirror().offset
                        let posBeforeC = c + dir.turnRight().turnRight().mirror().offset

                        potentialBlock = Point.cornerPoint(posLeftOfA, posBeforeC, direction: dir)
                    } else if let d {
                        // we can insert C!
                        let posBeforeB = b + dir.turnRight().mirror().offset
                        let posAfterD = d + dir.turnRight().turnRight().offset

                        potentialBlock = Point.cornerPoint(posBeforeB, posAfterD, direction: dir)
                    }
                } else if let d, let c = grid.look(
                    from: d + dir.turnRight().turnRight().offset,
                    for: .obstacle,
                    dir: dir.turnRight()
                ) {
                    // we can insert B!
                    let posBeforeA = a + dir.mirror().offset
                    let posBeforeC = c + dir.turnRight().turnRight().mirror().offset

                    potentialBlock = Point.cornerPoint(posBeforeA, posBeforeC, direction: dir)
                }
            } else if
                let d,
                let b = grid.look(from: guardPos, for: .obstacle, dir: dir.turnRight()),
                let _ = grid.look(from: b + dir.turnRight().mirror().offset, for: .obstacle, dir: dir.turnRight().turnRight())
            {
                // we can insert A!
                let posBeforeB = b + dir.turnRight().mirror().offset
                let posAfterD = d + dir.turnRight().offset

                potentialBlock = Point.cornerPoint(posBeforeB, posAfterD, direction: dir)
            }

            if let potentialBlock, !potentialBlocks.contains(potentialBlock) {
                grid[potentialBlock] = .potentialBlock
                potentialBlocks.insert(potentialBlock)
                // print, then wipe travel marks
                print(grid)

                for y in 0..<grid.rows {
                    for x in 0..<grid.cols {
                        let cell = grid[x, y]
                        if cell == .travelBoth || cell == .travelVertical || cell == .travelHorizontal {
                            grid[x, y] = .empty
                        }
                    }
                }

                grid[potentialBlock] = .empty
            }

            // move to the next position
            let nextPos = guardPos + dir.offset
            guard grid.isInside(nextPos) else { break }

            if grid.isInside(nextPos) && grid[nextPos] == .obstacle {
                grid[guardPos] = .travelBoth
                dir = dir.turnRight()
            } else {
                grid[guardPos] = dir.isHorizontal ? .travelHorizontal : .travelVertical
                grid[nextPos] = .guard

                guardPos = nextPos
            }
        }

        print(grid)
        print("Potential blocks: \(potentialBlocks)")

        return "\(potentialBlocks.count)"
    }
}

let input = try readInput(from: .module)
print("DAY 06 Part 1: ")
print(Day06.part1(input))
print("---------------------")

