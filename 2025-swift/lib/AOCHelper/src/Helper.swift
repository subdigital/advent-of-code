import Foundation

public func readInput(from bundle: Bundle, trimWhitespaceAndNewLines: Bool = true) -> String {
    let path = bundle.path(forResource: "input", ofType: "txt")!
    var result = try! String(contentsOfFile: path, encoding: .utf8)
    if trimWhitespaceAndNewLines {
        result = result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    return result
}

public extension String {
    func lines() -> [Substring] {
        split(separator: "\n", omittingEmptySubsequences: true)
    }
}
