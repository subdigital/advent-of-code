
//
//  CollectionExtensions.swift
//  AOCShared
//
//  Created by Ben Scheirman on 12/2/22.
//

extension Collection where Element: Numeric {
    public func sum() -> Element {
        reduce(0, +)
    }
}

