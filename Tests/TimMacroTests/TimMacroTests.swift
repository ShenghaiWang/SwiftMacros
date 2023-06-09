import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import TimMacroMacros

let testMacros: [String: Macro.Type] = [
    "singleton": Singleton.self,
]

final class TimMacroTests: XCTestCase {
    func testSingletonMacro() {
        assertMacroExpansion(
            """
            @singleton
            struct A {}
            """,
            expandedSource: """
            
            struct A {
                private init() {
                }
                static let shared = Self ()
            }
            """,
            macros: testMacros
        )
    }

    func testPublicSingletonMacro() {
        assertMacroExpansion(
            """
            @singleton
            public struct A {}
            """,
            expandedSource: """

            public struct A {
                private init() {
                }
                public static let shared = Self ()
            }
            """,
            macros: testMacros
        )
    }
}
