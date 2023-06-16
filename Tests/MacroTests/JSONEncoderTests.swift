import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class JSONEncoderDecoder: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "encode": Encode.self
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
}
