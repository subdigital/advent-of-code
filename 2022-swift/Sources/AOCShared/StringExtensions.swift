extension StringProtocol {
    public func lines() -> [Self.SubSequence] {
        split(separator: "\n")
    }
}
