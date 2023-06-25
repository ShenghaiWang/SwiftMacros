import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class FormatDateComponentsTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "formatDateComponents": FormatDateComponents.self,
    ]

    func testFormatDateComponentsFromToMacro() {
        assertMacroExpansion(
            """
            let date = #formatDateComponents(from: Date(), to: Date(), allowedUnits: [.day, .hour, .minute, .second])
            """,
            expandedSource:
            """
            let date = {
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.day, .hour, .minute, .second]
                return formatter.string(from: Date(), to: Date())
            }()
            """,
            macros: testMacros
        )
    }

    func testFormatDateComponentsFromTimeintervalMacro() {
        assertMacroExpansion(
            """
            let date = #formatDateComponents(fromInterval: 100, allowedUnits: [.day, .hour, .minute, .second])
            """,
            expandedSource:
            """
            let date = {
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.day, .hour, .minute, .second]
                return formatter.string(from: 100)
            }()
            """,
            macros: testMacros
        )
    }

    func testFormatDateComponentsFromComponentsMacro() {
        assertMacroExpansion(
            """
            let date = #formatDateComponents(fromComponents: DateComponents(hour: 10), allowedUnits: [.day, .hour, .minute, .second])
            """,
            expandedSource:
            """
            let date = {
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.day, .hour, .minute, .second]
                return formatter.string(from: DateComponents(hour: 10))
            }()
            """,
            macros: testMacros
        )
    }
}
