import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class FormatDateIntervalTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "formatDateInterval": FormatDateInterval.self,
    ]

    func testFormatDateIntervalMacro() {
        assertMacroExpansion(
            """
            let date = #formatDateInterval(from: Date(), to: Date(), dateStyle: .short)
            """,
            expandedSource:
            """
            let date = {
                let formatter = DateIntervalFormatter()
                formatter.dateStyle = .short
                return formatter.string(from: Date(), to: Date())
            }()
            """,
            macros: testMacros
        )
    }
}
