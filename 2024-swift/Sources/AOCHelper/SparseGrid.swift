//
//  SparseGrid.swift
//  AdventOfCode2024
//
//  Created by Ben Scheirman on 12/8/24.
//

public struct SparseGrid<Element> {
    public private(set) var data: [Point: Element]

    public let width: Int
    public let height: Int

    public subscript(x: Int, y: Int) -> Element? {
        get { data[Point(x, y)] }
        set { data[Point(x, y)] = newValue }
    }

    public subscript(_ point: Point) -> Element? {
        get { data[point] }
        set { data[point] = newValue }
    }

    public init(data: [Point: Element], width: Int, height: Int) {
        self.data = data
        self.width = height
        self.height = width
    }

    public func isInside(_ point: Point) -> Bool {
        point.x >= 0 && point.x < width &&
                point.y >= 0 && point.y < height
    }
}

extension SparseGrid: CustomStringConvertible where Element: CustomStringConvertible {
    public var description: String {
        var desc = ""
        for y in 0..<height {
            for x in 0..<width {
                let point = Point(x, y)
                desc.append(data[point]?.description ?? ".")
            }
            desc.append("\n")
        }
        return desc
    }
}

extension SparseGrid where Element: Equatable {
    public func searchAll(for el: Element) -> [Point] {
        data.filter { $0.value == el }.map { $0.key }
    }
}

extension SparseGrid: Sendable where Element: Sendable { }
