import Testing
@testable import Day09

@Test
func day9parseEntries() {
    let input = "12345"
    let entries: [Day09.Entry] = [
        .file(id: 0, length: 1),
        .free(length: 2),
        .file(id: 1, length: 3),
        .free(length: 4),
        .file(id: 2, length: 5)
    ]
    #expect(Day09.parse(input) == entries)
}

@Test
func day9degfragCreatesLayout() {
    let entries: [Day09.Entry] = [
        .file(id: 0, length: 1),
        .free(length: 2),
        .file(id: 1, length: 3),
        .free(length: 4),
        .file(id: 2, length: 5)
    ]
    let defrag = Day09.BlockDefragmenter(entries: entries)
    let layout = defrag.layout.layoutString
    #expect(layout == "0..111....22222")
}

@Test
func day9defragStep() {
    let entries: [Day09.Entry] = [
        .file(id: 0, length: 1),
        .free(length: 2),
        .file(id: 1, length: 3),
        .free(length: 4),
        .file(id: 2, length: 5)
    ]
    var defrag = Day09.BlockDefragmenter(entries: entries)
    defrag.step()
    var layout = defrag.layout.layoutString
    #expect(layout == "02.111....2222.")

    defrag.step()
    layout = defrag.layout.layoutString
    #expect(layout == "022111....222..")

    defrag.step()
    layout = defrag.layout.layoutString
    #expect(layout == "0221112...22...")
}

@Test
func day9defragRun() {
    let entries: [Day09.Entry] = [
        .file(id: 0, length: 1),
        .free(length: 2),
        .file(id: 1, length: 3),
        .free(length: 4),
        .file(id: 2, length: 5)
    ]
    var defrag = Day09.BlockDefragmenter(entries: entries)
    defrag.run()
    let layout = defrag.layout.layoutString
    #expect(layout == "022111222......")
}

@Test
func day9part1ExampleDefrag() {
    let input = "2333133121414131402"
    let entries = Day09.parse(input)
    var defrag = Day09.BlockDefragmenter(entries: entries)

    var expectedSteps = """
    009..111...2...333.44.5555.6666.777.88889.
    0099.111...2...333.44.5555.6666.777.8888..
    00998111...2...333.44.5555.6666.777.888...
    009981118..2...333.44.5555.6666.777.88....
    0099811188.2...333.44.5555.6666.777.8.....
    009981118882...333.44.5555.6666.777.......
    0099811188827..333.44.5555.6666.77........
    00998111888277.333.44.5555.6666.7.........
    009981118882777333.44.5555.6666...........
    009981118882777333644.5555.666............
    00998111888277733364465555.66.............
    0099811188827773336446555566..............
    """.split(separator: "\n")

    while expectedSteps.isEmpty == false {
        let expected = expectedSteps.removeFirst()
        _ = defrag.step()

        let layout = defrag.layout.layoutString
        #expect(layout == expected)
    }
}

@Test
func day9part1ExampleChecksum() {
    let input = "2333133121414131402"
    let entries = Day09.parse(input)
    var defrag = Day09.BlockDefragmenter(entries: entries)
    defrag.run()

    #expect(defrag.layout.checksum() == 1928)
}

@Test
func day9Part2ExampleSteps() {
    let input = "2333133121414131402"
    let entries = Day09.parse(input)
    var defrag = Day09.FileDefragmenter(entries: entries)

    var expectedSteps = """
    0099.111...2...333.44.5555.6666.777.8888..
    0099.1117772...333.44.5555.6666.....8888..
    0099.111777244.333....5555.6666.....8888..
    00992111777.44.333....5555.6666.....8888..
    """.split(separator: "\n")

    while expectedSteps.isEmpty == false {
        let expected = expectedSteps.removeFirst()
        _ = defrag.step()

        let layout = defrag.layout().layoutString
        #expect(layout == expected)
    }

}
