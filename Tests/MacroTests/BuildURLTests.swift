import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class BuildURLTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "buildURL": BuildURL.self,
    ]

    func testBuildURLMacro() {
        assertMacroExpansion(
            """
            let url = #buildURL("http://url.com",
                                URLScheme(.https),
                                URLFragment("fragment"),
                                URLQueryItems([.init(name: "q1", value: "q1v"), .init(name: "q2", value: "q2v")]))
            """,
            expandedSource:
            """
            let url = buildURL {
                "http://url.com"
                URLScheme(.https)
                URLFragment("fragment")
                URLQueryItems([.init(name: "q1", value: "q1v"), .init(name: "q2", value: "q2v")])
            }
            """,
            macros: testMacros
        )
    }
}
