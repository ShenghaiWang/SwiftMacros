import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class AddInitTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "AddInit": AddInit.self,
    ]

    func testAddInitMacro() {
        assertMacroExpansion(
            """
            @AddInit
            struct A {
                let a: Int?
                let b: Int
            }
            """,
            expandedSource:
            """

            struct A {
                let a: Int?
                let b: Int
                init(a: Int? = nil, b: Int) {
                    self.a = a
                    self.b = b
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAddPublicInitMacro() {
        assertMacroExpansion(
            """
            @AddInit
            public struct A {
                let a: Int?
                let b: Int
            }
            """,
            expandedSource:
            """

            public struct A {
                let a: Int?
                let b: Int
                public init(a: Int? = nil, b: Int) {
                    self.a = a
                    self.b = b
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAddPublicInitClassMacro() {
        assertMacroExpansion(
            """
            @AddInit
            public class A {
                let a: Int?
                let b: Int
            }
            """,
            expandedSource:
            """

            public class A {
                let a: Int?
                let b: Int
                public init(a: Int? = nil, b: Int) {
                    self.a = a
                    self.b = b
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAddPublicInitClassClosureMacro() {
        assertMacroExpansion(
            """
            @AddInit
            public class A {
                let a: Int?
                let b: (Int) -> Void
            }
            """,
            expandedSource:
            """

            public class A {
                let a: Int?
                let b: (Int) -> Void
                public init(a: Int? = nil, b: @escaping (Int) -> Void) {
                    self.a = a
                    self.b = b
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAddPublicInitOptionalClosureMacro() {
        assertMacroExpansion(
            """
            @AddInit
            public class A {
                let a: Int?
                let b: ((Int) -> Void)?
            }
            """,
            expandedSource:
            """

            public class A {
                let a: Int?
                let b: ((Int) -> Void)?
                public init(a: Int? = nil, b: ((Int) -> Void)? = nil) {
                    self.a = a
                    self.b = b
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAddInitToActorMacro() {
        assertMacroExpansion(
            """
            @AddInit
            actor A {
                let a: Int
                let b: Int?
            }
            """,
            expandedSource:
            """

            actor A {
                let a: Int
                let b: Int?
                init(a: Int, b: Int? = nil) {
                    self.a = a
                    self.b = b
                }
            }
            """,
            macros: testMacros
        )
    }
}
