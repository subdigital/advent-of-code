import Foundation

func readFile(_ name: String) -> String {
    let projectURL = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .appendingPathComponent("resources")
    let fileURL = projectURL.appendingPathComponent(name)
    let data = try! Data(contentsOf: fileURL)
    return String(data: data, encoding: .utf8)!
}

extension String {
    var lines: [String] {
        split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
    }
}

extension Int {
    init?(_ s: Substring) {
        guard let int = Int(String(s)) else { return nil }
        self = int
    }
}
