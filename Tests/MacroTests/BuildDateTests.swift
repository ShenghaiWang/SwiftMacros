import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class BuildDateTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "buildDate": BuildDate.self,
    ]

    func testBuildDateMacro() {
        assertMacroExpansion(
            """
            let date = #buildDate(DateString("03/05/2003", dateFormat: "MM/dd/yyyy"),
                      Date(),
                      Month(10),
                      Year(1909),
                      YearForWeekOfYear(2025))
            """,
            expandedSource:
            """
            let date = buildDate {
                DateString("03/05/2003", dateFormat: "MM/dd/yyyy")
                Date()
                Month(10)
                Year(1909)
                YearForWeekOfYear(2025)
            }
            """,
            macros: testMacros
        )
    }
}
