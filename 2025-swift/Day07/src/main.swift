import AOCHelper

let input = readInput(from: .module)

func runPart1() throws {
    print("----- DAY 07 PART 1 -----")
    try print(Part1.process(input))
}

func runPart2() throws {
    print("----- DAY 07 PART 2 -----")
    try print(Part2.process(input))
}


try withBenchmark {
    try runPart1()
}

try withBenchmark {
    try runPart2()
}
