import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class NotificationTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "postNotification": PostNotification.self,
    ]

    func testPostNotificationWithNameMacro() {
        assertMacroExpansion(
            """
            #postNotification(.NSCalendarDayChanged)
            """,
            expandedSource:
            """
            NotificationCenter.default.post(name: .NSCalendarDayChanged, object: nil, userInfo: nil)
            """,
            macros: testMacros
        )
    }

    func testPostNotificationWithNameAndCenterMacro() {
        assertMacroExpansion(
            """
            #postNotification(.NSCalendarDayChanged, from: NotificationCenter())
            """,
            expandedSource:
            """
            NotificationCenter().post(name: .NSCalendarDayChanged, object: nil, userInfo: nil)
            """,
            macros: testMacros
        )
    }

    func testPostNotificationWithNameWithUserInfoMacro() {
        assertMacroExpansion(
            """
            #postNotification(.NSCalendarDayChanged, userInfo: ["value": 0])
            """,
            expandedSource:
            """
            NotificationCenter.default.post(name: .NSCalendarDayChanged, object: nil, userInfo: ["value": 0])
            """,
            macros: testMacros
        )
    }

    func testPostNotificationWithNameWithObjectMacro() {
        assertMacroExpansion(
            """
            #postNotification(.NSCalendarDayChanged, object: NSObject())
            """,
            expandedSource:
            """
            NotificationCenter.default.post(name: .NSCalendarDayChanged, object: NSObject(), userInfo: nil)
            """,
            macros: testMacros
        )
    }
}
