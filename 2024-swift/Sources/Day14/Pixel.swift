//
//  Pixel.swift
//  AdventOfCode2024
//
//  Created by Ben Scheirman on 12/16/24.
//

struct Pixel {
    var r: UInt8
    var g: UInt8
    var b: UInt8
    var a: UInt8
}

extension Pixel {
    static var pink: Pixel {
        Pixel(r: 255, g: 105, b: 180, a: 255)
    }

    static var black: Pixel {
        Pixel(r: 0, g: 0, b: 0, a: 255)
    }
}
