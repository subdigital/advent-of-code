
struct Day08: Challenge {
    let input: String

    struct Grid: CustomStringConvertible {
        let data: [[Int]]
        private let transposed: [[Int]]
        let height: Int
        let width: Int 

        init(data: [[Int]]) {
            self.data = data
            self.transposed = data[0].indices.map { c in
                data.map { $0[c] }
            }
            width = data.first?.count ?? 0
            height = data.count
        }

        static func parse(_ input: String) -> Self {
            let values = input.lines()
                .map { line in
                    line.map { Int(String($0))! }
                }

            return Grid(data: values)
        }

        var description: String {
            var output = ""
            for line in data {
                for h in line {
                    output.append("\(h)")
                }
                output.append("\n")
            }
            return output
        }

        func column(_ c: Int) -> [Int] {
            assert(c >= 0 && c < width)
            return transposed[c]
        }

        func isEdge(_ x: Int, _ y: Int) -> Bool {
            x == 0 || y == 0 || x == width - 1 || y == height - 1
        }

        func isVisible(_ x: Int, _ y: Int) -> Bool {
            // edge nodes are visible
            if isEdge(x, y) {
                return true
            }

            let h = data[y][x]
            let column = column(x)
            let row = data[y]

            // look up
            if column[..<y].reversed().allSatisfy({ $0 < h }) {
                return true
            }

            // look down
            if column[(y+1)...].allSatisfy({ $0 < h}) {
                return true
            }

            // look left
            if row[..<x].reversed().allSatisfy({ $0 < h }) {
                return true
            }

            // look right
            if row[(x+1)...].allSatisfy({ $0 < h}) {
                return true
            }

            return false
        }

        func scenicScore(_ x: Int, _ y: Int) -> Int {
            if isEdge(x, y) {
                return 0 // edge trees have a component of zero, so we can bail early
            }

            let h = data[y][x]
            let column = column(x)
            let row = data[y]

            func visibleCount<S: Collection>(from height: Int, _ trees: S) -> Int
            where S.Element == Int, S.Index == Int
            {
                trees.enumerated().first(where: { $0.element >= h })
                  .flatMap { $0.offset + 1 }
                  ?? trees.count
            }

            // look up
            let upScore = visibleCount(from: h, column[..<y].reversed())
            let downScore = visibleCount(from: h, column[(y+1)...])
            let leftScore = visibleCount(from: h, row[..<x].reversed())
            let rightScore = visibleCount(from: h, row[(x+1)...])
            // print("U:\(upScore) * D:\(downScore) * L:\(leftScore) * R:\(rightScore)")

            return upScore * downScore * leftScore * rightScore
        }
    }

    func run() -> String {
        let grid = Grid.parse(input)
        print(grid)

        var output = ""
        output.append("Part 1: \(part1(grid))\n")
        output.append("Part 2: \(part2(grid))")

        return output
    }


    private func part1(_ grid: Grid) -> String {
        var visibleCount = 0
        for y in 0..<grid.height {
            for x in 0..<grid.width {
                if grid.isVisible(x, y) {
                    visibleCount += 1
                }
            }
        }

        return "Visible from outside: \(visibleCount)"
    }

    private func part2(_ grid: Grid) -> String {
        var maxScore = 0
        for y in 0..<grid.height {
            for x in 0..<grid.width {
                maxScore = max(maxScore, grid.scenicScore(x, y))
            }
        }

        return "Max Scenic Score is \(maxScore)"
    }
}
