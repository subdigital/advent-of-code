import Testing
@testable import Day01

struct Day01Tests {
    @Test
    func part1() {
        let output = Day01.part1("""
        3   4
        4   3
        2   5
        1   3
        3   9
        3   3
        """)
        #expect(output == "11")
    }

    @Test
    func part2() {
        let output = Day01.part2("""
        3   4
        4   3
        2   5
        1   3
        3   9
        3   3
        """)
        #expect(output == "31")
    }
}
