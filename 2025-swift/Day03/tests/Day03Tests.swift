import Testing

@testable import Day03

@Test
func testParsing() throws {
    let input = """
        1234
        5678
        """
    let banks = try parse(input)
    #expect(banks.count == 2)
    #expect(banks[0].batteries == [1, 2, 3, 4])
    #expect(banks[1].batteries == [5, 6, 7, 8])
}

@Test(arguments: [
    ([1, 2], 12),
    ([1, 2, 3], 23),
    ([1, 2, 3, 5], 35),
    ([5, 2, 3, 2], 53),
    ([5, 1, 1, 1], 51),
    ([9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1], 98),
    ([8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9], 89),
    ([2,3,4,2,3,4,2,3,4,2,3,4,2,7,8], 78),
    ([8,1,8,1,8,1,9,1,1,1,1,2,1,1,1], 92)
])
func joltage(line: [Int], expected: Int) {
    let bank = Bank(batteries: line)
    #expect(bank.findLargestJoltage() == expected)
}

@Test(arguments: [
    ([9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1], 987654321111),
    ([8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9], 811111111119),
])
func joltage12(line: [Int], expected: Int) {
    let bank = Bank(batteries: line)
    #expect(bank.findLargestJoltage(max: 12) == expected)
}

@Test
func sampleTest_part1() throws {
    let sample = """
        987654321111111
        811111111111119
        234234234234278
        818181911112111
        """
    let banks = try parse(sample)
    let joltage = banks.map { $0.findLargestJoltage() }.reduce(0, +)
    #expect(joltage == 357)
}

@Test
func sampleTest_part2() throws {
    let sample = """
        987654321111111
        811111111111119
        234234234234278
        818181911112111
        """
    let banks = try parse(sample)
    let joltage = banks.map { $0.findLargestJoltage() }.reduce(0, +)
    #expect(joltage == 357)
}
