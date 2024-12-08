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

extension Grid: Sequence {
    public struct Iterator: IteratorProtocol {
        let grid: Grid
        var currentRow: Int
        var currentColumn: Int

        init(grid: Grid) {
            self.grid = grid
            self.currentRow = 0
            self.currentColumn = 0
        }

        public mutating func next() -> (Point, Element)? {
            guard currentRow < grid.data.count else { return nil }

            let point = Point(currentColumn, currentRow)
            let el = grid[point]

            currentColumn += 1
            if currentColumn >= grid.data[currentRow].count {
                currentColumn = 0
                currentRow += 1
            }

            return (point, el)
        }
    }

    public func makeIterator() -> Iterator {
        Iterator(grid: self)
    }
}

extension Grid where Element: Equatable {
    func findOne(for target: Element) -> Point {
        for y in 0..<rows {
            for x in 0..<cols {
                if self[x, y] == target {
                    return Point(x, y)
                }
            }
        }

        fatalError("Not found")
    }

    func look(from pos: Point, for target: Element, dir: Direction) -> Point? {
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
    enum Cell: Character, CustomStringConvertible, Sendable {
        case empty = "."
        case obstacle = "#"
        case `guard` = "^"
        case visited = "X"
        case travelHorizontal = "-"
        case travelVertical = "|"
        case travelBoth = "+"
        case potentialBlock = "O"

        var isBlocked: Bool {
            self == .obstacle || self == .potentialBlock
        }

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

    private static func runInfiniteLoopTest(on grid: Grid<Cell>, guardPosition: Point) -> Bool {
        var visited = [Point: Set<Direction>]()
        var grid = grid

        var iterations = 0
        var dir = Direction.up
        var guardPos = guardPosition

        while true {
            iterations += 1
            if iterations >= 10000 {
                print("Breaking out to prevent infinite loop")
                break
            }

            visited[guardPos, default: []].insert(dir)

            // move to the next position
            let nextPos = guardPos + dir.offset
            guard grid.isInside(nextPos) else { break }

            if visited[nextPos]?.contains(dir) == true {
                // Frodo voice: we've been here before!
                // loop detected
                return true
            }

            if grid.isInside(nextPos) && grid[nextPos].isBlocked {
                grid[guardPos] = .travelBoth
                dir = dir.turnRight()
            } else {
                grid[guardPos] = dir.isHorizontal ? .travelHorizontal : .travelVertical
                grid[nextPos] = .guard

                guardPos = nextPos
            }
        }

        return false
    }

    static func part2(_ input: String) async -> String {
        let grid = parseGrid(input)

        let obstaclePositions = grid
            .filter { $0.1 != .guard && $0.1 != .obstacle }
            .map { $0.0 }

        let guardPos = grid.findOne(for: .guard)

        let validGrids = await withTaskGroup(of: Grid<Cell>?.self) { group in
            for pos in obstaclePositions {
                group.addTask {
                    let task: Task<Grid<Cell>?, Never> = Task.detached {
                        print("Testing position: \(pos)")
                        var testGrid = grid
                        testGrid[pos] = .obstacle
                        if runInfiniteLoopTest(on: testGrid, guardPosition: guardPos) {
                            print("  position: \(pos) -> YES")
                            return testGrid
                        } else {
                            print("  position: \(pos) -> NO")
                            return nil
                        }
                    }
                    return await task.value
                }
            }

            var sum = 0
            for await grid in group where grid != nil {
                sum += 1
            }
            return sum
        }

        return "\(validGrids)"
    }
}

let input = try readInput(from: .module)
print("DAY 06 Part 1: ")
print(Day06.part1(input))
print("---------------------")

print("DAY 06 Part 2: ")
print(await Day06.part2(input))
print("---------------------")

