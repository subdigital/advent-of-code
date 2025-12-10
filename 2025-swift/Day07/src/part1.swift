import AOCHelper
import Foundation
import Parsing

struct TachyonManifold {
    enum Element: String, CustomStringConvertible {
        case source = "S"
        case empty = "."
        case beam = "|"
        case splitter = "^"
        case chargedSplitter = "⚡"

        var description: String {
            switch self {
            case .source: "\u{001B}[33;1mS\u{001B}[0m"
            case .empty: "\u{001B}[90;2m.\u{001B}[0m"
            case .beam: "\u{001B}[93m|\u{001B}[0m"
            case .splitter: "\u{001B}[95;1m^\u{001B}[0m"
            case .chargedSplitter: "\u{001B}[96;1m^\u{001B}[0m"
            }
        }
    }

    var grid: Grid<Element>

    private(set) var splitCount = 0
    var y = 0

    var isAtEnd: Bool {
        y >= grid.rows
    }

    mutating func step() {
        let isLastRow = y == grid.rows - 1
        for (x, el) in grid[y].enumerated() {
            switch el {
                case .empty: break
                case .source: // spawn a new beam down
                    assert(!isLastRow, "Can't have a source at the end")
                    grid[x, y+1] = .beam

                case .splitter: break

                case .chargedSplitter: // spawn beams l/r
                    assert(!isLastRow, "Can't have a splitter at the end")
                    if x > 0 {
                        grid[x-1, y+1] = .beam
                    }
                    if x < grid.cols {
                        grid[x+1, y+1] = .beam
                    }
                    grid[x, y] = .splitter
                    splitCount += 1

                case .beam: // move beam down
                    if isLastRow {
                        break
                    }
                    grid[x, y] = .empty
                    switch grid[x, y+1] {
                        case .beam: break
                        case .splitter: grid[x, y+1] = .chargedSplitter
                        case .empty: grid[x, y+1] = .beam
                        default:
                        assertionFailure("wat is happening")
                        // grid[x, y+1] = .beam
                    }
            }
        }
        y += 1
    }

    static func parse(input: String) throws -> TachyonManifold {
        let data = input.lines().map { line in
            line.map { char in
                guard let el = Element(rawValue: String(char)) else {
                    fatalError("failed to parse el: \(char)")
                }
                return el
            }
        }

        return TachyonManifold(grid: Grid(data: data))
    }
}


enum Part1 {
    static func process(_ input: String) throws -> String {
        var manifold = try TachyonManifold.parse(input: input)

        // print(manifold.grid)

        while !manifold.isAtEnd {
            // print("Step")
            manifold.step()
            // print(manifold.grid)
        }

        return "\(manifold.splitCount)"

    }
}
