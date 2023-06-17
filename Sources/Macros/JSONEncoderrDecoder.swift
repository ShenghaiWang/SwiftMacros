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

public struct Decode: ExpressionMacro {
    public static func expansion<Node: FreestandingMacroExpansionSyntax,
                                 Context: MacroExpansionContext>(of node: Node,
                                                                 in context: Context) throws -> ExprSyntax {
        guard node.argumentList.count == 2,
              let type = node.argumentList.first?.expression,
              let data = node.argumentList.last?.expression else {
            throw MacroDiagnostics.errorMacroUsage(message: "Must specify the type and the value to decode")
        }

        return "JSONDecoder().decode(\(type), from: \(data))"
    }
}
