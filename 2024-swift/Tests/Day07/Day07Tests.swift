import Testing
@testable import Day07

struct Day07Tests {
    let input = """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    
    """

    @Test
    func part1() throws {
        let result = try Day07.part1(input)
        #expect(result == "3749")
    }

    @Test
    func part2() async throws {
        let result = try await Day07.part2(input)
        #expect(result == "11387")
    }

    @Test
    func addMulConcat() {
        let line = (40914726, [3, 5, 263, 9, 4, 1, 1, 5, 5, 8, 54, 6])
        let result = Day07.testLineAddMulConcat(result: line.0, operands: line.1)
        #expect(result == true)

        let line2 = (123, [12, 3, 45, 17])
        let result2 = Day07.testLineAddMulConcat(result: line2.0, operands: line2.1)
        #expect(result2 == false)
    }
}
