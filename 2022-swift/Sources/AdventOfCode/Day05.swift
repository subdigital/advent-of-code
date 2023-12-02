//
//  File.swift
//  
//
//  Created by Ben Scheirman on 12/6/22.
//

import AOCShared
import Foundation

struct Crane {
    var stack: [Character]
}

struct Command {
    let craneSource: Int
    let craneDestination: Int
    let count: Int
}

struct Day05: Challenge {
    let input: String

    init(input: String) {
        self.input = input
    }

    func run() -> String {
        var output = ""
        output += "Part 1: \(part1())\n"
        output += "Part 2: \(part2())\n"
        return output
    }

    private func part1() -> String {
        let parts = input.split(separator: "\n\n")
        assert(parts.count == 2)
        let startingCranes = parseArrangement(parts[0])
        let commands = parseCommands(parts[1])

        var cranes = startingCranes
//        print("STARTING")
//        cranes.prettyPrint()
        print("-------------------------------------------")
        for command in commands {
//            print("Running command: \(command)")
            cranes = run(command, on: cranes)
//            cranes.prettyPrint()
//            print("-------------------------------------------")
        }

        let tops = cranes.compactMap(\.stack.first)
        return String(tops)
    }

    private func part2() -> String {
        let parts = input.split(separator: "\n\n")
        assert(parts.count == 2)
        let startingCranes = parseArrangement(parts[0])
        let commands = parseCommands(parts[1])

        var cranes = startingCranes
        print("STARTING")
        cranes.prettyPrint()
        print("-------------------------------------------")
        for command in commands {
            print("Running command: \(command)")
            cranes = run(command, on: cranes, max: command.count)
            cranes.prettyPrint()
            print("-------------------------------------------")
        }

        let tops = cranes.compactMap(\.stack.first)
        return String(tops)
    }

    private func run(_ command: Command, on cranes: [Crane], max: Int = 1) -> [Crane] {
        var source = cranes[command.craneSource-1]
        var dest = cranes[command.craneDestination-1]

        for _ in stride(from: 0, to: command.count, by: max) {
            let slice = source.stack[0..<max]
            source.stack.removeFirst(max)
            dest.stack.insert(contentsOf: slice, at: 0)
        }

        var copy = cranes
        copy[command.craneSource-1] = source
        copy[command.craneDestination-1] = dest
        return copy
    }

    private func parseCommands<S: StringProtocol>(_ commandsInput: S) -> [Command] {
        commandsInput.lines()
            .map {
                let scanner = Scanner(string: String($0))
                scanner.charactersToBeSkipped = .letters.union(.whitespaces)

                var count: Int = 0
                var source: Int = 0
                var dest: Int = 0

                guard scanner.scanInt(&count),
                      scanner.scanInt(&source),
                      scanner.scanInt(&dest)
                else {
                    fatalError("Couldn't parse \($0) as a command")
                }

                return Command(craneSource: source, craneDestination: dest, count: count)
            }
    }

    private func parseArrangement<S: StringProtocol>(_ arrangement: S) -> [Crane] {
        let width = 3

        func parseCrate(_ scanner: Scanner) -> Character? {
            let first = scanner.scanCharacter()
            if first == " " {
                // go to next one
                for _ in 1...width {
                    _ = scanner.scanCharacter()
                }
                return nil
            } else if first == "[",
                      let char = scanner.scanCharacter() {
                _ = scanner.scanString("]")
                _ = scanner.scanString(" ") // gap is only for the in-between cranes
                return char
            } else {
                fatalError("Unexpeced input: \(scanner.string)")
            }
        }

        var cranes: [Crane] = []

        for line in arrangement.lines() {
            let scanner = Scanner(string: String(line))
            scanner.charactersToBeSkipped = .none
            var craneIndex = 0
            while true {
                if cranes.count <= craneIndex {
                    cranes.append(Crane(stack: []))
                }
                if let character = parseCrate(scanner) {
                    // push it on the stack
                    cranes[craneIndex].stack.append(character)
                }
                if scanner.isAtEnd {
                    break
                }
                craneIndex += 1
            }
        }

        return cranes
    }
}

extension Array where Element == Crane {
    func prettyPrint() {
        let maxHeight = map(\.stack.count).max() ?? 0
        for height in stride(from: maxHeight, to: 0, by: -1) {
            for crane in self {
                if crane.stack.count <= height-1 {
                    print("    ", terminator: "")
                } else {
                    let char = crane.stack[crane.stack.count-height]
                    print("[\(char)] ", terminator: "")
                }
            }
            print("")
        }
        for i in 1...count {
            print(" \(i)  ", terminator: "")
        }
        print("")
    }
}
