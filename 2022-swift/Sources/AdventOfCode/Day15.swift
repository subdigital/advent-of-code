import AOCShared
import Foundation

struct Day15: Challenge {
    let input: String

    func run() -> String {
        print("PART 1:")
        part1()

        print("-------------------")
        print("PART 2:")
        part2()


        return ""
    }

    private func part1() {
        let sensors = parse(input)
        print(sensors)

        let testRow = 2_000_000

        let nonBeacons = sensors.reduce(into: Set<Coord>()) { nonBeacons, sensor in
            let coverage = sensor.nonBeaconCoverageInRow(row: testRow)
            coverage.forEach {
                nonBeacons.insert($0)
            }
        }

        print("Row \(testRow) has \(nonBeacons.count) rows that are definitely NOT beacons")
    }


    private func part2() {
        let sensors = parse(input)

        var posIntercepts: Set<Int> = []
        var negIntercepts: Set<Int> = []

        let minX = 0
        let minY = 0
        let maxX = 20
        let maxY = 20

        let gridSize = 40

        var grid = Grid(data: .init(repeating: ".", count: gridSize * gridSize), width: gridSize, height: gridSize)
        grid.origin = (-10, -10)
        grid.showAxes = true

        var sensorsCompared: [Sensor: Sensor] = [:]
        for sensor in sensors {
            grid.replace(char: "S", at: (sensor.coord.x, sensor.coord.y))
            grid.replace(char: "B", at: (sensor.beacon.x, sensor.beacon.y))

            for coord in sensor.manhattanCoords {
                if grid[(coord.x, coord.y)] == "." {
                    grid.replace(char: "#", at: (coord.x, coord.y))
                }
            }

            print(grid)

            for other in sensors where other != sensor && sensorsCompared[other] != sensor {
                sensorsCompared[sensor] = other
                // y = mx + b

                // positive slope cases
                // sy = (1)sx + sb
                // sb = sy - sx
                // tb = ty - tx
                // sb - tb

                func positiveGapLineIntercept(_ s: Coord, t: Coord) -> Int? {
                    let sb = s.y - s.x
                    let tb = t.y - t.x
                    let gap = abs(sb - tb)
                    //    X.Y
                    //    Y.X
                    return gap == 2 ? min(sb, tb) + 1 : nil
                }

                [
                    positiveGapLineIntercept(sensor.left, t: other.left),
                    positiveGapLineIntercept(sensor.left, t: other.right),
                    positiveGapLineIntercept(sensor.right, t: other.left),
                    positiveGapLineIntercept(sensor.right, t: other.right)
                ]
                    .compactMap { $0 }
                    .forEach {
                        posIntercepts.insert($0)
                    }

                // negative slope case
                // y = (-1)x + b
                // b = y + x
                func negativeGapLineIntercept(_ s: Coord, t: Coord) -> Int? {
                    let sb = s.y + s.x
                    let tb = t.y + t.x
                    let gap = abs(sb - tb)
                    //    X.Y
                    //    Y.X
                    return gap == 2 ? min(sb, tb) + 1 : nil
                }

                [
                    negativeGapLineIntercept(sensor.left, t: other.left),
                    negativeGapLineIntercept(sensor.left, t: other.right),
                    negativeGapLineIntercept(sensor.right, t: other.left),
                    negativeGapLineIntercept(sensor.right, t: other.right)
                ]
                    .compactMap { $0 }
                    .forEach {
                        negIntercepts.insert($0)
                    }
            }
        }

        // lines
        // y = mx + A
        // y = nx + B
        // mx + A = nx + B
        // mx - nx = B - A
        // x(m-n) = B-A
        // x = (B-A) / (m-n)

        let results = posIntercepts.flatMap { p in
            negIntercepts.map { n in
                (p, n)
            }
        }
        .map(computeIntersection)
        .filter { coord in
            (minX...maxX).contains(coord.x) && (minY...maxY).contains(coord.y)
        }
        .filter { coord in
            sensors.contains { sensor in
                sensor.contains(coord)
            }
        }

        print(results)
        print("")

//        for pos in posIntercepts {
//            for neg in negIntercepts {
//                let x = (neg-pos) / (1 - (-1))
//                let y = x + pos
//                if (minX...maxX).contains(x) && (minY...maxY).contains(y) {
//                    for sensor in sensors where !sensor.contains(Coord(x, y)) {
//                        print("Intersects at (\(x), \(y))")
//                    }
//                }
//            }
//        }
    }

    private func computeIntersection(interceptA: Int, interceptB: Int) -> Coord {
        let x = (interceptB-interceptA) / (1 - (-1))
        let y = x + interceptA
        return Coord(x, y)
    }

    private func parse(_ input: String) -> [Sensor] {
        input.lines()
            .filter { !$0.isEmpty }
            .map(Sensor.parse)
    }

    struct Sensor: Equatable, Hashable {
        let coord: Coord
        let beacon: Coord

        static func parse(_ input: some StringProtocol) -> Self {
            let scanner = Scanner(string: String(input))
            guard
                let sx = scanner.scanEqualsToInt(),
                let sy = scanner.scanEqualsToInt(),
                let bx = scanner.scanEqualsToInt(),
                let by = scanner.scanEqualsToInt()
            else {
                fatalError()
            }
            return .init(coord: .init(sx, sy), beacon: .init(bx, by))
        }

        var radiusToBeacon: Int {
            // taxicab / manhattan radius
            abs(coord.x - beacon.x) + abs(coord.y - beacon.y)
        }

        var manhattanCoords: [Coord] {
            let radius = radiusToBeacon
            var coords: [Coord] = []
            for y in (coord.y-radius...coord.y+radius) {
                let diff = abs(y - coord.y)
                let xDelta = radius - diff
                for x in (coord.x-xDelta...coord.x+xDelta) {
                    coords.append(.init(x, y))
                }
            }
            return coords
        }

        func contains(_ pos: Coord) -> Bool {
            let nonBeacons = nonBeaconCoverageInRow(row: pos.y)
            return nonBeacons.contains(pos)
        }

        /// Return the coordinates that this sensor guarantees there are no beacons
        func nonBeaconCoverageInRow(row: Int) -> [Coord] {
            let dy = abs(row - coord.y)
            if abs(dy) > radiusToBeacon {
                return []
            }

            let dx = radiusToBeacon - dy
            return (-dx...dx).compactMap { x in
                let coord = Coord(self.coord.x + x, row)
                guard beacon != coord else { return nil }

                return coord
            }
        }

        var left: Coord {
            Coord(coord.x - radiusToBeacon, coord.y)
        }

        var right: Coord {
            Coord(coord.x + radiusToBeacon, coord.y)
        }
    }

    struct Coord: Equatable, Hashable, CustomStringConvertible {
        var x: Int
        var y: Int

        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }

        var description: String {
            "(\(x), \(y))"
        }
    }
}

private extension Scanner {
    func scanEqualsToInt() -> Int? {
        guard let _ = scanUpToString("=") else { return nil }
        guard let _ = scanCharacter() else { return nil }
        var value = 0
        if scanInt(&value) {
            return value
        } else {
            return nil
        }
    }
}
