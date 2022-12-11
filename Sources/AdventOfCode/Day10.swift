import AOCShared
import Foundation

struct Day10: Challenge {
    let input: String
    
    func run() -> String {
        var output = ""
        let instructions = input.lines().map(Instruction.parse)
        // output.append("Part 1: \(part1(instructions))")
        output.append("Part 2: \(part2(instructions))")

        return output
    }

    enum Instruction {
        case noop
        case addx(Int)

        var cycleTime: Int {
            switch self {
            case .noop: return 1
            case .addx: return 2
            }
        }

        static func parse(_ str: some StringProtocol) -> Instruction {
            if str == "noop" {
                return .noop
            }

            let parts = str.split(separator: " ", maxSplits: 1)
            assert(parts.count == 2)

            switch parts[0] {
            case "addx":
                return .addx(Int(parts[1])!)
            default:
                fatalError("Unhandled instruction: \(str)")
            }
        }
    }

    struct Register {
        var value: Int
    }

    struct Clock {
        var cycle = 0
    }

    struct CPU {
        var clock = Clock()
        var xRegister = Register(value: 1)

        mutating func process(_ instruction: Instruction) {
            switch instruction {
            case .noop: return
            case .addx(let value): xRegister.value += value
            }
        }
    }

    struct Display {
        let width = 40
        let height = 6
        var col = 0
        var row = 0

        mutating func draw(cpu: inout CPU, refresh: Bool = true) {
            // is sprite visible?

            //x 1
            //0 = #
            //1 = #
            //2 = #

            let isLit = abs(col - cpu.xRegister.value) < 2
            print(isLit ? "#" : ".", terminator: "")

            col += 1

            if col == width {
                print("")
                fflush(stdout)
                row += 1
                col = 0

                if row == height {
                    if refresh {
                        moveCursorUp(n: height)
                    }
                    row = 0
                }
            }
        }
    }

    func part1(_ instructions: [Instruction]) -> String {
        var instructions = instructions
        var cpu = CPU()

        var instr = instructions.removeFirst()
        var cyclesLeft = instr.cycleTime

        var nextCycle = 20
        var value = 0

        repeat {
            // print("INSTR => ", instr)

            cyclesLeft -= 1
            cpu.clock.cycle += 1

            if cpu.clock.cycle == nextCycle {
                dump(cpu)
                nextCycle += 40
                value += cpu.clock.cycle * cpu.xRegister.value
            }

            if cyclesLeft == 0 {
                cpu.process(instr)
                instr = instructions.removeFirst()
                cyclesLeft = instr.cycleTime
            }
        } while !instructions.isEmpty

        return "Answer is \(value)"
    }

    func part2(_ instructions: [Instruction]) -> String {
        var instructions = instructions
        var cpu = CPU()
        var display = Display()

        var instr = instructions.removeFirst()
        var cyclesLeft = instr.cycleTime

        setbuf(stdout, nil)
        repeat {
            cyclesLeft -= 1
            cpu.clock.cycle += 1

            display.draw(cpu: &cpu)

            Thread.sleep(forTimeInterval: 0.005)

            if cyclesLeft == 0 {
                cpu.process(instr)
                instr = instructions.removeFirst()
                cyclesLeft = instr.cycleTime
            }
        } while !instructions.isEmpty

        display.draw(cpu: &cpu, refresh: false)

        print("")

        return ""
    }
}
