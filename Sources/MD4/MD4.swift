import CryptoExtras

public typealias MD4 = CoreWrapper<InlineByteBuffer<64>, MD4Core>

public struct MD4Core: ~Copyable, InitCore, UpdateCore, FixedSizeOutputCore {
    public static let blockByteCount = 64

    public static let outputByteCount = 16

    private var state = State()

    private var messageByteCount = 0

    public init() {}

    public mutating func update(withBlock block: borrowing RawSpan) {
        precondition(block.byteCount == Self.blockByteCount, "TODO")
        state.compress(block)
        messageByteCount += Self.blockByteCount
    }

    public mutating func finalize<Buffer>(
        withBuffer buffer: inout Buffer,
        into output: inout MutableRawSpan
    ) where Buffer: ~Copyable & ByteBufferProtocol {
        precondition(Buffer._capacity == Self.blockByteCount, "TODO")
        precondition(output.byteCount == MD4Core.outputByteCount, "TODO")

        messageByteCount += buffer.count
        buffer.append(0x80)

        if buffer.count > 56 {
            buffer.pad()
            state.compress(buffer.bytes)
            buffer.removeAll()
        }

        buffer.pad(toCount: 56)
        buffer.append(contentsOf: UInt64(messageByteCount * 8).littleEndian.bytes)
        state.compress(buffer.bytes)

        state.storeBytes(into: &output)
    }
}

extension UInt64 {
    fileprivate var bytes: RawSpan {
        @_lifetime(borrow self)
        _read {
            let result: [1 of Self] = [self]
            yield result.span.bytes
        }
    }
}
