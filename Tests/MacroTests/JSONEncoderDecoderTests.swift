import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class JSONEncoderDecoderTests: XCTestCase {
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
            let data = {
                let encoder = JSONEncoder()
                return try encoder.encode(TestStruct())
            }()
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

    func testEncodeWithDefaultValuesMacro() {
        assertMacroExpansion(
            """
            let data = #encode(TestStruct(), outputFormatting: [.prettyPrinted, .sortedKeys], dateEncodingStrategy: .iso8601, dataEncodingStrategy: .base64, userInfo: [TestKey: 0])
            """,
            expandedSource:
            """
            let data = {
                let encoder = JSONEncoder()
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                encoder.dateEncodingStrategy = .iso8601
                encoder.dataEncodingStrategy = .base64
                encoder.userInfo = [TestKey: 0]
                return try encoder.encode(TestStruct())
            }()
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
            let value = {
                let decoder = JSONDecoder()
                return try decoder.decode(TestStruct.self, from: data)
            }()
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

    func testDecodeWithDefaultValuesMacro() {
        assertMacroExpansion(
            """
            let data = #decode(TestStruct.self, from: data, dateDecodingStrategy: .iso8601, dataDecodingStrategy: .base64, userInfo: [TestKey: 0], allowsJSON5: true, assumesTopLevelDictionary: false)
            """,
            expandedSource:
            """
            let data = {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                decoder.dataDecodingStrategy = .base64
                decoder.userInfo = [TestKey: 0]
                decoder.allowsJSON5 = true
                return try decoder.decode(TestStruct.self, from: data)
            }()
            """,
            macros: testMacros
        )
    }
}
