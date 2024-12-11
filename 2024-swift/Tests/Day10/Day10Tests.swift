import Testing
import AOCHelper
@testable import Day10

@Test(
    "Part 1 examples", arguments: [
        ("""
        0123
        1234
        8765
        9876
        """, 1),

        ("""
        ...0...
        ...1...
        ...2...
        6543456
        7.....7
        8.....8
        9.....9
        """, 2),

        ("""
        ..90..9
        ...1.98
        ...2..7
        6543456
        765.987
        876....
        987....
        """, 4),

        ("""
        89010123
        78121874
        87430965
        96549874
        45678903
        32019012
        01329801
        10456732
        """, 36)
    ]
)
func part1Examples(args: (input: String, expectedCount: Int)) async throws {
    let result = try await Day10.part1(args.input)
    #expect(result == "\(args.expectedCount)")
}

@Test
func neighbors() {
    let input = """
    ..90..9
    ...1.98
    ...2..7
    6543456
    765.987
    876....
    987....
    """
    let grid = Day10.parse(input)
    let neighbors = grid.neighbors(for: Point(3, 3))
    #expect(4 == neighbors.count)

    let validNeighbors = neighbors.filter { grid[$0] == 3 + 1 }
    #expect(2 == validNeighbors.count)
}
