import AOCHelper
import Foundation

enum Day10 {

    struct Pathfinder {
        let grid: Grid<Int>

        typealias Path = [Point]
        typealias Trails = [Point: [Path]]

        func goodTrails(_ start: Point, path: Path = []) -> [Path] {
            print("path: \(path) -> [\(start)]")
            print("  path: \(path.map{ grid[$0] }) -> [\(grid[start])]")
            let path = path + [start]

            if grid[start] == 9 {
                return [path]
            }

            var goodPaths: Set<Path> = []

            // where can we move?
            let validNeighbors = grid.neighbors(for: start).filter({ grid[$0] == grid[start] + 1 })
            for neighbor in validNeighbors {
                let neighborPaths = goodTrails(neighbor, path: path)
                goodPaths = goodPaths.union(Set(neighborPaths))
            }
            print("  FROM: \(start) there are \(goodPaths.count) good paths.")

            return Array(goodPaths)
        }
    }

    static func parse(_ input: String) -> Grid<Int> {
        let data: [[Int]] = input.trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: "\n")
            .map { (line: String.SubSequence) in
                Array(line).map { Int(String($0)) ?? Int.max }
            }

        return Grid(data: data)
    }

    static func part1(_ input: String) async throws -> String {
        let grid = parse(input)
        let pathfinder = Pathfinder(grid: grid)

        // where are the starting points?
        let trailheads = grid.searchAll(for: 0)

        let trails = trailheads.flatMap { pathfinder.goodTrails($0) }

        let scores = trailheads.map { trailhead in
            let summits = Set(trails
                .filter { trail in
                    trail[0] == trailhead
                }
                .compactMap(\.last)
            ).count

            return summits
        }

        let sum = scores.reduce(0, +)
        return "\(sum)"
    }

    static func part2(_ input: String) async throws -> String {
        let grid = parse(input)
        let pathfinder = Pathfinder(grid: grid)

        // where are the starting points?
        let trailheads = grid.searchAll(for: 0)

        let trails = trailheads.flatMap { pathfinder.goodTrails($0) }

        let ratings = trailheads.map { trailhead in
            trails.count(where: { trail in
                trail.first == trailhead
            })
        }

        let sum = ratings.reduce(0, +)
        return "\(sum)"
    }
}

let input = try readInput(from: .module)
print("DAY 10 Part 1: ")
print(try await Day10.part1(input))
print("---------------------")
print("DAY 10 Part 2: ")
print(try await Day10.part2(input))
print("---------------------")
