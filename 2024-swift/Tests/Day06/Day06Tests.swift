import Testing
@testable import Day06

struct Day06Test {
    @Test
    func part1() throws {
        let input = """
        ....#.....
        .........#
        ..........
        ..#.......
        .......#..
        ..........
        .#..^.....
        ........#.
        #.........
        ......#...
        """

        let result = Day06.part1(input)
        #expect(result == "41")
    }

    @Test
    func part2() async throws {
        let input = """
        ....#.....
        .........#
        ..........
        ..#.......
        .......#..
        ..........
        .#..^.....
        ........#.
        #.........
        ......#...
        """

        let result = await Day06.part2(input)
        #expect(result == "6")
    }
}
