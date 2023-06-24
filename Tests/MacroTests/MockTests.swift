import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class MockTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "Mock": Mock.self,
    ]

    func testMockMacro() {
        assertMacroExpansion(
            """
            struct AStruct {
                let a: Int

                @Mock(typeName: "AStruct", randomMockValue: false)
                init(a: Int) {
                    self.a = a
                }
            }
            """,
            expandedSource:
            """
            struct AStruct {
                let a: Int
                init(a: Int) {
                    self.a = a
                }
                #if DEBUG
                static let mock = AStruct(a: 1)
                #endif
            }
            """,
            macros: testMacros
        )
    }
}
