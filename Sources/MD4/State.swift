import CryptoExtras

struct State: ~Copyable {
    fileprivate var a: UInt32 = 0x6745_2301
    fileprivate var b: UInt32 = 0xefcd_ab89
    fileprivate var c: UInt32 = 0x98ba_dcfe
    fileprivate var d: UInt32 = 0x1032_5476

    mutating func compress(_ blockBytes: borrowing RawSpan) {
        var a = self.a
        var b = self.b
        var c = self.c
        var d = self.d

        let block = [16 of UInt32](parsingLittleEndian: blockBytes)

        a &+= d ^ (b & (c ^ d)) &+ block[00]
        a.rotate(left: 03)
        d &+= c ^ (a & (b ^ c)) &+ block[01]
        d.rotate(left: 07)
        c &+= b ^ (d & (a ^ b)) &+ block[02]
        c.rotate(left: 11)
        b &+= a ^ (c & (d ^ a)) &+ block[03]
        b.rotate(left: 19)
        a &+= d ^ (b & (c ^ d)) &+ block[04]
        a.rotate(left: 03)
        d &+= c ^ (a & (b ^ c)) &+ block[05]
        d.rotate(left: 07)
        c &+= b ^ (d & (a ^ b)) &+ block[06]
        c.rotate(left: 11)
        b &+= a ^ (c & (d ^ a)) &+ block[07]
        b.rotate(left: 19)
        a &+= d ^ (b & (c ^ d)) &+ block[08]
        a.rotate(left: 03)
        d &+= c ^ (a & (b ^ c)) &+ block[09]
        d.rotate(left: 07)
        c &+= b ^ (d & (a ^ b)) &+ block[10]
        c.rotate(left: 11)
        b &+= a ^ (c & (d ^ a)) &+ block[11]
        b.rotate(left: 19)
        a &+= d ^ (b & (c ^ d)) &+ block[12]
        a.rotate(left: 03)
        d &+= c ^ (a & (b ^ c)) &+ block[13]
        d.rotate(left: 07)
        c &+= b ^ (d & (a ^ b)) &+ block[14]
        c.rotate(left: 11)
        b &+= a ^ (c & (d ^ a)) &+ block[15]
        b.rotate(left: 19)

        a &+= (b & c) | (d & (b | c)) &+ block[00] &+ 0x5a82_7999
        a.rotate(left: 03)
        d &+= (a & b) | (c & (a | b)) &+ block[04] &+ 0x5a82_7999
        d.rotate(left: 05)
        c &+= (d & a) | (b & (d | a)) &+ block[08] &+ 0x5a82_7999
        c.rotate(left: 09)
        b &+= (c & d) | (a & (c | d)) &+ block[12] &+ 0x5a82_7999
        b.rotate(left: 13)
        a &+= (b & c) | (d & (b | c)) &+ block[01] &+ 0x5a82_7999
        a.rotate(left: 03)
        d &+= (a & b) | (c & (a | b)) &+ block[05] &+ 0x5a82_7999
        d.rotate(left: 05)
        c &+= (d & a) | (b & (d | a)) &+ block[09] &+ 0x5a82_7999
        c.rotate(left: 09)
        b &+= (c & d) | (a & (c | d)) &+ block[13] &+ 0x5a82_7999
        b.rotate(left: 13)
        a &+= (b & c) | (d & (b | c)) &+ block[02] &+ 0x5a82_7999
        a.rotate(left: 03)
        d &+= (a & b) | (c & (a | b)) &+ block[06] &+ 0x5a82_7999
        d.rotate(left: 05)
        c &+= (d & a) | (b & (d | a)) &+ block[10] &+ 0x5a82_7999
        c.rotate(left: 09)
        b &+= (c & d) | (a & (c | d)) &+ block[14] &+ 0x5a82_7999
        b.rotate(left: 13)
        a &+= (b & c) | (d & (b | c)) &+ block[03] &+ 0x5a82_7999
        a.rotate(left: 03)
        d &+= (a & b) | (c & (a | b)) &+ block[07] &+ 0x5a82_7999
        d.rotate(left: 05)
        c &+= (d & a) | (b & (d | a)) &+ block[11] &+ 0x5a82_7999
        c.rotate(left: 09)
        b &+= (c & d) | (a & (c | d)) &+ block[15] &+ 0x5a82_7999
        b.rotate(left: 13)

        a &+= b ^ c ^ d &+ block[00] &+ 0x6ed9_eba1
        a.rotate(left: 03)
        d &+= a ^ b ^ c &+ block[08] &+ 0x6ed9_eba1
        d.rotate(left: 09)
        c &+= d ^ a ^ b &+ block[04] &+ 0x6ed9_eba1
        c.rotate(left: 11)
        b &+= c ^ d ^ a &+ block[12] &+ 0x6ed9_eba1
        b.rotate(left: 15)
        a &+= b ^ c ^ d &+ block[02] &+ 0x6ed9_eba1
        a.rotate(left: 03)
        d &+= a ^ b ^ c &+ block[10] &+ 0x6ed9_eba1
        d.rotate(left: 09)
        c &+= d ^ a ^ b &+ block[06] &+ 0x6ed9_eba1
        c.rotate(left: 11)
        b &+= c ^ d ^ a &+ block[14] &+ 0x6ed9_eba1
        b.rotate(left: 15)
        a &+= b ^ c ^ d &+ block[01] &+ 0x6ed9_eba1
        a.rotate(left: 03)
        d &+= a ^ b ^ c &+ block[09] &+ 0x6ed9_eba1
        d.rotate(left: 09)
        c &+= d ^ a ^ b &+ block[05] &+ 0x6ed9_eba1
        c.rotate(left: 11)
        b &+= c ^ d ^ a &+ block[13] &+ 0x6ed9_eba1
        b.rotate(left: 15)
        a &+= b ^ c ^ d &+ block[03] &+ 0x6ed9_eba1
        a.rotate(left: 03)
        d &+= a ^ b ^ c &+ block[11] &+ 0x6ed9_eba1
        d.rotate(left: 09)
        c &+= d ^ a ^ b &+ block[07] &+ 0x6ed9_eba1
        c.rotate(left: 11)
        b &+= c ^ d ^ a &+ block[15] &+ 0x6ed9_eba1
        b.rotate(left: 15)

        self.a &+= a
        self.b &+= b
        self.c &+= c
        self.d &+= d
    }

    func storeBytes(into output: inout MutableRawSpan) {
        output.storeBytes(of: a.littleEndian, toByteOffset: 00, as: UInt32.self)
        output.storeBytes(of: b.littleEndian, toByteOffset: 04, as: UInt32.self)
        output.storeBytes(of: c.littleEndian, toByteOffset: 08, as: UInt32.self)
        output.storeBytes(of: d.littleEndian, toByteOffset: 12, as: UInt32.self)
    }
}

extension [16 of UInt32] {
    fileprivate init(parsingLittleEndian input: borrowing RawSpan) {
        var input = copy input
        self.init { _ in
            UInt32(parsingLittleEndian: &input)
        }
    }
}

extension UInt32 {
    fileprivate init(parsingLittleEndian input: inout RawSpan) {
        self = Self(littleEndian: unsafe input.unsafeLoadUnaligned(as: Self.self))
        input = input.extracting(MemoryLayout<Self>.stride...)
    }
}
