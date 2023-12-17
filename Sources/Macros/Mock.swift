import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

import Foundation
public struct Mock: PeerMacro {
    public static func expansion<Context: MacroExpansionContext,
                                 Declaration: DeclSyntaxProtocol>(of node: AttributeSyntax,
                                                                  providingPeersOf declaration: Declaration,
                                                                  in context: Context) throws -> [DeclSyntax] {
        guard let initializer = declaration.as(InitializerDeclSyntax.self) else {
            throw MacroDiagnostics.errorMacroUsage(message: "Can only apply to an initializer")
        }
        guard let typeName = node.argument(for: "type")?.as(MemberAccessExprSyntax.self)?.base else {
            throw MacroDiagnostics.errorMacroUsage(message: "Must specify type name")
        }

        let randomValue = node.argument(for: "randomMockValue")?
            .as(BooleanLiteralExprSyntax.self)?.literal.tokenKind.keyword != .false
        let parameters = initializer.signature.parameterClause.parameters.compactMap { parameter -> String in
            let name = parameter.firstName
            let mockValue = parameter.type.mockValue(randomValue: randomValue) ?? "nil"
            return "\(name): \(mockValue)"
        }
        var varDelcaration: DeclSyntax = "static let mock = \(raw: typeName)(\(raw: parameters.joined(separator: ", ")))"
        varDelcaration = "\(initializer.modifiers)\(varDelcaration)"
        varDelcaration = "#if DEBUG\n\(varDelcaration)\n#endif"
        return [varDelcaration]
    }
}
