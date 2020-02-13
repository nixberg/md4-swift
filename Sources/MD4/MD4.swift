import Foundation

public struct MD4 {
    public static let byteCount = 16
    
    private var state: SIMD4<UInt32>
    
    private var buffer = [UInt8](repeating: 0, count: 64)
    private var length: Int = 0
    
    private var block: SIMD16<UInt32> = .zero
    
    public init() {
        state = .init(0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476)
    }
    
    private mutating func compress() {
        var state = self.state
        
        var buffer = self.buffer[...]
        for i in 0..<16 {
            block[i] = UInt32(littleEndianBytes: buffer.prefix(4))
            buffer = buffer.dropFirst(4)
        }
        
        @inline(__always)
        func choice(_ x: UInt32, _ y: UInt32, _ z: UInt32) -> UInt32 {
            z ^ (x & (y ^ z))
        }
        
        @inline(__always)
        func majority(_ x: UInt32, _ y: UInt32, _ z: UInt32) -> UInt32 {
            (x & y) | (z & (x | y))
        }
        
        @inline(__always)
        func parity(_ x: UInt32, _ y: UInt32, _ z: UInt32) -> UInt32 {
            x ^ y ^ z
        }
        
        @inline(__always)
        func roundOneOperation(_ a: Int, _ b: Int, _ c: Int, _ d: Int, k: Int, rotatedBy s: Int) {
            state[a] &+= choice(state[b], state[c], state[d]) &+ block[k]
            state[a].rotateLeft(by: s)
        }
        
        @inline(__always)
        func roundTwoOperation(_ a: Int, _ b: Int, _ c: Int, _ d: Int, k: Int, rotatedBy s: Int) {
            state[a] &+= majority(state[b], state[c], state[d]) &+ block[k] &+ 0x5a827999
            state[a].rotateLeft(by: s)
        }
        
        @inline(__always)
        func roundThreeOperation(_ a: Int, _ b: Int, _ c: Int, _ d: Int, k: Int, rotatedBy s: Int) {
            state[a] &+= parity(state[b], state[c], state[d]) &+ block[k] &+ 0x6ed9eba1
            state[a].rotateLeft(by: s)
        }
        
        for i in stride(from: 0, to: 16, by: 4) {
            roundOneOperation(0, 1, 2, 3, k: i + 0, rotatedBy:  3)
            roundOneOperation(3, 0, 1, 2, k: i + 1, rotatedBy:  7)
            roundOneOperation(2, 3, 0, 1, k: i + 2, rotatedBy: 11)
            roundOneOperation(1, 2, 3, 0, k: i + 3, rotatedBy: 19)
        }
        
        for i in 0..<4 {
            roundTwoOperation(0, 1, 2, 3, k: i +  0, rotatedBy:  3)
            roundTwoOperation(3, 0, 1, 2, k: i +  4, rotatedBy:  5)
            roundTwoOperation(2, 3, 0, 1, k: i +  8, rotatedBy:  9)
            roundTwoOperation(1, 2, 3, 0, k: i + 12, rotatedBy: 13)
        }
        
        for i in [0, 2, 1, 3] {
            roundThreeOperation(0, 1, 2, 3, k: i +  0, rotatedBy:  3)
            roundThreeOperation(3, 0, 1, 2, k: i +  8, rotatedBy:  9)
            roundThreeOperation(2, 3, 0, 1, k: i +  4, rotatedBy: 11)
            roundThreeOperation(1, 2, 3, 0, k: i + 12, rotatedBy: 15)
        }
        
        self.state &+= state
    }
    
    public mutating func update<D>(with input: D) where D: DataProtocol {
        var index = length % 64
        length += input.count
        
        for byte in input {
            buffer[index] = byte
            index += 1
            
            if index == 64 {
                self.compress()
                index = 0
            }
        }
    }
    
    public mutating func finalize<M>(into output: inout M) where M: MutableDataProtocol {
        let index = length % 64
        
        buffer[index] = 0x80
        buffer.resetBytes(in: (index + 1)..<64)
        
        if index >= 56 {
            self.compress()
            buffer.resetBytes(in: 0..<56)
        }
        
        for (i, byte) in UInt64(8 * length).littleEndianBytes.enumerated() {
            buffer[56 + i] = byte
        }
        self.compress()
        
        state.indices.forEach {
            output.append(contentsOf: state[$0].littleEndianBytes)
        }
    }
    
    public mutating func finalize() -> [UInt8] {
        var output = [UInt8]()
        output.reserveCapacity(Self.byteCount)
        self.finalize(into: &output)
        return output
    }
}

public extension MD4 {
    static func hash<D, M>(_ input: D, into output: inout M) where D: DataProtocol, M: MutableDataProtocol {
        var hashFunction = Self()
        hashFunction.update(with: input)
        hashFunction.finalize(into: &output)
    }
    
    static func hash<D>(_ input: D) -> [UInt8] where D: DataProtocol {
        var hashFunction = Self()
        hashFunction.update(with: input)
        return hashFunction.finalize()
    }
}

fileprivate extension FixedWidthInteger where Self: UnsignedInteger {
    init<D>(littleEndianBytes bytes: D) where D: DataProtocol {
        assert(bytes.count == Self.bitWidth / 8)
        self = bytes.reversed().reduce(0, { $0 &<< 8 | Self($1) })
    }
    
    var littleEndianBytes: [UInt8] {
        stride(from: 0, to: Self.bitWidth, by: 8).map { UInt8(truncatingIfNeeded: self &>> $0) }
    }
    
    @inline(__always)
    mutating func rotateLeft(by n: Int) {
        self = (self &<< n) | (self &>> (Self.bitWidth - n))
    }
}
