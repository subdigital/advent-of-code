
public extension String {
    var lines: [Substring] {
        split(separator: "\n", omittingEmptySubsequences: false)
    }
}
