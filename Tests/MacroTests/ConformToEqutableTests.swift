import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class ConformToEqutableTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "ConformToEquatable": ConformToEquatable.self,
    ]

    func testConformToEquatableMacro() {
        assertMacroExpansion(
            """
            @ConformToEquatable
            class AClass {
                let a: Int
                let b: Int
                init(a: Int, b: Int) {
                    self.a = a
                    self.b = b
                }
            }
            """,
            expandedSource:
            """
            class AClass {
                let a: Int
                let b: Int
                init(a: Int, b: Int) {
                    self.a = a
                    self.b = b
                }
            }

            extension AClass: Equatable {
                static func == (lhs: AClass, rhs: AClass) -> Bool {
                    lhs.a == rhs.a
                    && lhs.b == rhs.b
                }
            }
            """,
            macros: testMacros
        )
    }

    func testConformToEquatableIgnoreClosureTypeMacro() {
        assertMacroExpansion(
            """
            @ConformToEquatable
            class AClass {
                let a: Int
                let b: (Int) -> Void
                init(a: Int, b: (Int) -> Void) {
                    self.a = a
                    self.b = b
                }
            }
            """,
            expandedSource:
            """
            class AClass {
                let a: Int
                let b: (Int) -> Void
                init(a: Int, b: (Int) -> Void) {
                    self.a = a
                    self.b = b
                }
            }

            extension AClass: Equatable {
                static func == (lhs: AClass, rhs: AClass) -> Bool {
                    lhs.a == rhs.a
                }
            }
            """,
            macros: testMacros
        )
    }

    func testConformToEquatableIncludeOptionalTypeMacro() {
        assertMacroExpansion(
            """
            @ConformToEquatable
            class AClass {
                let a: Int?
                init(a: Int?) {
                    self.a = a
                }
            }
            """,
            expandedSource:
            """
            class AClass {
                let a: Int?
                init(a: Int?) {
                    self.a = a
                }
            }

            extension AClass: Equatable {
                static func == (lhs: AClass, rhs: AClass) -> Bool {
                    lhs.a == rhs.a
                }
            }
            """,
            macros: testMacros
        )
    }
}
