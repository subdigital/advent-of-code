import AOCHelper

let input = readInput(from: .module)

func runPart1() {
    let sampleInput = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224," +
                "1698522-1698528,446443-446449,38593856-38593862,565653-565659," +
                "824824821-824824827,2121212118-2121212124"

    print("----- Sample -----")
    print(Part1.process(sampleInput))
    print()

    print("----- PART 1 -----")
    print(Part1.process(input))
}

func runPart2() {
    let sampleInput = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224," +
                "1698522-1698528,446443-446449,38593856-38593862,565653-565659," +
                "824824821-824824827,2121212118-2121212124"

    print("----- Sample -----")
    print(Part2.process(sampleInput))
    print()

    print("----- PART 2 -----")
    print(Part2.process(input))
}

// runPart1()


runPart2()
