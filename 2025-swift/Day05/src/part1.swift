import AOCHelper
import Foundation
import Parsing

enum Part1 {
    struct Inventory {
        let fresh: [ClosedRange<Int>]
        let items: [Int]

        func freshIngredients() -> [Int] {
            // naive
            items.filter { item in
                fresh.contains { f in
                    f.contains(item)
                }
            }
        }
    }

    static func rangeParser() -> some Parser<Substring, ClosedRange<Int>> {
        Parse(input: Substring.self) {
            Int.parser()
            "-"
            Int.parser()
        }.map { $0...$1 }
    }

    static func inventoryParser() -> some Parser<Substring, Inventory> {
        Parse(input: Substring.self) {
            Inventory(fresh: $0, items: $1)
        } with: {
            Many {
                rangeParser()
            } separator: {
                "\n"
            } terminator: {
                "\n\n"
            }

            Many {
                Int.parser()
            } separator: {
                "\n"
            }
        }
    }

    static func parse(_ input: String) throws -> Inventory {
        let inventory = try inventoryParser().parse(input)
        return inventory
    }

    static func process(_ input: String) throws -> String {
        let inventory = try parse(input)
        let freshCount = inventory.freshIngredients().count
        return "\(freshCount)"
    }
}
