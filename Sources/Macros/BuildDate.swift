import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct BuildDate: ExpressionMacro {
    public static func expansion<Node: FreestandingMacroExpansionSyntax,
                                 Context: MacroExpansionContext>(of node: Node,
                                                                 in context: Context) throws -> ExprSyntax {
        guard node.arguments.count > 0 else {
            throw MacroDiagnostics.errorMacroUsage(message: "Must specify arguments")
        }

        let arguments = node.arguments.map {
            "\($0.expression)".trimmingCharacters(in: .whitespacesAndNewlines)
        }

        let expr: ExprSyntax =
        """
        buildDate {
            \(raw: arguments.joined(separator: "\n"))
        }
        """
        return ExprSyntax(expr)
    }
}
