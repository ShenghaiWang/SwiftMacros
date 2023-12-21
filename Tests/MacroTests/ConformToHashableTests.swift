import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class ConformToHashableTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "ConformToHashable": ConformToHashable.self,
    ]

    func testConformToEquatableMacro() {
        assertMacroExpansion(
            """
            @ConformToHashable
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

            extension AClass: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(a)
                    hasher.combine(b)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testConformToEquatableIgnoreClosureTypeMacro() {
        assertMacroExpansion(
            """
            @ConformToHashable
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

            extension AClass: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(a)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testConformToEquatableIncludeOptionalTypeMacro() {
        assertMacroExpansion(
            """
            @ConformToHashable
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

            extension AClass: Hashable {
                func hash(into hasher: inout Hasher) {
                    hasher.combine(a)
                }
            }
            """,
            macros: testMacros
        )
    }
}
