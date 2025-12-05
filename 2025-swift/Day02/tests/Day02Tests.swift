import Testing
@testable import Day02

@Test(
    arguments: [
        (11...22, [11, 22]),
        (95...115, [99, 111]),
        (998...1010, [999, 1010]),
        (1188511880...1188511890, [1188511885]),
        (222220...222224, [222222]),
        (1698522...1698528, []),
        (446443...446449, [446446]),
        (38593856...38593862, [38593859]),
        (565653...565659, [565656]),
        (824824821...824824827, [824824824]),
        (2121212118...2121212124, [2121212121]),
    ]
    )
func findRepeatingRangePart2(range: ClosedRange<Int>, expected: [Int]) {
    let actual = Array(Part2.findRepeating(in: range))
    #expect(actual == expected)
}

@Test(arguments: [10101])
func testNegativeMatches(num: Int) {
    #expect(Part2.isRepeating(num) == false)
}

@Test(arguments: [111])
func testMatches(num: Int) {
    #expect(Part2.isRepeating(num) == true)
}

@Test
func testSampleInput() {
    let sampleInput = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224," +
                "1698522-1698528,446443-446449,38593856-38593862,565653-565659," +
                "824824821-824824827,2121212118-2121212124"
    #expect(Part2.process(sampleInput) == "4174379265")
}
