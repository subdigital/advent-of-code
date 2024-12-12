import Testing
@testable import Day11

@Test func parseInput() throws {
    let nums = try Day11.parse("0 1 10 99 999")
    #expect(nums == [0, 1, 10, 99, 999])
}

@Test func blink1() throws {
    let nums = try Day11.parse("0 1 10 99 999")
    var sim = Day11.Simulation(nums: nums)
    sim.blink()
    #expect(sim.nums == [1, 2024, 1, 0, 9, 9, 2021976])
}

@Test func blinkMany() throws {
    let nums = [125, 17]
    var sim = Day11.Simulation(nums: nums)

    sim.blink()
    #expect(try sim.nums == Day11.parse("253000 1 7"))

    sim.blink()
    #expect(try sim.nums == Day11.parse("253 0 2024 14168"))

    sim.blink()
    #expect(try sim.nums == Day11.parse("512072 1 20 24 28676032"))

    sim.blink()
    #expect(try sim.nums == Day11.parse("512 72 2024 2 0 2 4 2867 6032"))

    sim.blink()
    #expect(try sim.nums == Day11.parse("1036288 7 2 20 24 4048 1 4048 8096 28 67 60 32"))

    sim.blink()
    #expect(try sim.nums == Day11.parse("2097446912 14168 4048 2 0 2 4 40 48 2024 40 48 80 96 2 8 6 7 6 0 3 2"))

    // 19 more
    for _ in 0...18 {
        sim.blink()
    }
    #expect(sim.nums.count == 55312)
}

@Test func blink1Num() async throws {
    var sim = Day11.Simulation(nums: [0])

    sim.blink()
    #expect(sim.nums == [1])
    sim.blink()

    #expect(sim.nums == [2024])
    sim.blink()

    #expect(sim.nums == [20, 24])
    sim.blink()

    #expect(sim.nums == [2, 0, 2, 4])
    sim.blink()

    #expect(sim.nums == [4048, 1, 4048, 8096])
}

@Test func blink5Times() async throws {
    var sim = Day11.Simulation(nums: [0])

    sim.blink(5)
    #expect(sim.nums == [4048, 1, 4048, 8096])
}
