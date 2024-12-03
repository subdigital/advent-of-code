//
//  Day02Tests.swift
//  AdventOfCode2024
//
//  Created by Ben Scheirman on 12/2/24.
//


import Testing
@testable import Day02

struct Day02Tests {
    @Test
    func part1() throws {
        let output = try Day02.part1("""
        7 6 4 2 1
        1 2 7 8 9
        9 7 6 2 1
        1 3 2 4 5
        8 6 4 4 1
        1 3 6 7 9
        """)
        #expect(output == "2")
    }

    @Test
    func part2() throws {
        let output = try Day02.part2("""
        7 6 4 2 1
        1 2 7 8 9
        9 7 6 2 1
        1 3 2 4 5
        8 6 4 4 1
        1 3 6 7 9
        10 1 2 3 4
        1 2 3 4 10
        """)
        #expect(output == "6")
    }

    @Test func part2_badNumberInEveryPosition() throws {
        let output = try Day02.part2("""
        10 1 2 3 4 5
        1 10 2 3 4 5
        1 2 10 3 4 5
        1 2 3 10 4 5
        1 2 3 4 10 5
        1 2 3 4 5 10
        """)
        #expect(output == "6")
    }
}
