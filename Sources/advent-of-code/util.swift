import Foundation

func readFile(_ name: String) -> String {
    let projectURL = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .appendingPathComponent("resources")
    let fileURL = projectURL.appendingPathComponent(name)
    let data = try! Data(contentsOf: fileURL)
    return String(data: data, encoding: .utf8)!
}
