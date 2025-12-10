import AOCHelper
import Foundation
import Parsing

extension TachyonManifold {
    func quantumTimelines(memo: inout [Vec2: Int], pos: Vec2) -> Int {
        if pos.x < 0 || pos.x >= grid.cols {
            return 0 // invalid
        }

        // early out if we've traveled here before
        if let timelines = memo[pos] {
            return timelines
        }

        // are we at the end?
        if pos.y == grid.rows - 1 {
            return 1
        }

        // is this a splitter?
        if grid[pos] == .splitter {
            // check left & right
            let left = quantumTimelines(memo: &memo, pos: pos + .left)
            let right = quantumTimelines(memo: &memo, pos: pos + .right)
            let total = left + right
            memo[pos] = total
            return total
        }

        // check down (until the end or a splitter)
        var next = pos
        while next.y < grid.rows - 1, grid[next] != .splitter {
            next = next + .down
        }

        // found a splitter
        return quantumTimelines(memo: &memo, pos: next)
    }

    func quantumTimelines() -> Int {
        var traveled: [Vec2: Int] = [:]
        let startX = grid[y].firstIndex(where: { $0 == .source })!
        return quantumTimelines(memo: &traveled, pos: Vec2(startX, 0))
    }
}

enum Part2 {
    static func process(_ input: String) throws -> String {
        let manifold = try TachyonManifold.parse(input: input)
        return "\(manifold.quantumTimelines())"

    }
}
