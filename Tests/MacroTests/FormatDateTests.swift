import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class FormateDateTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "formatDate": FormatDate.self,
    ]

    func testFormateDateMacro() {
        assertMacroExpansion(
            """
            let date = #formatDate(Date(), dateStyle: .full)
            """,
            expandedSource:
            """
            let date = {
                let formatter = DateFormatter()
                formatter.dateStyle = .full
                return formatter.string(from: Date())
            }()
            """,
            macros: testMacros
        )
    }
}
