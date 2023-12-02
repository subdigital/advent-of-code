import Algorithms

enum Day11 {
    static func run() {
        let input = readFile("day11.input")

        var sim = EnergyLevelSimulation(initialGrid: .parse(input))
        print(sim.grid)

        let maxSteps = 10_000
        for step in 1...maxSteps {
            sim.tick()
            if sim.allFlashed() {
                print("------after \(step) step(s) ----")
                print(sim.grid)
                print()
                print("Flashes: \(sim.flashCount)")
                break
            }
        }
    }
}

struct EnergyLevelSimulation {
    private(set) var grid: Grid<Int>
    private(set) var flashCount = 0

    init(initialGrid: Grid<Int>) {
        self.grid = initialGrid
    }

    private var neighborCache: [Coordinate: Set<Coordinate>] = [:]
    private mutating func neighbors(_ coordinate: Coordinate) -> Set<Coordinate> {
        if let cachedNeighbors = neighborCache[coordinate] {
            return cachedNeighbors
        }
        
        let rows = (-1...1)
        let cols = (-1...1)
        let validColRange = 0..<grid.width
        let validRowRange = 0..<grid.height
        var neighbors = Set<Coordinate>()
        for (rowOffset, colOffset) in product(rows, cols) {
            if (rowOffset, colOffset) == (0, 0) {
                // skip this coordinate
                continue
            }

            let r = coordinate.row + rowOffset
            let c = coordinate.col + colOffset
            if validColRange ~= c && validRowRange ~= r {
                neighbors.insert(Coordinate(row: r, col: c))
            }
        }

        neighborCache[coordinate] = neighbors
        return neighbors
    }

    mutating func tick() {
        // increment first
        var newGrid = grid.map { $0 + 1 }

        func checkFlash(_ coordinate: Coordinate, in grid: inout Grid<Int>) {
            if grid[coordinate] > 9 {
                // flash
                flashCount += 1
                grid[coordinate] = 0

                for neighbor in neighbors(coordinate) {
                    if grid[neighbor] == 0 {
                        // already flashed, skip it
                        continue
                    }
                    grid[neighbor] += 1
                    checkFlash(neighbor, in: &grid)
                }
            }
        }

        for row in 0..<grid.height {
            for col in 0..<grid.width {
                let coordinate = Coordinate(row: row, col: col)
                checkFlash(coordinate, in: &newGrid)
            }
        }

        self.grid = newGrid
    }

    func allFlashed() -> Bool {
        grid.allSatisfy { $0 == 0 }
    }
}

struct Grid<Value> {
    private var data: [[Value]]

    var height: Int {
        data.count
    }

    var width: Int {
        data.first?.count ?? 0
    }

    init(_ values: [[Value]]) {
        self.data = values
    }

    subscript(row: Int, col: Int) -> Value {
        get {
            data[row][col]
        }
        set {
            data[row][col] = newValue
        }
    }

    subscript(coordinate: Coordinate) -> Value {
        get {
            data[coordinate.row][coordinate.col]
        }
        set {
            data[coordinate.row][coordinate.col] = newValue
        }
    }
}

extension Grid {
    func map<U>(_ fn: (Value) -> U) -> Grid<U> {
        Grid<U>(
            data.map { row in 
                row.map(fn)
            }
        )
    }

    func allSatisfy(_ fn:  (Value) -> Bool) -> Bool {
        data.allSatisfy { row in 
            row.allSatisfy(fn)
        }
    }
}

extension Grid: CustomStringConvertible where Value == Int {
    var description: String {
        data.map { row in 
            row.map { String($0) }.joined()
        }.joined(separator: "\n")
    }
}

extension Grid where Value == Int {
    static func parse(_ input: String) -> Self {
        let data = input.lines
            .map { Array($0).compactMap(Int.init) }
        return Grid(data)
    }
}

struct Coordinate: Hashable, CustomStringConvertible {
    let row: Int
    let col: Int

    var description: String {
        "[\(col), \(row)]"
    }

    static func parse(_ string: String) -> Coordinate? {
        let parts = string
            .trimmingCharacters(in: .whitespaces)
            .split(separator: ",")
            .compactMap(Int.init)

        guard parts.count == 2 else {
            return nil
        }

        return Coordinate(row: parts[1], col: parts[0])
    }

}


