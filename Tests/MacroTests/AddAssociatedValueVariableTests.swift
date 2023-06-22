import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class AddAssociatedValueVairiableTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "AddAssociatedValueVariable": AddAssociatedValueVariable.self,
    ]

    func testdAssociatedValueVairiableMacro() {
        assertMacroExpansion(
            """
            @AddAssociatedValueVariable
            enum A {
                case first
                case second(Int)
                case third(String, Int), third2(String, Int)
                case forth(a: String, b: Int)
                case fifth(a: String, Int)
                case sixth(a: () -> Void)
                case seventh(() -> Void)
            }
            """,
            expandedSource:
            """

            enum A {
                case first
                case second(Int)
                case third(String, Int), third2(String, Int)
                case forth(a: String, b: Int)
                case fifth(a: String, Int)
                case sixth(a: () -> Void)
                case seventh(() -> Void)
                var secondValue: Int? {
                    if case let .second(v0) = self {
                        return v0
                    }
                    return nil
                }
                var thirdValue: (String, Int)? {
                    if case let .third(v0, v1) = self {
                        return (v0, v1)
                    }
                    return nil
                }
                var third2Value: (String, Int)? {
                    if case let .third2(v0, v1) = self {
                        return (v0, v1)
                    }
                    return nil
                }
                var forthValue: (a: String, b: Int)? {
                    if case let .forth(v0, v1) = self {
                        return (v0, v1)
                    }
                    return nil
                }
                var fifthValue: (a: String, Int)? {
                    if case let .fifth(v0, v1) = self {
                        return (v0, v1)
                    }
                    return nil
                }
                var sixthValue: (a: () -> Void)? {
                    if case let .sixth(v0) = self {
                        return v0
                    }
                    return nil
                }
                var seventhValue: (() -> Void)? {
                    if case let .seventh(v0) = self {
                        return v0
                    }
                    return nil
                }
            }
            """,
            macros: testMacros
        )
    }

    func testdAssociatedValueVairiableModifierMacro() {
        assertMacroExpansion(
            """
            @AddAssociatedValueVariable
            public enum A {
                case first
                case second(Int)
            }
            """,
            expandedSource:
            """

            public enum A {
                case first
                case second(Int)
                public var secondValue: Int? {
                    if case let .second(v0) = self {
                        return v0
                    }
                    return nil
                }
            }
            """,
            macros: testMacros
        )
    }
}
