import AOCHelper
import Foundation
import Parsing


enum Day08 {
    enum Node: CustomStringConvertible, Equatable {
        case empty
        case antenna
        case antinode

        var description: String {
            switch self {
            case .empty: return "."
            case .antenna: return "%"
            case .antinode: return "#"
            }
        }
    }

    private static func parse(_ input: String) -> [Character: SparseGrid<Node>] {
        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines).lines
        guard lines.count > 0 else { return [:] }

        var grids: [Character: SparseGrid<Node>] = [:]

        let chars = input.reduce(into: Set<Character>()) { acc, char in
            guard char != "." && !char.isWhitespace else { return }

            acc.insert(char)
        }

        for char in chars {
            let data: [Point: Node] = lines.enumerated()
                .reduce(into: [Point: Node]()) { acc, row in
                    for col in row.element.enumerated() where col.element == char {
                        let point = Point(col.offset, row.offset)
                        let node = Node.antenna
                        acc[point] = node
                    }
                }
            grids[char] = SparseGrid(data: data, width: lines[0].count, height: lines.count)
        }

        return grids
    }

    //
    // . . . A . . # . . A . .
    static func computeAntinodes(for grid: SparseGrid<Node>, repeating: Bool = false) -> SparseGrid<Node> {
        var newGrid = grid

        for a in grid.data where a.value == .antenna {
            for b in grid.data where b.value == .antenna && b.key != a.key {
                let vec = b.key - a.key

                if repeating {
                    var antinodePos = a.key
                    while grid.isInside(antinodePos) {
                        newGrid[antinodePos] = .antinode
                        antinodePos -= vec
                    }

                    antinodePos = b.key
                    while grid.isInside(antinodePos) {
                        newGrid[antinodePos] = .antinode
                        antinodePos += vec
                    }
                } else {
                    // just one on either side
                    let an1 = a.key - vec
                    let an2 = b.key + vec
                    [an1, an2]
                        .filter(grid.isInside)
                        .forEach { an in
                            newGrid[an] = .antinode
                        }
                }
            }
        }

        return newGrid
    }

    static func part1(_ input: String) -> String {
        let grids = parse(input)
        let count = grids.map {
            let antinodeGrid = computeAntinodes(for: $0.value)
            print(antinodeGrid)
            print("---------------------------------\n")
            return antinodeGrid
        }
        .reduce(into: Set<Point>()) { set, grid in
            for point in grid.searchAll(for: .antinode) {
                set.insert(point)
            }
        }
        .count

        return "\(count)"
    }

    static func part2(_ input: String) -> String {
        let grids = parse(input)
        let count = grids.map {
            let antinodeGrid = computeAntinodes(for: $0.value, repeating: true)
//            print(antinodeGrid)
//            print("---------------------------------\n")
            return antinodeGrid
        }
        .reduce(into: Set<Point>()) { set, grid in
            for point in grid.searchAll(for: .antinode) {
                set.insert(point)
            }
        }
        .count

        return "\(count)"
    }
}

let input = try readInput(from: .module)
print("DAY 08 Part 1: ")
print(Day08.part1(input))
print("---------------------")

print("DAY 08 Part 2: ")
print(Day08.part2(input))
print("---------------------")

