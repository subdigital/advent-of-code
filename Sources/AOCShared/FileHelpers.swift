//
//  FileHelpers.swift
//  AOCShared
//
//  Created by Ben Scheirman on 12/2/22.
//

import Foundation

public func readFile(_ name: String) -> String {
    let url = URL(filePath: name)
    let data = try! Data(contentsOf: url)
    return String(data: data, encoding: .utf8)!
}

