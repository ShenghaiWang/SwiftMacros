import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class JSONEncoderDecoder: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "encode": Encode.self,
        "decode": Decode.self
    ]

    func testEncodeMacro() {
        assertMacroExpansion(
            """
            let data = #encode(TestStruct())
            """,
            expandedSource:
            """
            let data = JSONEncoder().encode(TestStruct())
            """,
            macros: testMacros
        )
    }

    func testDecodeMacro() {
        assertMacroExpansion(
            """
            let value = #decode(TestStruct.self, from: data)
            """,
            expandedSource:
            """
            let value = JSONDecoder().decode(TestStruct.self, from: data)
            """,
            macros: testMacros
        )
    }
}
