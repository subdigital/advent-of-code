
enum Day5 {
    static func run() {
        let input = readFile("day5.input")
        let lineSegments = input.lines.compactMap(LineSegment.parse)

        let maxWidth = lineSegments.flatMap({ [$0.start, $0.end] })
            .map(\.col)
            .max() ?? 1

        let maxHeight = lineSegments.flatMap({ [$0.start, $0.end] })
            .map(\.row)
            .max() ?? 1

        var floor = OceanMap(width: maxWidth + 1, height: maxHeight + 1)
        for segment in lineSegments {
            print(segment.debugDescription)
            floor.addHydrothermalVentLine(segment)
        }

        print(floor.debugDescription)

        print("At least 2 lines overlap:")
        let count = floor.overlapCount(minOverlaps: 2)
        print("\(count)")
    }
}

struct OceanMap {
    let width: Int
    let height: Int

    private var hydrothermalVentCoordinates: [Coordinate: Int] = [:]

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    mutating func addHydrothermalVentLine(_ line: LineSegment) {
        line.coordinates.forEach { coord in 
            hydrothermalVentCoordinates[coord, default: 0] += 1
        }
    }

    func overlapCount(minOverlaps: Int) -> Int {
        hydrothermalVentCoordinates.filter { (key, value) in 
            value >= minOverlaps
        }.count
    }

    var debugDescription: String {
        var output = ""
        for y in 0..<height {
            for x in 0..<width {
                let coord = Coordinate(row: y, col: x)
                let mark = hydrothermalVentCoordinates[coord].flatMap(String.init) ?? "."
                output += mark
            }
            output += "\n"
        }
        return output
    }
}

struct LineSegment {
    let start: Coordinate
    let end: Coordinate

    static func parse(_ line: String) -> LineSegment? {
        let coordinates = line.split(separator: ">")
            .map {
                String($0)
                .trimmingCharacters(in: .whitespaces)
                .replacingOccurrences(of: "-", with: "")
            }
            .compactMap(Coordinate.parse)
        guard coordinates.count == 2 else { return nil }
        return .init(start: coordinates[0], end: coordinates[1])
    }

    var debugDescription: String {
        "\(start.description) -> \(end.description)"
    }

    var coordinates: [Coordinate] {
        func inc(_ p1: Int, _ p2: Int) -> Int {
            let diff = p2 - p1
            if diff == 0 {
                return 0
            }
            if diff < 0 {
                return -1
            }
            return 1
        }

        let xInc = inc(start.col, end.col)
        let yInc = inc(start.row, end.row)
        var p = start
        var coords: [Coordinate] = []
        while p != end {
            coords.append(p)
            p = Coordinate(row: p.row + yInc, col: p.col + xInc)
        }
        coords.append(p)
        return coords
    }
}

