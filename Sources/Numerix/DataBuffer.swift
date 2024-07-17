/*
 DataBuffer class for storing underlying Vector and Matrix data in a mutable
 memory buffer.
 */

class DataBuffer<T> {
    var buffer: UnsafeMutableBufferPointer<T>

    init(count: Int, fill: T) {
        let start = UnsafeMutablePointer<T>.allocate(capacity: count)
        self.buffer = UnsafeMutableBufferPointer(start: start, count: count)
        self.buffer.initialize(repeating: fill)
    }

    init(count: Int) {
        let start = UnsafeMutablePointer<T>.allocate(capacity: count)
        self.buffer = UnsafeMutableBufferPointer(start: start, count: count)
    }

    init(array: [T]) {
        let count = array.count
        let start = UnsafeMutablePointer<T>.allocate(capacity: count)
        self.buffer = UnsafeMutableBufferPointer(start: start, count: count)
        _ = self.buffer.initialize(fromContentsOf: array)
    }

    init(buffer: UnsafeMutableBufferPointer<T>) {
        let count = buffer.count
        let start = UnsafeMutablePointer<T>.allocate(capacity: count)
        self.buffer = UnsafeMutableBufferPointer(start: start, count: count)
        _ = self.buffer.initialize(from: buffer)
    }

    deinit {
        self.buffer.deinitialize()
        self.buffer.deallocate()
    }
}
