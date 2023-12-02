import Collections
import AOCShared

struct Day12: Challenge {
    let input: String

    func run() -> String {
        var output = ""

        let terrain = Grid.parse(input)
        print(terrain)
        output.append("Part 1: \(part1(terrain: terrain))\n")
        output.append("Part 2: \(part2(terrain: terrain))")

        return output
    }

    func part1(terrain: Grid) -> String {
        let pathFinder = PathFinder(terrain: terrain, neighborFilter: neighborsWithMaxUpill(1))
        let start = terrain.find("S")!
        let end = terrain.find("E")!
        let path = pathFinder.shortestPath(from: start, to: end)
        return "Number of steps: \(path.count)"
    }

    func part2(terrain: Grid) -> String {
        let pathFinder = PathFinder(terrain: terrain, neighborFilter: neighborsWithMaxDownhill(-1))
        let end = terrain.find("E")!
        let path = pathFinder.shortestPath(from: end, until: { terrain[$0] == "a" })
        return "Number of steps: \(path.count)"
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
    struct Path: Hashable, Comparable {
        static func < (lhs: Day12.Path, rhs: Day12.Path) -> Bool {
            lhs.cost < rhs.cost
        }
        let a: Node
        let b: Node
        let cost: Int
    }

    struct CostResult {
        let distancesFromStartNode: [Node: Int]
        let bestPaths: [Node: Node]
        let endNode: Node
    }

    struct PathFinder {
        let terrain: Grid
        let neighborFilter: (Grid, (Int, Int), Int) -> Bool

        private func computeCosts(from: (Int, Int), until: ((Int, Int)) -> Bool) -> CostResult {
            let startNode = Node(from)

            // costs from the start node to every other node
            var dist: [Node: Int] = [:]

            // find the best path from a node to any other node (with its cost)
            var bestPaths: [Node: (Node, Int)] = [:]

            var pq = PriorityQueue<Path>()

            var visited: Set<Node> = []

            // seed algorith with start node values
            dist[startNode] = 0
            pq.enqueue(element: .init(a: startNode, b: startNode, cost: 0))

            var dest: Node?

            while let nextMinPath = pq.dequeue() {
                let node = nextMinPath.b
                print("visiting node \(node), cost is \(nextMinPath.cost) [\(terrain[node.pos]!)]")

                if nextMinPath.cost > dist[node, default: .max] {
                    // we've already found a better path, skip it
                    print("we already have a better cost to this node \(dist[node]!)")
                    continue
                }
                visited.insert(node)

                if until(node.pos) {
                    dest = node
                    break
                }

                let validNeighbors = terrain.neighbors(node.pos).filter { n in
                    neighborFilter(terrain, n.pos, n.cost)
                }

                for n in validNeighbors {
                    let neighborNode = Node(n.pos)
                    guard !visited.contains(neighborNode) else { continue }
                    print("\t neighbor (\(n.pos)) -> \(n.cost) ")
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

            guard let dest else {
                fatalError("Went through the grid but did not find a valid path to the end node!")
            }

            return .init(
                distancesFromStartNode: dist,
                bestPaths: bestPaths.mapValues { $0.0 },
                endNode: dest
            )
        }

        func shortestPath(from: (Int, Int), to: (Int, Int)) -> [Node] {
            let costs = computeCosts(from: from, until: { $0 == to })
            let bestPaths = costs.bestPaths

            var pathMap = Grid(data: .init(repeating: ".", count: terrain.width * terrain.height), width: terrain.width, height: terrain.height)
            pathMap.replace(char: "E", at: to)

            let startNode = Node(from)
            var path: [Node] = []
            var current = Node(to)
            while current != startNode {
                path.append(current)
                let pathVia = bestPaths[current]!
                pathMap.replace(char: pathVia.direction(to: current), at: pathVia.pos)
                current = pathVia
            }
            print(pathMap)
            return path.reversed()
        }

        func shortestPath(from: (Int, Int), until: ((Int, Int)) -> Bool) -> [Node] {
            let costs = computeCosts(from: from, until: until)
            let bestPaths = costs.bestPaths

            let startNode = Node(from)
            var path: [Node] = []
            var current = costs.endNode

            var pathMap = Grid(data: .init(repeating: ".", count: terrain.width * terrain.height), width: terrain.width, height: terrain.height)
            pathMap.replace(char: "E", at: from)

            while current != startNode {
                path.append(current)
                let pathVia = bestPaths[current]!
                pathMap.replace(char: pathVia.direction(to: current), at: pathVia.pos)
                current = pathVia
            }
            print(pathMap)
            return path.reversed()
        }
    }

    // MARK: - Neighbor Filters

    /// Returns a neighbor if it's at most `max` higher than the current node
    func neighborsWithMaxUpill(_ max: Int) -> (Grid, (Int, Int), Int) -> Bool {
        return { _, _, cost in
            cost <= max
        }
    }

    /// Returns a neighbor if it's not too steep down
    func neighborsWithMaxDownhill(_ max: Int) -> (Grid, (Int, Int), Int) -> Bool {
        return { _, _, cost in
            cost >= max
        }
    }

}
