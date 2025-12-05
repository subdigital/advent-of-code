import Testing
@testable import Day04

@Test
func sampleTest() throws {
    let input = """
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    """

    let grid = try parse(input)
    grid.printGrid()

    #expect(grid.width == 10)
    #expect(grid.height == 10)

    // let coord = Coordinate(2, 0)
    #expect(grid.neighborCount(2, 0) == 3)
    #expect(grid.neighborCount(3, 0) == 3)
    #expect(grid.neighborCount(5, 0) == 3)
    #expect(grid.neighborCount(0, 9) == 1)

    let answer = try Part1.process(input)
    #expect(answer == "13")
}

@Test
func part2SampleTest() throws {
    let input = """
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    """

    let grid = try parse(input)
    grid.printGrid()

    let answer = try Part2.process(input)
    #expect(answer == "43")
}
