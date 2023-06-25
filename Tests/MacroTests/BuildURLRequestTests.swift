import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class BuildURLRequestTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "buildURLRequest": BuildURLRequest.self,
    ]

    func testBuildURLRequestMacro() {
        assertMacroExpansion(
            """
            let url = #buildURLRequest(URL(string: "http://google.com")!, RequestTimeOutInterval(100))
            """,
            expandedSource:
            """
            let url = buildURLRequest {
                URL(string: "http://google.com")!
                RequestTimeOutInterval(100)
            }
            """,
            macros: testMacros
        )
    }
}
