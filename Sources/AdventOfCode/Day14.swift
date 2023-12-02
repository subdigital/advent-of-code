import AOCShared
import Algorithms
import Foundation

struct Day14: Challenge {
    let input: String

    struct Coord: Equatable, CustomStringConvertible {
        var x: Int
        var y: Int

        static func parse(_ input: some StringProtocol) -> Self {
            let parts = input.split(separator: ",")
                .map { Int($0)! }
            return Coord(x: parts[0], y: parts[1])
        }

        var description: String {
            "\(x),\(y)"
        }

    }

    struct Line: Equatable, CustomStringConvertible {
        let start: Coord
        let end: Coord

        static func parse(_ input: some StringProtocol) -> [Line] {
            input.split(separator: " -> ")
                .windows(ofCount: 2)
                .map { pair in
                    Line(
                        start: Coord.parse(pair.first!),
                        end: Coord.parse(pair.last!)
                    )
                }
        }

        var description: String {
            "\(start) -> \(end)"
        }

        var minX: Int {
            [start.x, end.x].min()!
        }

        var minY: Int {
            [start.y, end.y].min()!
        }

        var maxX: Int {
            [start.x, end.x].max()!
        }

        var maxY: Int {
            [start.y, end.y].max()!
        }

        var pixels: [Coord] {
            if start.x == end.x {
                // vertical line
                return (minY...maxY).map { y in
                    Coord(x: start.x, y: y)
                }
            } else if start.y == end.y {
                // horizontal line
                return (minX...maxX).map { x in
                    Coord(x: x, y: start.y)
                }
            } else {
                fatalError("Can't handle diagonals yet")
            }
        }
    }

    func run() -> String {
        var output = ""

        // output.append("Part1: \(part1())\n\n")
        output.append("Part2: \(part2())\\n\n")

        return output
    }

    private func part1() -> String {
        print("Running part 1.....")
        let lines = input.lines()
            .flatMap {
                Line.parse($0)
            }

        let sandX = 500
        let gridMinX = (lines.map(\.minX) + [sandX]).min()!
        let gridMaxX = (lines.map(\.maxX) + [sandX]).max()!
        let gridWidth = gridMaxX - gridMinX + 1
        let gridHeight = lines.map(\.maxY).max()! + 1

        print("Grid minx: \(gridMinX)  maxx: \(gridMaxX), maxy: \(gridHeight)")

        var grid = Grid(
            data: Array(repeating: ".", count: gridWidth * gridHeight),
            width: gridWidth,
            height: gridHeight
        )
        grid.origin = (gridMinX, 0)
        grid.showAxes = true

        for line in lines {
            print(line)
            grid.addLine(line)
        }

        // mark sand spawner
        grid.replace(char: "+", at: (500, 0))

        var steps = 0
//        var renderHeight = grid.height + 4
        while step(&grid, spawnPos: .init(x: 500, y: 0)) {
            // print(grid)
            // Thread.sleep(forTimeInterval: 0.01)
            //print("Step \(steps) Press enter for next step")
            // _ = readLine()
            // moveCursorUp(n: renderHeight)
            steps += 1
        }

//        for _ in 0..<renderHeight {
//            print("")
//        }

        return "Took \(steps) units of sand"
    }

    private func part2() -> String {
        print("Running part 2.....")
        let lines = input.lines()
            .flatMap {
                Line.parse($0)
            }

        let sandX = 500
        let gridMinX = (lines.map(\.minX) + [sandX]).min()!
        let gridMaxX = (lines.map(\.maxX) + [sandX]).max()!
        let gridWidth = gridMaxX - gridMinX + 1
        let gridHeight = lines.map(\.maxY).max()! + 1 + 2 // account for floor

        var grid = Grid(
            data: Array(repeating: ".", count: gridWidth * gridHeight),
            width: gridWidth,
            height: gridHeight
        )
        grid.origin = (gridMinX, 0)
        grid.showAxes = true

        for line in lines {
            print(line)
            grid.addLine(line)
        }

        // add floor
        grid.addLine(.init(
            start: .init(x: gridMinX, y: gridHeight-1),
            end: .init(x: gridMaxX, y: gridHeight-1)
        ))

        // mark sand spawner
        grid.replace(char: "+", at: (500, 0))

        var steps = 0
//        let renderHeight = grid.height + 4
        while step(&grid, spawnPos: .init(x: 500, y: 0), floor: true) {
//            print(grid)
            // Thread.sleep(forTimeInterval: 0.01)
            //print("Step \(steps) Press enter for next step")
            // _ = readLine()
//            moveCursorUp(n: renderHeight)
            steps += 1
        }

//        for _ in 0..<renderHeight {
//            print("")
//        }

        return "Took \(steps) units of sand"
    }

    func step(_ grid: inout Grid, spawnPos: Coord, floor: Bool = false) -> Bool {

        if grid[(spawnPos.x, spawnPos.y)] == "o" {
            // spawner is blocked, we're done
            return false
        }

        var pos = spawnPos

        // look down, are we blocked?
        while true {
            if floor {
                let numColumnsToAdd = 10
                if pos.x <= grid.origin.0 {
                    for _ in 0..<numColumnsToAdd {
                        grid.addColumnLeft(char: ".")
                        grid.replace(char: "#", at: (grid.origin.0, grid.height-1))
                    }
                } else if pos.x >= (grid.origin.0 + grid.width) - 2 {
                    for _ in 0..<numColumnsToAdd {
                        grid.addColumnRight(char: ".")
                        grid.replace(char: "#", at: (grid.origin.0 + grid.width-1, grid.height-1))
                    }
                }
            }

            let char = grid[(pos.x, pos.y+1)]

            switch char {
            case ".":
                // continue down
                pos.y += 1
            case "o", "#":
                // diagonal left?
                if grid[(pos.x-1, pos.y+1)] == "." {
                    pos.x -= 1
                    pos.y += 1
                }
                // diagonal right?
                else if grid[(pos.x+1, pos.y+1)] == "." {
                    pos.x += 1
                    pos.y += 1
                } else {
                    // blocked, stop here
                    grid.replace(char: "o", at: (pos.x, pos.y))
                    return true
                }

            case nil:
                // off grid, we're done
                return false

            default:
                fatalError("not handling char: \(String(describing: char))")
            }
        }
    }
}

extension Grid {
    mutating func addLine(_ line: Day14.Line) {
        for pixel in line.pixels {
            replace(char: "#", at: (pixel.x, pixel.y))
        }
    }
}
