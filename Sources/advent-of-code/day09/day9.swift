
enum Day9 {
    static func run() {
        let input = readFile("day9.input")
        let values = input.lines.map { line in
            line.compactMap { Int(String($0)) }
        }
        let map = HeightMap(values: values)
        print("low points: ", map.lowPoints().map { map.height(at: $0) })
        let risks = map.lowPointRisks()
        print("risks: ", risks)
        let sum = risks.reduce(0, +)
        print("Sum of low points: \(sum)")

        let basins = map.findBasins()
        print("Basins: \(basins)")
        guard basins.count >= 3 else { return }
        let biggestBasins = basins.sorted().reversed()[0...2]
        print("biggest 3: \(biggestBasins)")
        print("basin product: \(biggestBasins.reduce(1, *))")
    }
}


struct HeightMap {
    let values: [[Int]]

    struct Coordinate: Hashable, CustomStringConvertible {
        let row: Int
        let col: Int
        var description: String {
            "[\(col), \(row)]"
        }
    }

    var mapHeight: Int {
        values.count
    }

    var mapWidth: Int {
        values.first?.count ?? 0
    }

    func isValidCoordinate(_ c: Coordinate) -> Bool {
        c.col >= 0 && c.col < mapWidth && c.row >= 0 && c.row < mapHeight
    }

    func look(from: Coordinate, offset: Coordinate) -> (coord: Coordinate, height: Int)? {
        let newCoordinate = from + offset
        guard isValidCoordinate(newCoordinate) else { return nil }
        return (newCoordinate, height(at: newCoordinate))
    }

    func findBasins() -> [Int] {
        var basins: [Int] = []
        var knownBasinCoords: Set<Coordinate> = []

        for lowPoint in lowPoints() {
            let basinCoordinates = neighborsSlopingUpward(from: lowPoint) + [lowPoint]
            print("starting from low point: \(lowPoint)")
            print("Basin coordinates: \(basinCoordinates)")
            knownBasinCoords.formUnion(basinCoordinates)

            print("BASIN FOUND: \(basinCoordinates.count)")
            basins.append(basinCoordinates.count)
        }

        return basins
    }

    func neighborsSlopingUpward(from: Coordinate) -> [Coordinate] {
        let thisHeight = height(at: from)
        var results: Set<Coordinate> = []
        let filteredNeighbors = neighbors(for: from)
            .filter { n in
                let h = height(at: n)
                return h != 9 && h > thisHeight
            } 
        for n in filteredNeighbors {
            if !results.contains(n) {
                results.insert(n)
                neighborsSlopingUpward(from: n).forEach {
                    results.insert($0)
                }
            }
        }

        return Array(results)
    }

    func lowPoints() -> [Coordinate] {
        var lowPoints: [Coordinate] = []
        var knownHighPointIndices: Set<Coordinate> = []

        for row in 0..<values.count {
            for col in 0..<values[row].count {
                let coord = Coordinate(row: row, col: col)
                if knownHighPointIndices.contains(coord) {
                    continue
                }

                let neighbors = neighbors(for: coord)
                let neighborHeights = neighbors.map { 
                    (coord: $0, height: height(at: $0))
                }
                
                let thisHeight = height(at: coord)
                if neighborHeights.allSatisfy({ $0.height > thisHeight }) {
                    lowPoints.append(coord)
                    knownHighPointIndices.formUnion(neighbors)
                }
            }
        }
        return lowPoints
    }

    func lowPointRisks() -> [Int] {
        lowPoints()
            .map { c in
                height(at: c)
            }
            .map { $0 + 1 }
    }

    func height(at coordinate: Coordinate) -> Int {
        values[coordinate.row][coordinate.col]
    }

    func neighbors(for c: Coordinate) -> Set<Coordinate> {
        guard !values.isEmpty else { return [] }
        var neighbors: Set<Coordinate> = []
        if c.row > 0 {
            neighbors.insert(.init(row: c.row - 1, col: c.col))
        }
        if c.col > 0 {
            neighbors.insert(.init(row: c.row, col: c.col - 1))
        }
        if c.row < values.count - 1 {
            neighbors.insert(.init(row: c.row + 1, col: c.col))
        }
        if c.col < values[0].count - 1 {
            neighbors.insert(.init(row: c.row, col: c.col + 1))
        }
        return neighbors
    }
}

extension HeightMap.Coordinate {
    static func + (lhs: Self, rhs: Self) -> Self {
        .init(row: lhs.row + rhs.row, col: lhs.col + rhs.col)
    }
}
