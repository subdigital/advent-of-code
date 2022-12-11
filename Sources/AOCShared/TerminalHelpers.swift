
public func moveCursorUp(n: Int = 1) {
    print("\u{001B}[\(n)A", terminator: "")
}

public enum ClearLineStyle: Int {
    case fromCursor
    case toCursor
    case entire
}

public func clearLine(_ style: ClearLineStyle) {
    print("\u{001B}[\(style.rawValue)K", terminator: "")
}
