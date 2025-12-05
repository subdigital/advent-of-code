import AOCHelper
import Foundation
import Parsing

enum Part2 {
    static func process(_ input: String) throws -> String {
        var grid = try parse(input)
        let total = grid.reduce(0) { (count, cell) in
            return count + grid.removeIfPossible(cell.1.x, cell.1.y)
        }
        return "\(total)"
    }
}
