import Blobby
import MD4
import Testing

@Test(arguments: `md4.blb`)
func `md4.blb`(testVector: TestVector) {
    #expect(MD4.hash(testVector.message.span.bytes).elementsEqual(testVector.expected))
}

@Test(arguments: `md4.blb`)
func `md4.blb split messages`(testVector: TestVector) {
    let count = Int.random(in: 0...testVector.message.count)
    let prefix = testVector.message.prefix(count)
    let suffix = testVector.message.dropFirst(count)

    var hasher = MD4()
    hasher.update(with: prefix.span.bytes)
    hasher.update(with: suffix.span.bytes)
    #expect(hasher.finalized().elementsEqual(testVector.expected))
}
