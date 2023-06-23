import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct BuildURLRequest: ExpressionMacro {
    public static func expansion<Node: FreestandingMacroExpansionSyntax,
                                 Context: MacroExpansionContext>(of node: Node,
                                                                 in context: Context) throws -> ExprSyntax {
        guard node.argumentList.count > 0 else {
            throw MacroDiagnostics.errorMacroUsage(message: "Must specify arguments")
        }

        let arguments = node.argumentList.map {
            "\($0.expression)".trimmingCharacters(in: .whitespacesAndNewlines)
        }

        let expr: ExprSyntax =
        """
        buildURLRequest {
            \(raw: arguments.joined(separator: "\n"))
        }
        """
        return ExprSyntax(expr)
    }
}
