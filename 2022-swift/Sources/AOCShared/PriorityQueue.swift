import Collections

public struct PriorityQueue<T: Comparable> {
    private var heap: Heap<T>

    public enum Mode {
        case min
        case max
    }

    private let mode: Mode

    public init(mode: Mode = .min) {
        heap = Heap()
        self.mode = mode
    }

    public var isEmpty: Bool {
        heap.isEmpty
    }

    public var count: Int {
        heap.count
    }

    public func peek() -> T? {
        switch mode {
        case .min: return heap.min()
        case .max: return heap.max()
        }
    }

    public mutating func enqueue(element: T) {
        heap.insert(element)
    }

    public mutating func dequeue() -> T? {
        switch mode {
        case .min: return heap.popMin()
        case .max: return heap.popMax()
        }
    }
}
