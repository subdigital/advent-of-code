import AOCHelper
import Foundation
import Parsing

enum Part2 {
    struct CephalopodCalculator {
        let operators: [Operator]
        var columns: Int { operators.count }
        var lines: [[ArraySlice<Substring.Element>]] = []

        init(operators: [Operator]) {
            self.operators = operators
        }

        mutating func add(line: [ArraySlice<Substring.Element>]) {
            lines.append(line)
        }
        
        func numbers(in column: Int) -> [Int] {
            var numbers: [Int] = []
            let cells = lines.map { $0[column] }
            for i in 0..<cells[0].count {
                let num = Int(cells
                    .map { slice in
                        slice[slice.index(slice.startIndex, offsetBy: i)]
                    }
                    .reduce(into: "") { str, char in
                        if char.isNumber {
                            str.append(String(char))
                        }
                    })!
                numbers.append(num)
            }
//            print("numbers for col: \(column) --> \(numbers)")
            return numbers
        }
        
        func compute(column: Int) -> Int {
            let op = operators[column]
            var nums = numbers(in: column)
            let first = nums.removeFirst()
            return nums.reduce(first, op.fn)
        }
    }
    static func process(_ input: String) throws -> String {
        let lines = input.lines()
        let tuples = lines.last!
            .splitWhitespaceGreedy()
            .compactMap { (str: Substring) -> (Operator, Int)?  in
                guard let char = str.first,
                      let op = Operator(rawValue: String(char))
                else {
                    return nil
                }
                
                return (op, str.count)
            }

        var calculator = CephalopodCalculator(operators: tuples.map { $0.0 })
        for line in lines.dropLast() {
            // we can iterate with int indices because this is all ascii
            let line = line.map { $0 }
            var i = 0
            var cells: [ArraySlice<Substring.Element>] = []
            let widths = tuples.map(\.1)
            for colWidth in widths {
                let j = i + colWidth
                let cell = line[i..<j]
                // faster if we could turn ArraySlice<Substring.Element> back into Substring... can we?
                cells.append(cell)
                i = j + 1 // skip one because of the blank space between each element
            }
            calculator.add(line: cells)
        }
        let sum = (0..<calculator.columns).reversed().map {
            calculator.compute(column: $0)
        }.reduce(0, +)
        return "\(sum)"
    }
}

extension Substring {
    func splitWhitespaceGreedy() -> [Substring] {
        var result: [Substring] = []
        var start = startIndex
        for var index in indices.dropLast() {
            if self[index].isWhitespace {
                // peek ahead
                if self[self.index(after: index)].isWhitespace {
                    // continue searching
                    continue
                } else {
                    // split here && skip ahead
                    result.append(self[start..<index])
                    index = self.index(after: index)
                    start = index
                }
            }
        }
        // add the rest of the string
        result.append(self[start...])
        
        return result
    }
}
