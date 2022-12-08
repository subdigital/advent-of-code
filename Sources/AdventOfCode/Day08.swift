
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

        func isVisible(_ x: Int, _ y: Int) -> Bool {
            // edge nodes are visible
            if x == 0 || y == 0 || x == width - 1 || y == height - 1 {
                return true
            }

            let h = data[y][x]
            let column = column(x)
            let row = data[y]
            print("\(y),\(x) (\(h)) ? ", terminator: " ")

            // look up
            if column[..<y].reversed().allSatisfy({ $0 < h }) {
                print("visible by looking up")
                return true
            }

            // look down
            if column[(y+1)...].allSatisfy({ $0 < h}) {
                print("visible by looking down")
                return true
            }

            // look left
            if row[..<x].reversed().allSatisfy({ $0 < h }) {
                print("visible by looking left")
                return true
            }

            // look right
            let foo = row[(x+1)...]
            print("  items to the right are \(foo)]", terminator: " ")
            if row[(x+1)...].allSatisfy({ $0 < h}) {
                print("visible by looking right")
                return true
            }

            print("Not visible")

            return false
        }
    }

    func run() -> String {
        let grid = Grid.parse(input)
        print(grid)

        var output = ""
        output.append("Part 1: \(part1(grid))")

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

    private func part2() -> String {
        ""
    }
}
