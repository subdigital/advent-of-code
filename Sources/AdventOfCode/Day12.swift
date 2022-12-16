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
        let pathFinder = PathFinder(terrain: terrain)
        let start = terrain.find("S")!
        let end = terrain.find("E")!

        let path = pathFinder.shortestPath(from: start, to: end)
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
        func direction(to other: Node) -> Character {
            let dx = other.x - x
            let dy = other.y - y
            if dx > 0 {
                return ">"
            } else if dx < 0 {
                return "<"
            } else if dy > 0 {
                return "v"
            } else if dy < 0 {
                return "^"
            } else {
                return "x"
            }
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


        init(terrain: Grid) {
            self.terrain = terrain
        }

        func shortestPath(from: (Int, Int), to: (Int, Int)) -> [Node] {
            shortestPath(from: from, stop: { $0 == to })
        }

        func shortestPath(from: (Int, Int), stop: ((Int, Int)) -> Bool) -> [Node] {
            var dist: [Node: Int] = [:]
            let startNode = Node(from)
            let destNode = Node(to)

            // best distance to get to this node
            var bestPaths: [Node: (Node, Int)] = [:]

            var pq = PriorityQueue<Path>()

            var visited: Set<Node> = []

            // seed algorith with start node values
            dist[startNode] = 0
            pq.enqueue(element: .init(a: startNode, b: startNode, cost: 0))

            while let nextMinPath = pq.dequeue() {
                let node = nextMinPath.b
                print("visiting node \(node), cost is \(nextMinPath.cost)")

                if nextMinPath.cost > dist[node, default: .max] {
                    // we've already found a better path, skip it
                    print("we already have a better cost to this node \(dist[node]!)")
                    continue
                }
                visited.insert(node)
                for n in terrain.neighbors(node.pos) {
                    let neighborNode = Node(n.pos)
                    guard !visited.contains(neighborNode) else { continue }
                    print("\t neighbor (\(n.pos)) -> \(n.cost) ")

                    if n.cost > 1 {
                        print("\t unreachable...")
                        continue
                    }
                    let costFromStart = n.cost + nextMinPath.cost + 1
                    print("\t\t fromStart \(costFromStart)")
                    if costFromStart < dist[neighborNode, default: .max] {
                        print("\t\t this is better, saving in the pq")
                        dist[neighborNode] = costFromStart
                        pq.enqueue(element: .init(a: startNode, b: neighborNode, cost: costFromStart))
                    }
                    if bestPaths[neighborNode]?.1 ?? .max > costFromStart {
                        // insert/replace this one as the best path to this neighbor node, from node
                        print("\t\t best path so far to this node is via \(node)")
                        bestPaths[neighborNode] = (node, costFromStart)
                    }
                }
            }

            var pathMap = Grid(data: .init(repeating: ".", count: terrain.width * terrain.height), width: terrain.width, height: terrain.height)
            pathMap.replace(char: "E", at: destination)

            var path: [Node] = []
            var current = destNode
            while current != startNode {
                path.append(current)
                let (pathVia, _) = bestPaths[current]!
                pathMap.replace(char: pathVia.direction(to: current), at: pathVia.pos)
                current = pathVia
            }
            print(pathMap)
            print("Number of steps: \(path.count)")
            return path.reversed()
        }
    }

    struct Grid: CustomStringConvertible {
        private var data: [Character]
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

        mutating func replace(char: Character, at pos: (Int, Int)) {
            guard let index = posToIndex(pos) else { return }
            data[index] = char
        }

        func neighbors(_ pos: (x: Int, y: Int)) -> [(pos: (x: Int, y: Int), cost: Int)] {
            let cur = self[pos]!
            let curCost = cost(cur)

            let up =    (x: pos.x,   y: pos.y-1)
            let right = (x: pos.x+1, y: pos.y)
            let down =  (x: pos.x,   y: pos.y+1)
            let left =  (x: pos.x-1, y: pos.y)

            return [ up, right, down, left ].compactMap { pos in
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

        func posToIndex(_ pos: (x: Int, y: Int)) -> Int? {
            let index = pos.y * width + pos.x
            if index < 0 || index >= data.count {
                return nil
            }
            return index
        }

        func indexToPos(_ index: Int) -> (Int, Int) {
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
