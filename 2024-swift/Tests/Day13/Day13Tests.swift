import AOCHelper
import Foundation
import Parsing
import Testing
@testable import Day13

@Test
func parseClawMachines() throws {
    let input = """
    Button A: X+51, Y+11
    Button B: X+38, Y+78
    Prize: X=16146, Y=3706

    Button A: X+49, Y+16
    Button B: X+27, Y+68
    Prize: X=273, Y=5932
    """

    let machines = try Day13.parse(input)

    #expect(machines.count == 2)
    #expect(machines[0].a == Point(51, 11))
    #expect(machines[0].b == Point(38, 78))
    #expect(machines[0].prize == Point(16146, 3706))

    #expect(machines[1].a == Point(49, 16))
    #expect(machines[1].b == Point(27, 68))
    #expect(machines[1].prize == Point(273, 5932))
}

@Test
func part1Example1() throws {
    let input = """
    Button A: X+94, Y+34
    Button B: X+22, Y+67
    Prize: X=8400, Y=5400
    """
    let machine = try Day13.ClawMachine.parser().parse(input)
    let solution = try #require(machine.solve())
    #expect(solution.a == 80)
    #expect(solution.b == 40)
}

@Test
func part1Example2() throws {
    let input = """
    Button A: X+26, Y+66
    Button B: X+67, Y+21
    Prize: X=12748, Y=12176
    """
    let machine = try Day13.ClawMachine.parser().parse(input)
    #expect(machine.solve() == nil)
}

@Test
func part1Example3() throws {
    let input = """
    Button A: X+17, Y+86
    Button B: X+84, Y+37
    Prize: X=7870, Y=6450
    """
    let machine = try Day13.ClawMachine.parser().parse(input)
    let solution = try #require(machine.solve())
    #expect(solution.a == 38)
    #expect(solution.b == 86)
}

@Test
func part1Example() throws {
    let input = """
    Button A: X+94, Y+34
    Button B: X+22, Y+67
    Prize: X=8400, Y=5400

    Button A: X+26, Y+66
    Button B: X+67, Y+21
    Prize: X=12748, Y=12176

    Button A: X+17, Y+86
    Button B: X+84, Y+37
    Prize: X=7870, Y=6450

    Button A: X+69, Y+23
    Button B: X+27, Y+71
    Prize: X=18641, Y=10279
    """
    let result = try Day13.part1(input)
    #expect(result == "480")
}
