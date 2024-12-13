import AOCHelper
import Testing
@testable import Day12

@Test
func part1Parse() throws {
    let input = """
    AAAA
    BBCD
    BBCC
    EEEC
    """

    let grid = try Day12.parse(input)
    #expect(grid[Point(0, 0)] == "A")
    #expect(grid[Point(3, 3)] == "C")
    #expect(grid.rows == 4)
}

@Test
func part1Example() throws {
    let input = """
    AAAA
    BBCD
    BBCC
    EEEC
    """

    let result = try Day12.part1(input)
    #expect(result == "140")
}

@Test
func detectRegionAtPoint() throws {
    let input = """
    AAAA
    BBCD
    BBCC
    EEEC
    """
    let grid = try Day12.parse(input)
    let region = grid.detectRegion(at: Point(0, 0))

    #expect(region == Day12.Region(
        character: "A", points: Set([
            Point(0, 0),
            Point(1, 0),
            Point(2, 0),
            Point(3, 0),
        ])
    ))
}

@Test
func detectAllRegions() throws {
    let input = """
    AAAA
    BBCD
    BBCC
    EEEC
    """
    let grid = try Day12.parse(input)
    let regions = grid.regions()

    #expect(regions.count == 5)
    #expect(regions[0].character == "A")
    #expect(regions[1].character == "B")
    #expect(regions[2].character == "C")
    #expect(regions[3].character == "D")
    #expect(regions[4].character == "E")
}

@Test
func largerExample() throws {
    let input = """
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """

    let result = try Day12.part1(input)
    #expect(result == "1930")
}

struct RegionTests {
    @Test
    func permiterInLine() {
        let region = Day12.Region(
            character: "A",
            points: Set([
                Point(0, 0),
                Point(1, 0),
                Point(2, 0),
                Point(3, 0),
            ])
        )

        //  ----
        // |AAAA|
        //  ----
        // perimiter: 10

        #expect(region.perimeter == 10)
    }

    @Test
    func permiterInBox() {
        let region = Day12.Region(
            character: "B",
            points: Set([
                Point(0, 1),
                Point(0, 2),
                Point(1, 1),
                Point(1, 2),
            ])
        )

        //  --
        // |BB|
        // |BB|
        //  --
        // perimiter: 8

        #expect(region.perimeter == 8)
    }
}

@Test
func detectRegionsSides() throws {
    let input = """
    AAAA
    BBCD
    BBCC
    EEEC
    """
    let grid = try Day12.parse(input)
    let regions = grid.regions()

    try #require(regions.count == 5)
    try #require(regions[0].character == "A")
    #expect(regions[0].sides == 4)

    try #require(regions[1].character == "B")
    #expect(regions[1].sides == 4)

    try #require(regions[2].character == "C")
    #expect(regions[2].sides == 8)

    try #require(regions[3].character == "D")
    #expect(regions[3].sides == 4)

    try #require(regions[4].character == "E")
    #expect(regions[4].sides == 4)
}
