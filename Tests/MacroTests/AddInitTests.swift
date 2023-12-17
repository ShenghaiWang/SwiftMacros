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

    func testAddInitWithMockMacro() {
        assertMacroExpansion(
            """
            @AddInit(withMock: true, randomMockValue: false)
            actor A {
                let a: Int
                let b: Int?
                let c: (Int) -> Int
            }
            """,
            expandedSource:
            """

            actor A {
                let a: Int
                let b: Int?
                let c: (Int) -> Int

                init(a: Int, b: Int? = nil, c: @escaping (Int) -> Int) {
                    self.a = a
                    self.b = b
                    self.c = c
                }

                #if DEBUG
                static let mock = A(a: 1, b: nil, c: { _ in
                        return 1
                    })
                #endif
            }
            """,
            macros: testMacros
        )
    }

    func testAddInitWithMockCollectionTypesMacro() {
        assertMacroExpansion(
            """
            @AddInit(withMock: true, randomMockValue: false)
            actor A {
                let a: [Int]
                let b: Set<Int>
                let c: [Int: String]
            }
            """,
            expandedSource:
            """

            actor A {
                let a: [Int]
                let b: Set<Int>
                let c: [Int: String]

                init(a: [Int], b: Set<Int>, c: [Int: String]) {
                    self.a = a
                    self.b = b
                    self.c = c
                }

                #if DEBUG
                static let mock = A(a: [1], b: [1], c: [1: "abcd"])
                #endif
            }
            """,
            macros: testMacros
        )
    }

    func testAddInitWithCustomisedTypesMacro() {
        assertMacroExpansion(
            """
            struct A {
                let a: Int
            }
            @AddInit(withMock: true, randomMockValue: false)
            struct B {
                let a: A
            }
            """,
            expandedSource:
            """
            struct A {
                let a: Int
            }
            struct B {
                let a: A

                init(a: A) {
                    self.a = a
                }
            
                #if DEBUG
                static let mock = B(a: A.mock)
                #endif
            }
            """,
            macros: testMacros
        )
    }
}
