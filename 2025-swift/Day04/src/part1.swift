import AOCHelper
import Foundation
import Parsing

struct Vector2: Hashable {
    let x: Int
    let y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}
extension Vector2: CustomDebugStringConvertible {
    var debugDescription: String { "(\(x), \(y))"}
}

typealias Coordinate = Vector2

protocol Cell {
    var character: Character { get }
}

struct PaperRoll: Cell {
    var character: Character { "@" }
}
extension PaperRoll: CustomDebugStringConvertible {
    var debugDescription: String { "@" }
}

struct SparseGrid<CellType: Cell> {
    var width = 0
    var height = 0
    private var sparse: [Coordinate: CellType] = [:]

    mutating func add(row: [CellType?]) {
        // expand grid
        let y = height
        height += 1
        width = Swift.max(width, row.count)

        for (x, cell) in row.enumerated() {
            if let cell {
                let coord = Coordinate(x, y)
                sparse[coord] = cell
            }
        }
    }

    mutating func removeCell(at coord: Coordinate) {
        sparse[coord] = nil
    }

    func printGrid() {
        for y in 0..<height {
            for x in 0..<width {
                let coord = Coordinate(x, y)
                let cell = sparse[coord]?.character ?? "."
                print(cell, terminator: "")
            }
            print()
        }
    }

    private func neighbors(_ x: Int, _ y: Int) -> [Coordinate] {
        return [
            Coordinate(x-1, y),
            Coordinate(x+1, y),
            Coordinate(x, y-1),
            Coordinate(x, y+1),
            Coordinate(x-1, y-1),
            Coordinate(x+1, y-1),
            Coordinate(x+1, y+1),
            Coordinate(x-1, y+1),
        ].filter { $0.x >= 0 && $0.x <= width - 1 && $0.y >= 0 && $0.y <= height - 1 }
    }

    mutating func removeIfPossible(_ x: Int, _ y: Int) -> Int {
        var removed = 0
        guard sparse.keys.contains(Coordinate(x, y)) else {
            return 0
        }

        // check neighbors, if < 4 we can remove
        let neighbors = self.neighbors(x, y).filter { sparse.keys.contains($0) }
        if neighbors.count < 4 {
            removeCell(at: Coordinate(x, y))
            removed += 1

            for neighbor in neighbors {
                removed += removeIfPossible(neighbor.x, neighbor.y)
            }
        }

        return removed
    }

    func neighborCount(_ x: Int, _ y: Int) -> Int {
        let neighbors = self.neighbors(x, y)
        let keys = sparse.keys
        return neighbors.count(where: { keys.contains($0) })
    }
}

extension SparseGrid: Sequence {
    struct Iterator: IteratorProtocol {
        let data: [Coordinate: Cell]
        var coords: any IteratorProtocol<Coordinate>
        init(data: [Coordinate: Cell]) {
            self.data = data
            self.coords = data.keys.makeIterator()
        }
        mutating func next() -> (Cell, Coordinate)? {
            guard let coord = coords.next() else { return nil }
            return (data[coord]!, coord)
        }
    }
    func makeIterator() -> Iterator {
        Iterator(data: sparse)
    }
}

func parse(_ input: String) throws -> SparseGrid<PaperRoll> {
    return input.lines().map { line in
        line.map {  $0 == "@" ? PaperRoll() : nil }
    }.reduce(into: SparseGrid<PaperRoll>()) { grid, row in
        grid.add(row: row)
    }
}


enum Part1 {
    static func process(_ input: String) throws -> String {
        let grid = try parse(input)

        let answer = grid.count(where: { (_, coord) in
            let n = grid.neighborCount(coord.x, coord.y)
            return n < 4
        })

        return "\(answer)"
    }
}
