import AOCHelper

let input = readInput(from: .module)

func runPart1() throws {
    print("----- DAY 03 PART 1 -----")
    print(try Part1.process(input))
}

func runPart2() throws {
    print("----- DAY 03 PART 2 -----")
    print(try Part2.process(input))
}

try runPart1()
try runPart2()
