import AOCHelper
import Foundation
import Parsing

extension Grid<Character> {
    func regions() -> [Day12.Region] {
        var regions: [Day12.Region] = []

        var visited: Set<Point> = []
        for (point, _) in self {
            guard !visited.contains(point) else { continue }

            let region = detectRegion(at: point)
            visited.formUnion(region.points)

            regions.append(region)
        }

        return regions
    }

    func detectRegion(at point: Point) -> Day12.Region {
        let char = self[point]
        var regionPoints: Set<Point> = []
        var visited: Set<Point> = Set()
        var pointsToVisit: Set<Point> = Set([point])

        while let p = pointsToVisit.popFirst() {
            visited.insert(p)

            if self[p] == char {
                regionPoints.insert(p)

                for n in neighbors(for: p) where !visited.contains(n) {
                    pointsToVisit.insert(n)
                }
            } else {
                // we can detect a region here!
            }
        }

        return Day12.Region(
            character: char,
            points: regionPoints
        )
    }
}

enum Day12 {
    struct Region: Hashable {
        let character: Character
        let points: Set<Point>

        var perimeter: Int {
            var perimeter = 0
            for point in points {
                let rest = points.subtracting([point])

                for dir in [Point.up, .down, .left, .right] {
                    if !rest.contains(point + dir) {
                        perimeter += 1
                    }
                }
            }
            return perimeter
        }

        var area: Int {
            points.count
        }

        var sides: Int {
            var corners: Int = 0

            // check outer corners
            let cornersToCheck: [(Point, Point)] = [
                (.up, .left),
                (.down, .left),
                (.down, .right),
                (.up, .right)
            ]


            for point in points {
                let newCorners = cornersToCheck
                    .map { pair in
                        (
                            a: point + pair.0,  // i.e. up
                            b: point + pair.1,  // i.e. left
                            c: point + pair.0 + pair.1 // diag
                        )
                    }
                    .count(where: { probes in
                        let containsA = points.contains(probes.a)
                        let containsB = points.contains(probes.b)
                        let containsC = points.contains(probes.c)

                        if !containsA && !containsB {
                            // outer corner
                            return true
                        } else if containsA && containsB && !containsC {
                            // inner corner?
                            return true
                        }

                        return false

                    })
                corners += newCorners
            }

            return corners
        }
    }


    static func parse(_ input: String) throws -> Grid<Character> {
        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines).lines
        let rows = lines.map {
            Array(String($0))
        }
        let grid: Grid<Character> = Grid(data: rows)
        return grid
    }

    static func part1(_ input: String) throws -> String {
        let grid = try parse(input)

        let regions = grid.regions()
        let total = regions.reduce(0) { price, region in
            let regionPrice = (region.area * region.perimeter)
            print("Region with \(region.character) plants with price \(region.area) x \(region.perimeter) = $\(regionPrice)")
            return price + regionPrice
        }

        return "\(total)"
    }

    static func part2(_ input: String) throws -> String {
        let grid = try parse(input)

        let regions = grid.regions()
        let total = regions.reduce(0) { price, region in
            let regionPrice = (region.area * region.sides)
            print("Region with \(region.character) plants with price \(region.area) x \(region.sides) = $\(regionPrice)")
            return price + regionPrice
        }

        return "\(total)"
    }
}

let input = try readInput(from: .module)
print("DAY 12 Part 1: ")
print(try Day12.part1(input))
print("---------------------")

print("DAY 12 Part 2: ")
print(try Day12.part2(input))
print("---------------------")
