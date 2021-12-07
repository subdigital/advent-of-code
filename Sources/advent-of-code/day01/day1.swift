import Algorithms

enum Day1 {
    static func run() {
        let input = readFile("day1.input")
        let scanner = DepthScanner.parse(input)
        let count = scanner.increaseCount(windowSize: 3)
        print("Depth increased \(count) time(s)")
    }
}


struct DepthScanner {
    private let depths: [Int]
    init(depths: [Int]) {
        self.depths = depths
        print("Depths: \(depths)")
        print("Depths: \(depths.adjacentPairs())")
    }

    func increaseCount(windowSize: Int = 1) -> Int {
        assert(windowSize > 0)
        var windowSums: [Int] = []
        for index in depths.indices {
            if index < windowSize - 1 {
                continue
            }
            var sum = 0
            for i in 0..<windowSize {
                sum += depths[index - i]
            }
            windowSums.append(sum)
        }

        for pair in windowSums.adjacentPairs() {
            let diff = pair.1 - pair.0
            print("[\(pair.0) -> \(pair.1)] \(diff)")
        }

        return windowSums.adjacentPairs()
            .map { $0.1 - $0.0 }
            .filter { $0 > 0 }
            .count
    }

    static func parse(_ input: String) -> Self {
        let depths = input.split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .compactMap { Int(String($0)) }
        return .init(depths: depths)
    }
}


