enum Day3 {
    static func run() {
        let lines = readFile("day3.input").lines
        let readings = lines.map(Reading.init)
        print("Have \(readings.count) readings")
        let diagnostics = Diagnostics(readings: readings)

        print("Gamma rate: \(diagnostics.gammaRate)")
        print("Epsilon rate: \(diagnostics.epsilonRate)")
        print("power consumption: \(diagnostics.powerConsumption)")
        print("O2 Generator Rating: \(diagnostics.o2GeneratorRating)")
        print("CO2 Scrubber Rating: \(diagnostics.co2ScrubberRating)")
        print("Life Support Rating: \(diagnostics.lifeSupportRating)")
    }
}

struct Reading {
    let value: UInt
    let width: Int
    let stringValue: String

    init(stringValue: String) {
        print("Reading: \(stringValue) ==> ", terminator: "")
        self.stringValue = stringValue
        value = UInt(stringValue, radix: 2)!
        print(value)
        width = stringValue.count
    }

    // returns the int value (0 or 1) of the bit at the given position
    // starting from the left. Position is zero indexed.
    func bit(at position: Int) -> UInt {
        assert(position >= 0 || position < width)
        let shiftAmount = (width - 1) - position
        return (value & (0b1 << shiftAmount)) >> shiftAmount
    }
}

class Diagnostics {
    let readings: [Reading]

    init(readings: [Reading]) {
        self.readings = readings
    }

    var powerConsumption: UInt {
        gammaRate * epsilonRate
    }

    var gammaRate: UInt {
        let bits = (0..<readingWidth).map { i in
            commonBit(at: i, in: readings)
        }
        return constructInt(bits: bits)
    }

    var epsilonRate: UInt {
        let bits = (0..<readingWidth).map { i in
            leastCommonBit(at: i, in: readings)
        }
        return constructInt(bits: bits)
    }

    var o2GeneratorRating: UInt {
        filterReadings { i, readings in 
            let common = commonBit(at: i, in: readings)
            return readings.filter { r in
                r.bit(at: i) == common
            }
        }?.value ?? 0
    }

    var co2ScrubberRating: UInt {
        filterReadings { i, readings in 
            let leastCommon = leastCommonBit(at: i, in: readings)
            return readings.filter { r in
                r.bit(at: i) == leastCommon
            }
        }?.value ?? 0
    }

    var lifeSupportRating: UInt {
        o2GeneratorRating * co2ScrubberRating
    }

    private func filterReadings(using filterBlock: (Int, [Reading]) -> [Reading]) -> Reading? {
        var filteredReadings = self.readings

        for i in 0..<readingWidth {
            // print("bit position: \(i)")
            filteredReadings = filterBlock(i, filteredReadings)
            // print("filteredReadings: \n\t" + filteredReadings.map(\.stringValue).joined(separator: "\n\t") + "\n")
            if filteredReadings.count == 1 {
                return filteredReadings[0]
            }
        }

        return nil
    }

    private func constructInt(bits: [UInt]) -> UInt {
        guard !bits.isEmpty else { return 0 }
        return bits.enumerated().reduce(0) { (num: UInt, item: (index: Int, bit: UInt)) -> UInt in
            num + item.bit << ((bits.count - 1) - item.index)
        }
    }

    private lazy var readingWidth: Int = {
        readings.map(\.width).max() ?? 0
    }()

    // position is 0 indexed from the left
    private func commonBit(at position: Int, in readings: [Reading]) -> UInt {
        assert(!readings.isEmpty)
        assert(position >= 0 || position < readingWidth)

        let bits = readings.map { $0.bit(at: position) }
        let sum = bits.reduce(0, +)
        let f = (Float(sum) / Float(readings.count)).rounded()
        return UInt(f)
    }

    private func leastCommonBit(at position: Int, in readings: [Reading]) -> UInt {
        1 - commonBit(at: position, in: readings)
    }
}
