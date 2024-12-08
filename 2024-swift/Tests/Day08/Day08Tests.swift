import Testing
@testable import Day08

struct Day08Tests {
    @Test
    func testPart1() {
        let input = """
        ............
        ........0...
        .....0......
        .......0....
        ....0.......
        ......A.....
        ............
        ............
        ........A...
        .........A..
        ............
        ............
        """

        let result = Day08.part1(input)

        #expect(result == "14")
    }

    @Test
    func testPart1Example() {
        let input = """
        ..........
        ..........
        ..........
        ....a.....
        ........a.
        .....a....
        ..........
        ......A...
        ..........
        ..........
        """

        let result = Day08.part1(input)

        #expect(result == "4")
    }

    @Test
    func part2() {
        let input = """
        T.........
        ...T......
        .T........
        ..........
        ..........
        ..........
        ..........
        ..........
        ..........
        ..........
        """

        let result = Day08.part2(input)
        #expect(result == "9")
    }

    @Test
    func part2Example() {
        let input = """
        ............
        ........0...
        .....0......
        .......0....
        ....0.......
        ......A.....
        ............
        ............
        ........A...
        .........A..
        ............
        ............
        """

        let result = Day08.part2(input)
        #expect(result == "34")
    }
}
