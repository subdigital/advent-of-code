import AOCHelper
import Foundation
import Parsing

enum Day09 {
    enum Block: Equatable, CustomStringConvertible {
        case file(id: Int)
        case free

        var description: String {
            switch self {
            case .file(let id): return "\(id)"
            case .free: return "."
            }
        }
    }

    struct Layout {
        private var blocks: [Block]

        var nextFreeBlockIndex: Int?
        var lastFileBlockIndex: Int?

        init(entries: [Entry]) {
            var blocks: [Block] = []
            for entry in entries {
                switch entry {
                case let .file(id, length):
                    blocks.append(contentsOf: Array(repeating: .file(id: id), count: length))
                    lastFileBlockIndex = blocks.count - 1
                case let .free(length):
                    if nextFreeBlockIndex == nil {
                        nextFreeBlockIndex = blocks.count
                    }
                    blocks.append(contentsOf: Array(repeating: .free, count: length))
                }
            }

            self.blocks = blocks
        }

        var count: Int {
            blocks.count
        }

        var layoutString: String {
            blocks.map(\.description).joined()
        }

        subscript(index: Int) -> Block {
            get { blocks[index] }
            set { blocks[index] = newValue }
        }

        func checksum() -> Int {
            blocks.enumerated().reduce(0) { sum, item in
                if case .file(let id) = item.element {
                    return sum + (id * item.offset)
                } else {
                    return sum
                }
            }
        }
    }

    struct BlockDefragmenter {
        var layout: Layout

        init(entries: [Entry]) {
            layout = Layout(entries: entries)
        }

        @discardableResult
        mutating func step(debug: Bool = false) -> Bool {
            guard var lastFileBlockIndex = layout.lastFileBlockIndex,
                  var nextFreeBlockIndex = layout.nextFreeBlockIndex
            else { return true }

            defer {
                layout.lastFileBlockIndex = lastFileBlockIndex
                layout.nextFreeBlockIndex = nextFreeBlockIndex
            }

            layout[nextFreeBlockIndex] = layout[lastFileBlockIndex]
            layout[lastFileBlockIndex] = .free

            if debug {
                print(layout.layoutString)
            }

            while lastFileBlockIndex > 0 {
                lastFileBlockIndex = lastFileBlockIndex - 1
                if case .file = layout[lastFileBlockIndex] {
                    break
                }
            }

            while nextFreeBlockIndex < layout.count - 1 {
                nextFreeBlockIndex += 1
                if case .free = layout[nextFreeBlockIndex] {
                    break
                }
            }

            return lastFileBlockIndex < nextFreeBlockIndex
        }

        mutating func run(debug: Bool = false) {
            while step(debug: debug) == false { }
        }
    }

    struct FileDefragmenter {
        var entries: [Entry]
        var fileIndices: [Int: Int] = [:]
        var freeIndices: [Int] = []
        var fileID: Int = -1

        // .file(1), .free(3), .file(2), .free(5)   [1, 3]
        // .file(1), .file(2), .free(1), .free(5)   [2, 3]

        init(entries: [Entry]) {
            self.entries = entries
            for (index, entry) in entries.enumerated() {
                switch entry {
                case .file(let id, _):
                    fileIndices[id] = index
                    fileID = id
                case .free:
                    freeIndices.append(index)
                }
            }

            assert(fileID != -1, "no files to defrag")
        }

        mutating func step() -> Bool {
            while fileID >= 0 {
                let fileIndex = fileIndices[fileID]!
                let entry = entries[fileIndex]
                guard case .file(let id, let fileLength) = entry else {
                    fatalError("entry is not a file")
                }
                assert(id == fileID, "entry file index was not correct")

                // search for free space fitting this file
                for index in freeIndices {
                    guard case .free(let freeSpace) = entries[index] else { continue }

                    if freeSpace >= fileLength {
                        // we can fit the file here
                        let oldFileIndex = fileIndices[fileID]!
                        entries[index] = .file(id: fileID, length: fileLength)
                        entries[oldFileIndex] = .free(length: fileLength)
                        fileIndices[fileID] = index

                        // a b c d e
                        // 0 1 2 3 4
                        // a d X b c e
                        // 0 1   2 3 4

                        // this index is no long a free space, remove it
                        for (freeIndex, i) in freeIndices.enumerated() {
                            if i == index {
                                freeIndices.remove(at: freeIndex)
                                break
                            }
                        }

                        // if we have free space after this file, add it
                        let remainingSpace = freeSpace - fileLength
                        if remainingSpace > 0 {
                            entries.insert(.free(length: remainingSpace), at: index + 1)
                            freeIndices.append(index + 1)

                            // adjust all indices after this one
                            for (offset, otherSpaceIndex) in freeIndices.enumerated() where otherSpaceIndex > index + 1 {
                                freeIndices[offset] += 1
                            }

                            for (key, val) in fileIndices where val > index + 1 {
                                fileIndices[key] = val + 1
                            }
                        }

                        return false
                    }
                }

                fileID -= 1
            }

            return true
        }

        mutating func run(debug: Bool = false) {
            while step() == false { }
        }

        func layout() -> Layout {
            Layout(entries: entries)
        }

        func checksum() -> Int {
            layout().checksum()
        }
    }

    enum Entry: Equatable {
        case file(id: Int, length: Int)
        case free(length: Int)
    }

    static func parse(_ input: String) -> [Entry] {
        let digits = Array(input.trimmingCharacters(in: .whitespacesAndNewlines)).compactMap { character in
            Int(String(character))
        }

        var fileId = 0
        return digits.enumerated().map { (offset, digit) in
            if offset % 2 == 0 {
                defer { fileId += 1 }
                return .file(id: fileId, length: digit)
            } else {
                return .free(length: digit)
            }
        }
    }

    static func part1(_ input: String) -> String {
        let entries = parse(input)
        var defrag = BlockDefragmenter(entries: entries)
        defrag.run()
        return String(defrag.layout.checksum())
    }

    static func part2(_ input: String) -> String {
        let entries = parse(input)
        var defrag = FileDefragmenter(entries: entries)
        defrag.run()
        return String(defrag.checksum())
    }
}

//let input = try readInput(from: .module)
//print("DAY 09 Part 1: ")
//print(Day09.part1(input))
//print("---------------------")

