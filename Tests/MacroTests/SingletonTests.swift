import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class SingletonTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "Singleton": Singleton.self,
    ]

    func testSingletonMacro() {
        assertMacroExpansion(
            """
            @Singleton
            struct A {}
            """,
            expandedSource:
            """

            struct A {
                private init() {
                }
                static let shared = A()
            }
            """,
            macros: testMacros
        )
    }

    func testPublicSingletonMacro() {
        assertMacroExpansion(
            """
            @Singleton
            public struct A {}
            """,
            expandedSource:
            """

            public struct A {
                private init() {
                }
                public static let shared = A()
            }
            """,
            macros: testMacros
        )
    }

    func testSingletonErrorMacro() {
        assertMacroExpansion(
            """
            @Singleton
            enum A {}
            """,
            expandedSource:
            """

            enum A {
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "Can only be applied to a struct or class", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

    func testSingletonNSObjectMacro() {
        assertMacroExpansion(
            """
            @Singleton
            class A: NSObject {}
            """,
            expandedSource:
            """

            class A: NSObject {
                private override init() {
                }
                static let shared = A()
            }
            """,
            macros: testMacros
        )
    }
}
