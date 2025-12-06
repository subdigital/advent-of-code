import Testing
@testable import Day05

@Test
func sampleTest() throws {
    let input = """
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    """

    let answer = try Part1.process(input)
    #expect(answer == "3")
}

@Test
func sampleTestPart2() throws {
    let input = """
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    """

    let answer = try Part2.process(input)
    #expect(answer == "14")
}
