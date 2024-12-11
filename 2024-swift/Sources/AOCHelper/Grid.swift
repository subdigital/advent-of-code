//
//  Grid.swift
//  AdventOfCode2024
//
//  Created by Ben Scheirman on 12/6/24.
//

public struct Grid<Element> {
    public var data: [[Element]]

    public var rows: Int { data.count }
    public var cols: Int {
        guard rows > 0 else { return 0 }

        return data[0].count
    }

    public subscript(x: Int, y: Int) -> Element {
        get { data[y][x] }
        set { data[y][x] = newValue }
    }

    public subscript(_ point: Point) -> Element {
        get { data[point.y][point.x] }
        set { data[point.y][point.x] = newValue }
    }

    public init(data: [[Element]]) {
        self.data = data
    }

    public func isInside(_ point: Point) -> Bool {
        point.x >= 0 && point.x < cols &&
                point.y >= 0 && point.y < rows
    }
}

public extension Grid {
    func neighbors(for point: Point) -> [Point] {
        [
            Point.up,
            .down,
            .left,
            .right
        ]
            .map { point + $0 }
            .filter(isInside)
    }
}

extension Grid where Element: Equatable {
    public func searchAll(for el: Element) -> [Point] {
        var results: [Point] = []
        for y in 0..<rows {
            for x in 0..<cols {
                if data[y][x] == el {
                    results.append(Point(x, y))
                }
            }
        }

        return results
    }
}

extension Grid: CustomStringConvertible where Element: CustomStringConvertible {
    public var description: String {
        data.map { row in
            row.map { $0.description }
                .joined(separator: "")
        }
        .joined(separator: "\n")
    }
}

extension Grid: Sendable where Element: Sendable { }

public struct Point: Hashable, Sendable {
    public let x: Int
    public let y: Int

    public init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    public var transpose: Point {
        Point(y, x)
    }
}

extension Point: CustomStringConvertible {
    public static var up: Point { Point(0, -1) }
    public static var down: Point { Point(0, 1) }
    public static var left: Point { Point(-1, 0) }
    public static var right: Point { Point(1, 0) }
    public static var upRight: Point { Point(1, -1) }
    public static var upLeft: Point { Point(-1, -1) }
    public static var downRight: Point { Point(1, 1) }
    public static var downLeft: Point { Point(-1, 1) }

    public static func + (lhs: Point, rhs: Point) -> Point {
        Point(lhs.x + rhs.x, lhs.y + rhs.y)
    }

    public static func * (lhs: Point, rhs: Point) -> Point {
        Point(lhs.x * rhs.x, lhs.y * rhs.y)
    }

    public static func * (lhs: Point, rhs: Int) -> Point {
        Point(lhs.x * rhs, lhs.y * rhs)
    }

    public static func - (lhs: Point, rhs: Point) -> Point {
        Point(lhs.x - rhs.x, lhs.y - rhs.y)
    }

    public static func += (lhs: inout Point, rhs: Point) {
        lhs = lhs + rhs
    }

    public static func -= (lhs: inout Point, rhs: Point) {
        lhs = lhs - rhs
    }

    public var description: String {
        "(x: \(x), y: \(y))"
    }
}

public enum Direction {
    case up, down, left, right

    public var offset: Point {
        switch self {
        case .up: return .up
        case .down: return .down
        case .left: return .left
        case .right: return .right
        }
    }

    public func mirror() -> Direction {
        switch self {
        case .up: return .down
        case .down: return .up
        case .left: return .right
        case .right: return .left
        }
    }

    public func turnRight() -> Direction {
        switch self {
        case .up: return .right
        case .right: return .down
        case .down: return .left
        case .left: return .up
        }
    }

    public var isVertical: Bool {
        self == .up || self == .down
    }

    public var isHorizontal: Bool {
        self == .left || self == .right
    }
}

