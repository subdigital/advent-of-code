import Foundation

public func readInput(_ inputFilename: String = "input.txt", from bundle: Bundle) throws -> String {
    guard let url = bundle.url(forResource: inputFilename, withExtension: nil) else {
        fatalError("Can't find \(inputFilename) in bundle")
    }

    guard let input = String(data: try Data(contentsOf: url), encoding: .utf8) else {
        fatalError("Can't read \(url) as UTF-8")
    }

    return input
}
