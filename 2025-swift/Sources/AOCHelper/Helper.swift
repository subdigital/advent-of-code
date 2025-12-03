import Foundation

public func readInput(from bundle: Bundle) -> String {
    let path = bundle.path(forResource: "input", ofType: "txt")!
    return try! String(contentsOfFile: path, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
}
