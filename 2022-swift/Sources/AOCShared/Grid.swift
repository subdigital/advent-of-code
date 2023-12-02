public struct Grid: CustomStringConvertible {
    private var data: [Character]
    public private(set) var height: Int
    public private(set) var width: Int
    public var showAxes = false
    public var origin = (0, 0)

    public init(data: [Character], width: Int, height: Int) {
        assert(data.count == width * height)

        self.data = data
        self.width = width
        self.height = height
    }

    public mutating func addColumnLeft(char: Character) {
        origin.0 -= 1
        width += 1
        for y in 0..<height {
            data.insert(char, at: y * width)
        }
    }

    public mutating func addColumnRight(char: Character) {
        width += 1
        for y in 0..<height {
            data.insert(char, at: (width - 1) + y * width)
        }
    }

    public func find(_ char: Character) -> (Int, Int)? {
        guard let index = data.firstIndex(of: char) else { return nil }
        return indexToPos(index)
    }

    public mutating func replace(char: Character, at pos: (Int, Int)) {
        guard let index = posToIndex(pos) else { return }
        data[index] = char
    }

    public func neighbors(_ pos: (x: Int, y: Int)) -> [(pos: (x: Int, y: Int), cost: Int)] {
        let cur = self[pos]!
        let curCost = cost(cur)

        let up =    (x: pos.x,   y: pos.y-1)
        let right = (x: pos.x+1, y: pos.y)
        let down =  (x: pos.x,   y: pos.y+1)
        let left =  (x: pos.x-1, y: pos.y)

        return [ up, right, down, left ].compactMap { pos in
            guard let char = self[pos] else { return nil }
            let cost = self.cost(char) - curCost
            return (pos, Int(cost))
        }
    }

    public func cost(_ character: Character) -> Int {
        func charCost(_ char: Character) -> Int {
            Int(char.asciiValue!) - 97 // ascii "a" is the smallest
        }
        switch character {
        case "S": return charCost("a")
        case "E": return charCost("z")
        case "a"..."z": return charCost(character)
        default: fatalError("Non-ascii character?")
        }
    }

    public subscript(_ pos: (Int, Int)) -> Character? {
        guard let index = posToIndex(pos)
        else {
            return nil
        }

        return data[index]
    }

    public func posToIndex(_ pos: (x: Int, y: Int)) -> Int? {
        let index = (pos.y - origin.1) * width + (pos.x - origin.0)
        if index < 0 || index >= data.count {
            return nil
        }
        return index
    }

    public func indexToPos(_ index: Int) -> (Int, Int) {
        let y = index / width
        let x = (index % width)
        return (x + origin.0, y + origin.1)
    }

    public static func parse(_ input: String) -> Self {
        let lines = input.lines()

        let values = lines
            .flatMap { line in
                Array(line)
            }

        return Grid(data: values, width: values.count/lines.count, height: lines.count)
    }

    public var description: String {
        var output = ""

        if showAxes {
            var minX = String(origin.0)
            var maxX = String(origin.0 + width - 1)
            let xPadding = 5
            // assume the min/max are the same number of digits
            while !minX.isEmpty && !maxX.isEmpty {
                let digitLeft = minX.removeFirst() 
                let digitRight = maxX.removeFirst() 
                let leadingSpaces = Array(repeating: " ", count: xPadding).joined()
                let betweenSpaces = Array(repeating: " ", count: width-2).joined()
                let line = "\(leadingSpaces)\(digitLeft)\(betweenSpaces)\(digitRight)"
                output.append(line + "\n")
            }
        }

        var isFirstInLine = true
        var lineIndex = 0
        for (index, char) in data.enumerated() {
            if showAxes && isFirstInLine {
                output.append(String(format: "%4d ", lineIndex))
                isFirstInLine = false
            }
            output.append("\(char)")
            if (index + 1) % width == 0 {
                output.append("\n")
                lineIndex += 1
                isFirstInLine = true
            }
        }
        return output
    }
}
