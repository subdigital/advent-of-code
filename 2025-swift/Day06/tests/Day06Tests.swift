import Testing
@testable import Day06

@Test
func sampleTest() throws {
    let sample = """
    123 328  51 64
     45 64  387 23
      6 98  215 314
    *   +   *   +
    """

    let result = try Part1.process(sample)
    #expect(result == "4277556")
}

@Test
func sampleTestPart2() throws {
    // N.B. there is significant trailing whitespace here
    let sample = """
    123 328  51 64 
     45 64  387 23 
      6 98  215 314
    *   +   *   +  
    """

    let result = try Part2.process(sample)
    #expect(result == "3263827")
}
