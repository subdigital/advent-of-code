import AOCHelper

let input = readInput(from: .module)

func runPart1() throws {
    print("----- DAY {{day}} PART 1 -----")
    try print(Part1.process(input))
}

func runPart2() throws {
    print("----- DAY {{day}} PART 2 -----")
    try print(Part2.process(input))
}

try runPart1()

// runPart2()
