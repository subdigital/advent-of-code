import Collections
import AOCShared

struct Day12: Challenge {
    let input: String

    func run() -> String {
        var output = ""

        let terrain = Grid.parse(input)
        print(terrain)
        output.append("Part 1: \(part1(terrain: terrain))")
        // output.append("Part 2: \(part2(group))")

        return output
    }
    func part1(terrain: Grid) -> String {
        var pathFinder = PathFinder(terrain: terrain)
        dump(pathFinder)

        let path = pathFinder.shortestPath()
        for segment in zip(path, path.dropFirst()) {
            let dx = segment.1.x - segment.0.x
            let dy = segment.1.y - segment.0.y
            if dx > 0 {
                print(">")
            } else if dx < 0 {
                print("<")
            } else if dy > 0 {
                print("v")
            } else if dy < 0 {
                print("^")
            } else {
                fatalError()
            }
        }

        return ""
    }
    func part2() -> String {
        ""
    }
    struct Node: Hashable, CustomStringConvertible, CustomDebugStringConvertible {
        let x: Int
        let y: Int

        init(_ pos: (Int, Int)) {
            self.x = pos.0
            self.y = pos.1
        }
        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }

        var pos: (Int, Int) {
            (x, y)
        }
        var description: String {
            "(x:\(x),y:\(y))"
        }
        var debugDescription: String {
            description
        }
    }
    struct Pair<A: Hashable, B: Hashable>: Hashable {
        let a: A
        let b: B
    }
    struct Path: Hashable, Comparable {
        static func < (lhs: Day12.Path, rhs: Day12.Path) -> Bool {
            lhs.cost < rhs.cost
        }
        let a: Node
        let b: Node
        let cost: Int
    }
    struct PathFinder {
        let terrain: Grid

        var start: (Int, Int)
        var destination: (Int, Int)
        var current: (Int, Int)

        init(terrain: Grid) {
            self.terrain = terrain
            self.start = terrain.find("S")!
            self.destination = terrain.find("E")!
            self.current = start
        }

        func shortestPath() -> [Node] {
            var paths: [Node: Int] = [:]
            var pq = PriorityQueue<Path>()
            var visited: Set<Node> = []
            var prev: [Node: Node] = [:]

            var node = Node(start)
            paths[node] = 0
            while true {
                visited.insert(node)
                let neighbors = terrain.neighbors(node.pos)
                for n in neighbors {
                    let b = Node(n.pos)
                    if visited.contains(b) {
                        continue
                    }

                    var cost = paths[node].flatMap { $0 + n.cost } ?? .max
                    if cost > 1 {
                        // untraversible
                        cost = .max
                    }
                    if cost < paths[b, default: .max] {
                        paths[b] = cost
                        prev[b] = node
                    }
                    pq.enqueue(element: .init(a: node, b: b, cost: cost))
                }

                // choose the next cheapest neighbor to move to
                guard let next = pq.dequeue()?.b else { break }
                node = next
            }

            print("Path table:", paths)
            var path: [Node] = []
            var current = Node(destination)
            while current != Node(start) {
                path.append(current)
                current = prev[current]!
            }

            return path.reversed()
        }
    }

    struct Grid: CustomStringConvertible {
        private let data: [Character]
        let height: Int
        let width: Int 

        init(data: [Character], width: Int, height: Int) {
            assert(data.count == width * height)

            self.data = data
            self.width = width
            self.height = height
        }

        func find(_ char: Character) -> (Int, Int)? {
            guard let index = data.firstIndex(of: char) else { return nil }
            return indexToPos(index)
        }

        func neighbors(_ pos: (x: Int, y: Int)) -> [(pos: (x: Int, y: Int), cost: Int)] {
            let cur = self[pos]!
            let curCost = cost(cur)

            let up =    (x: pos.x,   y: pos.y-1)
            let down =  (x: pos.x,   y: pos.y+1)
            let left =  (x: pos.x-1, y: pos.y)
            let right = (x: pos.x+1, y: pos.y)

            return [ up, down, left, right ].compactMap { pos in
                guard let char = self[pos] else { return nil }
                let cost = self.cost(char) - curCost
                return (pos, Int(cost))
            }
        }

        func cost(_ character: Character) -> Int {
            func charCost(_ char: Character) -> Int {
                Int(char.asciiValue!) - 97 // ascii "a" is the smallest
            }
            switch character {
            case "S": return charCost("a")
            case "E": return charCost("z")
            case "a"..."z": return charCost(character)
            default: fatalError("Non-ascii character?")
            }
        }

        subscript(_ pos: (Int, Int)) -> Character? {
            guard
                pos.0 >= 0 && pos.0 < width && pos.1 >= 0 && pos.1 < height,
                let index = posToIndex(pos)
            else {
                return nil
            }

            return data[index]
        }

        private func posToIndex(_ pos: (x: Int, y: Int)) -> Int? {
            let index = pos.y * width + pos.x
            if index < 0 || index >= data.count {
                return nil
            }
            return index
        }

        private func indexToPos(_ index: Int) -> (Int, Int) {
            let y = index / width
            let x = (index % width)
            return (x, y)
        }

        static func parse(_ input: String) -> Self {
            let lines = input.lines()

            let values = lines
                .flatMap { line in
                    Array(line)
                }

            return Grid(data: values, width: values.count/lines.count, height: lines.count)
        }

        var description: String {
            var output = ""
            for (index, char) in data.enumerated() {
                output.append("\(char)")
                if (index + 1) % width == 0 {
                    output.append("\n")
                }
            }
            return output
        }

        // func column(_ c: Int) -> [Int] {
        //     assert(c >= 0 && c < width)
        //     return transposed[c]
        // }
    }
}
