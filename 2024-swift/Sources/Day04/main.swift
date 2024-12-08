import AOCHelper
import Foundation

private extension Grid where Element == Character {
    // X M
    func searchNeighbors(
        from: Point,
        dir: Point,
        for characters: [Character]
    ) -> Bool {
        guard !characters.isEmpty else { return false }

        var characters = characters
        let next = from + dir
        guard isInside(next) else { return false }

        let target = characters.removeFirst()

        guard self[next.x, next.y] == target else {
            return false
        }

        if characters.isEmpty {
            return true
        }

        return searchNeighbors(from: next, dir: dir, for: characters)
    }
}

struct Day04 {
    private static func parseGrid(_ input: String) -> Grid<Character> {
        let data = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lines.map { line in
            Array(line)
        }
        return Grid(data: data)
    }

    static func part1(_ input: String) -> String {
        let grid = parseGrid(input)

        var count = 0
        for row in 0..<grid.rows {
            for col in 0..<grid.cols {
                let point = Point(col, row)
                let char = grid[point.x, point.y]
                if char == "X" {
                    let charsToSearch = Array("MAS")
                    let all: [Point] = [
                        .up, .down, .left, .right,
                        .upRight, .upLeft, .downRight, .downLeft
                    ]

                    count += all.filter({ dir in
                        grid.searchNeighbors(from: point, dir: dir, for: charsToSearch)
                    }).count
                }
            }
        }

        return "\(count)"
    }

    static func part2(_ input: String) -> String {
        let grid = parseGrid(input)

        print(grid)

        var count = 0
        for row in 0..<grid.rows {
            for col in 0..<grid.cols {
                let point = Point(col, row)
                let char = grid[point.x, point.y]
                if char == "A" {
                    let charsToSearch = Array("AS")
                    let all: [Point] = [.upRight, .upLeft, .downRight, .downLeft]

                    let hasX = all.filter({ dir in
                        // reflect dir over current point
                        let start = point + Point(-dir.x, -dir.y)
                        guard
                            grid.isInside(start),
                            grid[start] == "M"
                        else { return false }

                        let found = grid.searchNeighbors(from: start, dir: dir, for: charsToSearch)
                        if found {
                            print("found: \(start), \(start + dir), \(start + dir + dir) => " +
                                  "\(grid[start]) \(grid[start + dir]) \(grid[start + dir + dir])"
                            )
                        }

                        return found
                    }).count == 2

                    if hasX {
                        count += 1
                    }
                }
            }
        }

        return "\(count)"
    }
}

let input = try readInput(from: .module)
print("DAY 04 Part 1: ")
print(Day04.part1(input))
print("---------------------")

print("DAY 04 Part 2: ")
print(Day04.part2(input))
print("---------------------")
