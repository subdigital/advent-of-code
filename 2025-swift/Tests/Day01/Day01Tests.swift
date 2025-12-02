import Testing
@testable import Day01

@Test
func testRotateLeft() {
    var dial = Dial(current: 50)
    _ = dial.rotateLeft(68)
    #expect(dial.current == 82)
}

@Test
func testRotateRight() {
    var dial = Dial(current: 50)
    _ = dial.rotateRight(30)
    #expect(dial.current == 80)
}

@Test
func testParsingInput() {
    let parser = Parser(input: """
        L68
        L30
        R48
        L5
        R60
        L55
        L1
        L99
        R14
        L82
        """
    )

    let instructions = parser.parseInstructions()
    #expect(instructions[0].direction == .left)
    #expect(instructions[0].amount == 68)

    #expect(instructions[2].direction == .right)
    #expect(instructions[2].amount == 48)

    #expect(instructions[9].direction == .left)
    #expect(instructions[9].amount == 82)
}

@Test
func examplePart2() {
    let parser = Parser(input: """
        L68
        L30
        R48
        L5
        R60
        L55
        L1
        L99
        R14
        L82
        """
    )

    let instructions = parser.parseInstructions()
    let combo = calculateCombination(dial: Dial(current: 50), instructions: instructions)
    #expect(combo == 6)
}

@Test
func largeRotation() {
var dial = Dial(current: 50)
let zeroCount = dial.rotateLeft(1000)
#expect(zeroCount == 10)
#expect(dial.current == 50)
}

@Test
func largeRotationLandingOnZero() {
var dial = Dial(current: 50)
let zeroCount = dial.rotateLeft(1050)
#expect(zeroCount == 10)
#expect(dial.current == 0)
}

@Test
func testRotateDialLeftFromZero() {
    var dial = Dial(current: 10)
    let clicks = dial.rotateLeft(110)

    #expect(dial.current == 0)
    #expect(clicks == 1)
}

@Test
func testRotateDialRightFromZero() {
    var dial = Dial(current: 0)
    var clicks = dial.rotateRight(100)

    #expect(dial.current == 0)
    #expect(clicks == 1)

    dial = Dial(current: 0)
    clicks = dial.rotateRight(101)
    #expect(dial.current == 1)
    #expect(clicks == 1)
}

@Test(arguments: [
    ((90, 3), (50, -260)),
    ((90, 3), (50, -260)),
    ((20, 0), (50, -30)),
    ((90, 1), (50, -60)),
    ((90, 3), (50, -260)),
    ((80, 0), (50, 30)),
    ((10, 1), (50, 60)),
    ((10, 4), (50, 360)),
    ((90, 0), (0, -10)),
    ((0, 1), (0, -100)),
    ((10, 0), (0, 10)),
    ((0, 1), (0, 100)),
    ((82, 1), (50, -68)),
    ((52, 0), (82, -30)),
    ((0, 1), (52, 48)),
    ((95, 0), (0, -5)),
    ((55, 1), (95, 60)),
    ((0, 1), (55, -55)),
    ((99, 0), (0, -1)),
    ((0, 1), (99, -99)),
    ((14, 0), (0, 14)),
    ((32, 1), (14, -82)),
])
func testRotateDial(_ expected: (pos: Int, clickCount: Int), _ spin: (pos: Int, amount: Int)) {
    var dial = Dial(current: spin.pos)
    let clickCount = if spin.amount >= 0 {
        dial.rotateRight(spin.amount)
    } else {
        dial.rotateLeft(-spin.amount)
    }

    #expect(dial.current == expected.pos)
    #expect(clickCount == expected.clickCount)
}
