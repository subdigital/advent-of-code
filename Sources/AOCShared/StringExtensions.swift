extension String {
    public func lines() -> [String.SubSequence] {
        split(separator: "\n")
    }
}
