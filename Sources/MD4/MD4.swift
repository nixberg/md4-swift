public struct MD4 {
    public struct Digest {
        fileprivate let state: State
    }
    
    private var state = State()
    
    private var buffer: [UInt8] = []
    private var digestedBitsCount: UInt64 = 0
    
    private var wasFinalized = false
    
    public init() {}
    
    public mutating func append(contentsOf bytes: some Sequence<UInt8>) {
        precondition(!wasFinalized, "Hash function used after finalization")
        assert((0..<64).contains(buffer.count))
        
        for byte in bytes {
            buffer.append(byte)
            digestedBitsCount += 8
            
            if buffer.count == 64 {
                state.compress(buffer)
                buffer.removeAll(keepingCapacity: true)
            }
        }
    }
    
    public mutating func finalize() -> Digest {
        precondition(!wasFinalized, "Hash function used after finalization")
        wasFinalized = true
        
        assert((0..<64).contains(buffer.count))
        
        buffer.append(0x80)
        
        if buffer.count > 56 {
            buffer.padEnd(with: 0, toCount: 64)
            state.compress(buffer)
            buffer.removeAll(keepingCapacity: true)
        }
        
        buffer.padEnd(with: 0, toCount: 56)
        withUnsafeBytes(of: digestedBitsCount.littleEndian) {
            buffer.append(contentsOf: $0)
        }
        
        state.compress(buffer)
        buffer.removeAll()
        
        return Digest(state: state)
    }
}

extension MD4 {
    public static func hash(contentsOf bytes: some Sequence<UInt8>) -> Digest {
        var hashFunction = Self()
        hashFunction.append(contentsOf: bytes)
        return hashFunction.finalize()
    }
}

extension RangeReplaceableCollection {
    fileprivate mutating func padEnd(with element: Element, toCount paddedCount: Int) {
        let padElementCount = paddedCount - count
        guard padElementCount > 0 else {
            return
        }
        self.append(contentsOf: repeatElement(element, count: padElementCount))
    }
}

#if _endian(big)
#error("Big-endian platforms are currently not supported")
#endif
