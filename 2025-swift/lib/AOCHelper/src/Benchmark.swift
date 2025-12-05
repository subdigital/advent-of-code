import Foundation

public func withBenchmark(_ run: () throws -> Void) rethrows {
    let clock = ContinuousClock()
    let elapsed = try clock.measure {
        try run()
    }
    print("time: \(formatInterval(elapsed))")
}

private func formatInterval(_ duration: Duration) -> String {
    let ASEC_PER_SEC: Int64 = 1_000_000_000_000_000_000
    let seconds = Double(duration.components.seconds) + Double(duration.components.attoseconds) / Double(ASEC_PER_SEC)
    return formatInterval(seconds)
}

private func formatInterval(_ interval: TimeInterval) -> String {
    // MeasurementFormatter doesn't produce desired results, so implement our own...
    let (value, unit): (Double, String)
    if interval < 0.001 {
        // Microseconds
        value = interval * Double(NSEC_PER_MSEC)
        unit = "μs"
    } else if interval < 1.0 {
        // Milliseconds
        value = interval * 1_000
        unit = "ms"
    } else {
        // Seconds
        value = interval
        unit = "s"
    }

    return String(format: "%.2f %@", value, unit)
}
