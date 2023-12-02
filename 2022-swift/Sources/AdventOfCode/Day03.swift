import AOCShared
import Algorithms

struct Day03: Challenge {
    let input: String

    init(input: String) {
        self.input = input
    }

    func run() -> String {
        var output = ""
        output += part1() + "\n"
        output += part2() + "\n"
        return output
    }

    private func part1() -> String {
        let sum = input.split(separator: "\n")
            .map(splitLine)
            .map { [$0.0, $0.1] }
            .compactMap(findCommonItem)
            .map(priority)
            .sum()

        return "Part 1: \(sum)"
    }

    private func part2() -> String {
        let sum = input.split(separator: "\n")
            .chunks(ofCount: 3)
            .compactMap(findCommonItem)
            .map(priority)
            .sum()

        return "Part 2: \(sum)"
    }

    private func priority(for character: Character) -> Int {
        guard let asciiValue = character.asciiValue.flatMap(Int.init) else { return -1 }

        let asciiLowercaseA = 97
        let asciiUppercaseA = 65

        let anchorValue = character.isLowercase ? asciiLowercaseA : asciiUppercaseA

        let score = asciiValue - anchorValue + 1 + (character.isUppercase ? 26 : 0)

        print("char \(character) has priority \(score)")
        return score
    }

    private func findCommonItem<C: Collection>(in strings: C)
    -> Character? where C.Element: StringProtocol {
        precondition(strings.count >= 1)

        let sets = strings.map(Set.init)
        var common = sets.first!
        for next in sets.dropFirst() {
            common = common.intersection(next)
        }

        return common.first
    }

    // private func findCommonItem(in compartments: (String, String)) -> Character? {
    //     let first = Set(compartments.0)
    //     let second = Set(compartments.1)
    //     print(compartments)
    //     print("FIRST: \(first)")
    //     print("SECOND: \(second)")

    //     for char in first {
    //         if second.contains(char) {
    //             return char
    //         }
    //     }

    //     return nil
    // }

    private func splitLine<S: StringProtocol>(_ line: S) -> (String, String) {
        let mid = line.index(line.startIndex, offsetBy: line.count/2)
        return (
            String(line[..<mid]),
            String(line[mid...])
        )
    }
}
