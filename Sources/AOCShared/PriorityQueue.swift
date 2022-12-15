import Collections

public struct PriorityQueue<T: Comparable> {
  private var heap: Heap<T>

  public init() {
      heap = Heap()
  }

  public var isEmpty: Bool {
    heap.isEmpty
  }

  public var count: Int {
    heap.count
  }

  public func peek() -> T? {
      heap.min()
  }

  public mutating func enqueue(element: T) {
    heap.insert(element)
  }

  public mutating func dequeue() -> T? {
    heap.popMin()
  }
}
