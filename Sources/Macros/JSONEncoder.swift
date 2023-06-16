import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct Encode: ExpressionMacro {
    public static func expansion<Node: FreestandingMacroExpansionSyntax,
                          Context: MacroExpansionContext>(of node: Node,
                                                          in context: Context) throws -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            throw MacroDiagnostics.errorMacroUsage(message: "Must specify the value to encode")
        }

        return "JSONEncoder().encode(\(argument))"
    }
}
