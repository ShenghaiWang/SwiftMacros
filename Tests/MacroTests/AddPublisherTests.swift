import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class AddPublisherTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "AddPublisher": AddPublisher.self,
    ]

    func testAddPublisherPassthroughSubjectMacro() {
        assertMacroExpansion(
            """
            @AddPublisher
            private let subject = PassthroughSubject<Void, Never>()
            """,
            expandedSource:
            """

            private let subject = PassthroughSubject<Void, Never>()
            var subjectPublisher: AnyPublisher<Void, Never> {
                subject.eraseToAnyPublisher()
            }
            """,
            macros: testMacros
        )
    }

    func testAddPublisherOnCurrentValueSubjectMacro() {
        assertMacroExpansion(
            """
            @AddPublisher
            private let subject = CurrentValueSubject<Void, Never>(())
            """,
            expandedSource:
            """

            private let subject = CurrentValueSubject<Void, Never>(())
            var subjectPublisher: AnyPublisher<Void, Never> {
                subject.eraseToAnyPublisher()
            }
            """,
            macros: testMacros
        )
    }

    func testAddPublisherOnAlternativeSynatxMacro() {
        assertMacroExpansion(
            """
            @AddPublisher
            private let subject: CurrentValueSubject<Void, Never> = .init(())
            """,
            expandedSource:
            """

            private let subject: CurrentValueSubject<Void, Never> = .init(())
            var subjectPublisher: AnyPublisher<Void, Never> {
                subject.eraseToAnyPublisher()
            }
            """,
            macros: testMacros
        )
    }

    func testAddPublisherOnUnsupportedTypeMacro() {
        assertMacroExpansion(
            """
            @AddPublisher
            private let subject = MyStruct()
            """,
            expandedSource:
            """

            private let subject = MyStruct()
            """,
            diagnostics: [
                DiagnosticSpec(message: "Can only be applied to a subject(PassthroughSubject/CurrentValueSubject) variable declaration", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

    func testAddPublisherOnNotPrivateTypeMacro() {
        assertMacroExpansion(
            """
            @AddPublisher
            let subject = PassthroughSubject<Void, Never>()
            """,
            expandedSource:
            """

            let subject = PassthroughSubject<Void, Never>()
            """,
            diagnostics: [
                DiagnosticSpec(message: "Please make the subject private and use the automated generated publisher variable outsite of this type", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
}
