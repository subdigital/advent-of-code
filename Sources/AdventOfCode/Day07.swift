import AOCShared

protocol Sizeable {
    var size: Int { get }
}

struct Day07: Challenge {
    enum Command {
        case cd(String)
        case ls
        init?(_ input: some StringProtocol) {
            let parts = input.split(separator: " ")
            guard parts.count > 0 else { return nil }

            switch parts[0] {
            case "cd":
                guard parts.count == 2 else { return nil }
                self = .cd(String(parts[1]))
            case "ls":
                self = .ls
            default:
                return nil
            }
        }
    }

    enum FilesystemItem: Sizeable {
        case dir(Directory)
        case file(File)

        var size: Int {
            switch self {
            case .dir(let d): return d.size
            case .file(let f): return f.size
            }
        }
    }

    class Directory: Sizeable {
        let name: String
        var children: [FilesystemItem]

        init(name: String) {
            self.name = name
            self.children = []
        }

        var size: Int {
            children.reduce(0) { total, item in 
                total + item.size
            }
        }

        var dirs: [Directory] {
            children.compactMap {
                guard case .dir(let d) = $0 else { return nil }
                return d
            }
        }

        func subdir(name: some StringProtocol) -> Directory {
            for child in children {
                if case .dir(let dir) = child, dir.name == name {
                    return dir
                }
            }
            let dir = Directory(name: String(name))
            children.append(.dir(dir))
            return dir
        }
    }

    struct File: Sizeable {
        let name: String
        let size: Int
    }

    let input: String

    func run() -> String {
        let root = parse(input)
        dump(root)
        var output = ""
        output += "Part 1: \(part1(root))\n"
        output += "Part 2: \(part2(root))\n"
        return output
    }

    private func cd(_ name: String, path: inout [Directory]) {
        switch name {
            case "/": path = [path.first!]
        case "..":
            guard path.count > 1 else {
                return
            }
            path.removeLast()
        case let name:
            let dir = path.last!.subdir(name: name)
            path.append(dir)
        }
    }

    private func parse(_ output: some StringProtocol) -> Directory {
        let root = Directory(name: "/")
        var path: [Directory] = [root]
        for line in output.lines() {
            print(line)
            if line.starts(with: "$") {
                guard let cmd = Command(line.dropFirst(2)) else {
                    fatalError("Unexpected command: \(line)")
                }

                switch cmd {
                    case .cd(let name): cd(name, path: &path)

                case .ls:
                    break
                }

            } else {
                let parts = line.split(separator: " ")
                guard parts.count == 2 else { 
                    print("unexpected line: \(line)")
                    continue
                }

                if parts[0] == "dir" {
                    _ = path.last!.subdir(name: parts[1])
                } else {
                    guard let size = Int(parts[0]) else {
                        print("invalid file entry: \(line)")
                        continue
                    }
                    let file = File(name: String(parts[1]), size: size)
                    path.last!.children.append(.file(file))
                }
            }
        }

        return root
    }

    private func part1(_ root: Directory) -> String {
        let max = 100_000

        func dirSize(_ start: Directory) -> Int {
            var total = 0
            for dir in start.dirs {
                if dir.size < max {
                    total += dir.size
                }
                total += dirSize(dir)
            }
            return total
        }

        let total = dirSize(root)

        return "Dir size: \(total)"
    }

    private func part2(_ root: Directory) -> String {
        let totalDiskSpace = 70_000_000
        let freeSpaceNeeded = 30_000_000

        func walk(_ start: Directory, collect: (Directory) -> Bool) -> [Directory] {
            var dirs: [Directory] = []
            if collect(start) {
                dirs.append(start)
            }

            for dir in start.dirs {
                let results = walk(dir, collect: collect)
                dirs.append(contentsOf: results)
            }

            return dirs
        }

        let usedSpace = root.size
        let minDirSize = freeSpaceNeeded - (totalDiskSpace - usedSpace)

        let candidates = walk(root) { d in 
            d.size >= minDirSize
        }
        print("Candidates: ", candidates)

        let size = candidates.map(\.size).sorted().first ?? 0
        return "Min size: \(size)"
    }
}
