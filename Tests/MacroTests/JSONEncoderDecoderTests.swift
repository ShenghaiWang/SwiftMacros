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

    func testEncodeErrorMacro() {
        assertMacroExpansion(
            """
            let data = #encode()
            """,
            expandedSource:
            """
            let data = #encode()
            """,
            diagnostics: [
                DiagnosticSpec(message: "Must specify the value to encode", line: 1, column: 12)
            ],
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

    func testDecodeErrorMacro() {
        assertMacroExpansion(
            """
            let data = #decode(from: data)
            """,
            expandedSource:
            """
            let data = #decode(from: data)
            """,
            diagnostics: [
                DiagnosticSpec(message: "Must specify the type and the value to decode", line: 1, column: 12)
            ],
            macros: testMacros
        )
    }
}
