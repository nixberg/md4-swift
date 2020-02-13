import XCTest
@testable import MD4

final class SHA1Tests: XCTestCase {
    func test() {
        XCTAssertEqual(MD4.hash(""), "31d6cfe0d16ae931b73c59d7e0c089c0")
        XCTAssertEqual(MD4.hash("a"), "bde52cb31de33e46245e05fbdbd6fb24")
        XCTAssertEqual(MD4.hash("abc"), "a448017aaf21d8525fc10ae87aa6729d")
        XCTAssertEqual(MD4.hash("message digest"), "d9130a8164549fe818874806e1c7014b")
        XCTAssertEqual(MD4.hash("abcdefghijklmnopqrstuvwxyz"), "d79e1c308aa5bbcdeea8ed63df412da9")
        XCTAssertEqual(
            MD4.hash("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"),
            "043f8582f241db351ce627e153e7f0e4"
        )
        XCTAssertEqual(
            MD4.hash("12345678901234567890123456789012345678901234567890123456789012345678901234567890"),
            "e33b4ddc9c38f2199c3e7b164fcc0536"
        )
    }
}

fileprivate extension DataProtocol {
    func hex() -> String {
        self.map { String(format: "%02hhx", $0) }.joined()
    }
}

fileprivate extension MD4 {
    static func hash(_ input: String) -> String {
        Self.hash(ArraySlice(input.utf8)).hex()
    }
}
