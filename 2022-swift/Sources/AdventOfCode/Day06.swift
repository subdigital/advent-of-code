//
//  File.swift
//  
//
//  Created by Ben Scheirman on 12/7/22.
//

import Foundation
import AOCShared
import Algorithms

struct Day06: Challenge {
    let input: String

    func run() -> String {
        var output = ""
//        output += "Part 1: \(part1())\n"
        output += "Part 2: \(part2())\n"
        return output
    }

    private func findStartOfPacketMarker(_ input: some StringProtocol) -> Int {
        findDistinctPacket(input, length: 4)
    }

    private func findStartOfMessageMarker(_ input: some StringProtocol) -> Int {
        findDistinctPacket(input, length: 14)
    }

    private func findDistinctPacket(_ input: some StringProtocol, length: Int) -> Int {
        guard let (index, _) = input.windows(ofCount: length)
            .enumerated()
            .first(where: { (index, window) in
                Set(window).count == length
            }) else { return -1 }

        return index + length
    }

    private func part1() -> String {
        for line in input.lines() {
            print("Line: \n\(line)")
            let startOfPacket = findStartOfPacketMarker(line)
            for _ in 0..<startOfPacket-1 {
                print(" ", terminator: "")
            }
            print("^ \(startOfPacket)\n")
        }
        return ""
    }

    private func part2() -> String {
        for line in input.lines() {
            print("Line: \n\(line)")
            let startOfPacket = findStartOfMessageMarker(line)
            for _ in 0..<startOfPacket-1 {
                print(" ", terminator: "")
            }
            print("^ \(startOfPacket)\n")
        }
        return ""
    }
}
