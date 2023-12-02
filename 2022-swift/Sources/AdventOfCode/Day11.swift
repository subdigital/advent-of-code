import Foundation
struct Day11: Challenge {
    let input: String

    typealias MonkeyIndex = Int
    typealias ItemType = Int64

    class Monkey {
        let index: MonkeyIndex
        var inspectionCount = 0
        var items: [ItemType]
        let worryFunc: (ItemType) -> ItemType
        let testFunc: (ItemType) -> MonkeyIndex

        init(index: MonkeyIndex, items: [ItemType], worryFunc: @escaping (ItemType) -> ItemType, testFunc: @escaping (ItemType) -> MonkeyIndex) {
            self.index = index
            self.items = items
            self.worryFunc = worryFunc
            self.testFunc = testFunc
        }

        func turn(group: Group) {
            while !items.isEmpty {
                let item = items.removeFirst()
                inspectionCount += 1
                print("\tInspects an item with worry level \(item)")
                let worry = worryFunc(item) / ItemType(group.worryDiv) % group.moduloMax
                print("\tafter worry func => \(worry)")
                let otherIndex = testFunc(worry)
                print("\tThrowing to \(otherIndex)")
                throwItem(item: worry, to: group.monkeys[otherIndex])
            }
        }

        func throwItem(item: ItemType, to other: Monkey) {
            other.receive(item)
        }

        func receive(_ item: ItemType) {
            items.append(item)
        }
    }

    class Group {
        var monkeys: [Monkey] = []
        var worryDiv = 1
        var moduloMax = Int64.max

        static func parse(_ input: String) -> Group {
            let group = Group()
            var startingItems: [ItemType] = []
            var worryFuncOperand: ItemType?
            var worryFuncOperator = ""
            var testFuncOperand: ItemType = -1
            var trueMonkeyIndex = -1
            var falseMonkeyIndex = -1

            var testOperands: Set<ItemType> = []

            for line in input.lines().map({ $0.trimmingCharacters(in: .whitespaces) }) {
                if line.isEmpty {
                    continue
                }

                if line.starts(with: "Monkey") {
                    print("Monkey \(group.monkeys.count)...")
                } else if line.starts(with: "Starting items:") {
                    let items = line
                        .split(separator: ": ").last!
                        .split(separator: ", ")
                        .map(String.init)
                        .compactMap(Int64.init)
                    startingItems = items
                    print(items)
                } else if line.starts(with: "Operation:") {
                    let expr = line.split(separator: "= ").last!
                    guard let lastEl = expr.split(separator: " ").last else {
                        fatalError("Invalid expression: \(expr)")
                    }
                    worryFuncOperand = Int64(String(lastEl)).flatMap(ItemType.init) // if nil we will use the "old" value
                    if expr.contains("+") {
                        worryFuncOperator = "+"
                    } else if expr.contains("*") {
                        worryFuncOperator = "*"
                    } else {
                        fatalError("Invalid expression: \(expr)")
                    }
                } else if line.starts(with: "Test:") {
                    guard let operand = line.split(separator: " ").last.flatMap({ Int64(String($0))}) else {
                        fatalError("Invalid test func: \(line)")
                    }
                    testOperands.insert(operand)
                    testFuncOperand = operand
                } else if line.starts(with: "If true") {
                    trueMonkeyIndex = line.split(separator: "to monkey ").last.flatMap { Int(String($0)) }!
                    print("true monkey: \(trueMonkeyIndex)")
                } else if line.starts(with: "If false") {
                    falseMonkeyIndex = line.split(separator: "to monkey ").last.flatMap { Int(String($0)) }!
                    print("false monkey: \(falseMonkeyIndex)")
                    let trueMonkey = trueMonkeyIndex
                    let falseMonkey = falseMonkeyIndex
                    let testOperand = testFuncOperand

                    let testFunc = { (x: ItemType) -> MonkeyIndex in 
                        // print("is \(x) multiple of \(testOperand)?", trueMonkey, falseMonkey)
                        if x.isMultiple(of: testOperand) {
                            return trueMonkey
                        } else {
                            return falseMonkey
                        }
                    }

                    let worryOperand = worryFuncOperand
                    let worryOperator = worryFuncOperator
                    let worryFunc = { (x: ItemType) -> ItemType in 
                        print("worry = x \(worryOperator) ", worryOperand ?? "x")
                        if worryOperator == "+" {
                            return x + (worryOperand ?? x)
                        } else {
                            return x * (worryOperand ?? x)
                        }
                    }

                    let monkey = Monkey(index: group.monkeys.count, items: startingItems, worryFunc: worryFunc, testFunc: testFunc)
                    group.moduloMax = testOperands.reduce(1, *)
                    group.monkeys.append(monkey)
                }
            }

            return group
        }

        func processRound() {
            for monkey in monkeys {
                print("Monkey: \(monkey.index):")
                monkey.turn(group: self)
            }
        }

        func run(rounds: Int, worryDiv: Int) {
            self.worryDiv = worryDiv
            for round in 1...rounds {
                print("------------------------------------")
                print("Round \(round):")
                processRound()
                for monkey in monkeys {
                    print("m\(monkey.index): \(monkey.items)")
                }
                print("------------------------------------")
            }
        }
    }

    func run() -> String {
        var output = ""
        let group = Group.parse(input)
        // output.append("Part 1: \(part1(group))")
        output.append("Part 2: \(part2(group))")

        return output
    }

    private func part1(_ group: Group) -> String {
        group.run(rounds: 20, worryDiv: 3)
        let inspections = group.monkeys.map { monkey in
            "Monkey \(monkey.index) => \(monkey.inspectionCount)\n"
        }
        print(inspections)
        let result = group.monkeys.map(\.inspectionCount).sorted().reversed().prefix(2).compactMap({$0}).reduce(1, *)

        return "result: \(result)"
    }

    private func part2(_ group: Group) -> String {
        group.run(rounds: 10_000, worryDiv: 1)
        let inspections = group.monkeys.map { monkey in
            "Monkey \(monkey.index) => \(monkey.inspectionCount)\n"
        }
        print(inspections)
        let result = group.monkeys.map(\.inspectionCount).sorted().reversed().prefix(2).compactMap({$0}).reduce(1, *)

        return "result: \(result)"
    }
}
