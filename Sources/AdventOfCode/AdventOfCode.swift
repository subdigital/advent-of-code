import ArgumentParser
import AOCShared
import Foundation

protocol Challenge {
    init(input: String)
    func run() -> String
}

struct NoChallenge: Error {
    let day: Int
}

@main
struct CLI: ParsableCommand {
    @Argument
    var day: Int

    @Option(name: .shortAndLong, help: "The input file to use. If not passed, the filename will be inferred from the day number (example: day02.txt)")
    var file: String? = nil

    func run() throws {
        print("Running day: \(day)")

        let actualFile = file ?? String(format: "data/day%02d.txt", day)
        print("Reading file: \(actualFile)")

        let input = readFile(actualFile)

        guard let challenge = challenge(for: day, input: input) else {
            throw NoChallenge(day: day)
        }
    
        let output = challenge.run()
        print(output)
    }
}

func challenge(for day: Int, input: String) -> Challenge? {
    switch day {
    case 1: return Day01(input: input)
    case 2: return Day02(input: input)
    case 3: return Day03(input: input)
    case 4: return Day04(input: input)
    case 5: return Day05(input: input)
    case 6: return Day06(input: input)
    case 7: return Day07(input: input)
    case 8: return Day08(input: input)
    case 9: return Day09(input: input)
    case 10: return Day10(input: input)
    case 11: return Day11(input: input)
    case 12: return Day12(input: input)
    default:
        return nil
    }
}
