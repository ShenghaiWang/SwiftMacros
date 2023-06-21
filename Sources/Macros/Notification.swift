import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct PostNotification: ExpressionMacro {
    public static func expansion<Node: FreestandingMacroExpansionSyntax,
                                 Context: MacroExpansionContext>(of node: Node,
                                                                 in context: Context) throws -> ExprSyntax {
        guard let name = node.argumentList.first(where: { $0.label == nil })?.expression else {
            throw MacroDiagnostics.errorMacroUsage(message: "Must specify a Notification name")
        }
        let object = node.argumentList.first(where: { $0.label?.text == "object" })?.expression
        let userInfo = node.argumentList.first(where: { $0.label?.text == "userInfo" })?.expression
        let notificationCenter = node.argumentList.first(where: { $0.label?.text == "from" })?.expression
        let expr: ExprSyntax =
        """
        \(notificationCenter ?? "NotificationCenter.default").post(name: \(name), object: \(object ?? "nil"), userInfo: \(userInfo ?? "nil"))
        """
        return expr
    }
}
