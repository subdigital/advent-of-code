import Testing
import Parsing
@testable import Day05

struct Day05Tests {

    @Test
    func parsing() throws {
        let input = """
        47|53
        97|13
        97|61
        97|47
        75|29
        61|13
        75|53
        29|13
        97|29
        53|29
        61|53
        97|53
        61|29
        47|13
        75|47
        97|75
        47|61
        75|61
        47|29
        75|13
        53|13

        75,47,61,53,29
        97,61,53,29,13
        75,29,13
        75,97,47,61,53
        61,13,29
        97,13,75,29,47
        """

        let (orderingRules, updates) = try Day05.parse(input)
        #expect(orderingRules.count == 21)
        #expect(orderingRules.first == Day05.OrderingRule(47, 53))
        #expect(updates.count == 6)
        #expect(updates.first == [75, 47, 61, 53, 29])
    }

    @Test
    func correctOrder() throws {
        let update = [75, 47, 61, 53, 29]
        let rules = Day05.OrderingRules(rules:
            try Many {
                Day05.OrderingRuleParser()
            } separator: {
                "\n"
            }
            .parse("""
            47|53
            97|13
            97|61
            97|47
            75|29
            61|13
            75|53
            29|13
            97|29
            53|29
            61|53
            97|53
            61|29
            47|13
            75|47
            97|75
            47|61
            75|61
            47|29
            75|13
            53|13
            """)
        )

        #expect(rules.isInCorrectOrder(update))
        #expect(!rules.isInCorrectOrder(update.reversed()))

        #expect(rules.isInCorrectOrder([97,61,53,29,13]))
        #expect(rules.isInCorrectOrder([75,29,13]))

        #expect(!rules.isInCorrectOrder([61,13,29]))
    }

    @Test
    func testPart1() throws {
        let input = """
        47|53
        97|13
        97|61
        97|47
        75|29
        61|13
        75|53
        29|13
        97|29
        53|29
        61|53
        97|53
        61|29
        47|13
        75|47
        97|75
        47|61
        75|61
        47|29
        75|13
        53|13

        75,47,61,53,29
        97,61,53,29,13
        75,29,13
        75,97,47,61,53
        61,13,29
        97,13,75,29,47
        """

        let result = try Day05.part1(input)
        #expect(result == "143")
    }

    @Test
    func testPart2() throws {
        let input = """
        47|53
        97|13
        97|61
        97|47
        75|29
        61|13
        75|53
        29|13
        97|29
        53|29
        61|53
        97|53
        61|29
        47|13
        75|47
        97|75
        47|61
        75|61
        47|29
        75|13
        53|13

        75,47,61,53,29
        97,61,53,29,13
        75,29,13
        75,97,47,61,53
        61,13,29
        97,13,75,29,47
        """

        let result = try Day05.part2(input)
        #expect(result == "123")
    }
}
