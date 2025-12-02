//
//  ContentView.swift
//  AdventOfCode2024
//
//  Created by Ben Scheirman on 12/16/24.
//

import SwiftUI
import MetalKit
import AOCHelper
import Parsing
import Carbon.HIToolbox

struct Robot {
    var pos: Point
    let velocity: Vec2
}

final class Day14 {
    var width: Int
    var height: Int
    var robots: [Robot]

    convenience init() {
        let input = """
        p=0,4 v=3,-3
        p=6,3 v=-1,-3
        p=10,3 v=-1,2
        p=2,0 v=2,-1
        p=0,0 v=1,3
        p=3,0 v=-2,-2
        p=7,6 v=-1,-3
        p=3,0 v=-1,-2
        p=9,3 v=2,3
        p=7,3 v=-1,2
        p=2,4 v=2,-3
        p=9,5 v=-3,-3
        """

        try! self.init(input: input, width: 11, height: 7)
    }

    var count = 0

    init(input: String, width: Int, height: Int) throws {
        robots = try Self.parse(input, width: width, height: height)
        self.width = width
        self.height = height
    }

    static func parse(_ input: String, width: Int, height: Int) throws -> [Robot] {
        let pointParser = Parse(input: Substring.self) {
            Skip { CharacterSet.letters }
            "="
            Int.parser()
            ","
            Int.parser()
        }.map { Point($0, $1) }

        let parser = Parse {
            Many {
                pointParser
                " "
                pointParser
            } separator: {
                "\n"
            }.map { values in
                values.map { Robot(pos: $0.0, velocity: $0.1) }
            }
        }

        return try parser.parse(input)
    }

    func stepReverse() {
        defer { count -= 1 }

        for (index, var robot) in robots.enumerated() {
            robot.pos = Point(
                (robot.pos.x - robot.velocity.x) % width,
                (robot.pos.y - robot.velocity.y) % height
            )
            while robot.pos.x < 0 {
                robot.pos.x += width
            }
            while robot.pos.y < 0 {
                robot.pos.y += height
            }
            robots[index] = robot
        }
    }

    func step() {
        defer { count += 1 }

        for (index, var robot) in robots.enumerated() {
            robot.pos = Point(
                (robot.pos.x + robot.velocity.x) % width,
                (robot.pos.y + robot.velocity.y) % height
            )
            while robot.pos.x < 0 {
                robot.pos.x += width
            }
            while robot.pos.y < 0 {
                robot.pos.y += height
            }
            robots[index] = robot
        }
    }

    struct Quadrant {
        var x, y, w, h: Int
    }

    func calculateScore() -> Int {
        let midPoint = Point((width - 1) / 2, (height - 1) / 2)
        let w: Int = midPoint.x
        let h: Int = midPoint.y
        let q1 = Quadrant(x: 0, y: 0, w: w, h: h)
        let q2 = Quadrant(x: midPoint.x + 1, y: 0, w: w, h: h)
        let q3 = Quadrant(x: 0, y: midPoint.y + 1, w: w, h: h)
        let q4 = Quadrant(x: midPoint.x + 1, y: midPoint.y + 1, w: w, h: h)

        var total = 1
        for q in [q1, q2, q3, q4] {
            let qc = robots.filter {
                $0.pos.x >= q.x && $0.pos.x < q.x + q.w &&
                $0.pos.y >= q.y && $0.pos.y < q.y + q.h
            }.count

            print("Quadrant: \(q) has \(qc) robots")
            total *= qc
        }

        return total
    }
}

struct ContentView: View {
    @State var x = 0
    @State var y = 0
    @State var running = false

    let model: Day14

    init(model: Day14) {
        self.model = model
    }

    var body: some View {
        MetalViewRepresentable(
            textureSize: TextureSize(width: model.width, height: model.height),
            update: update,
            render: render
        )
    }

    private func update(_ context: UpdateContext) {
        if model.count == 402 {
            running = false
        }

        if context.justPressed(key: UInt16(kVK_LeftArrow)) {
            running = false
            model.stepReverse()
            print("seconds: \(model.count)")
        }

        if context.justPressed(key: UInt16(kVK_ANSI_R)) {
            running = true
        }

        if running || context.justPressed(key: UInt16(kVK_Space)) || context.keysDown.contains(UInt16(kVK_Return)) {
            model.step()
            print("seconds: \(model.count)")
        }

        let overlapping = model.robots.reduce(into: [:]) { partialResult, robot in
            partialResult[robot.pos, default: []].append(robot)
        }
        let overlappingCount = overlapping.keys.filter { key in
            overlapping[key]!.count > 1
        }.count

        if model.count == 100 {
            print("DONE")
            print("SCORE: \(model.calculateScore())")
        }

        if overlappingCount == 0 && running {
            print("Done, score: \(model.calculateScore())")
            running = false
        }
    }

    private func render(_ pixelData: inout [Pixel]) {
        for y in 0..<model.height {
            for x in 0..<model.width {
                pixelData[y * model.width + x] = .black
            }
        }

        for robot in model.robots {
            pixelData[(model.height - robot.pos.y - 1) * model.width + robot.pos.x] = .pink
        }
    }
}

#Preview {
    ContentView(model: Day14())
}
