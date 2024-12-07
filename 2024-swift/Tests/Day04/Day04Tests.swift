import Testing
@testable import Day04

struct Day04Tests {
    @Test
    func sample() async throws {
        let input = """
        MMMSXXMASM
        MSAMXMSMSA
        AMXSXMAAMM
        MSAMASMSMX
        XMASAMXAMM
        XXAMMXXAMA
        SMSMSASXSS
        SAXAMASAAA
        MAMMMXMMMM
        MXMXAXMASX
        """

        let output = Day04.part1(input)
        #expect(output == "18")
    }

    @Test
    func samplePart2() {
        let input = """
        .M.S......
        ..A..MSMS.
        .M.S.MAA..
        ..A.ASMSM.
        .M.S.M....
        ..........
        S.S.S.S.S.
        .A.A.A.A..
        M.M.M.M.M.
        ..........
        """

        let output = Day04.part2(input)
        #expect(output == "9")
    }
}
