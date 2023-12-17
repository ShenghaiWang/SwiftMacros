import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct AddPublisher: PeerMacro {
    public static func expansion<Context: MacroExpansionContext,
                                 Declaration: DeclSyntaxProtocol>(of node: AttributeSyntax,
                                                                  providingPeersOf declaration: Declaration,
                                                                  in context: Context) throws -> [DeclSyntax] {
        guard let variableDecl = declaration.as(VariableDeclSyntax.self),
              variableDecl.modifiers.map({ $0.name.text }).contains("private") else {
                  throw MacroDiagnostics.errorMacroUsage(message: "Please make the subject private and use the automated generated publisher variable outsite of this type")
              }
        guard let binding = variableDecl.bindings.first,
              let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
              let genericArgumentClause = binding.genericArgumentClause,
              ["PassthroughSubject", "CurrentValueSubject"].contains(binding.typeName) else {
            throw MacroDiagnostics.errorMacroUsage(message: "Can only be applied to a subject(PassthroughSubject/CurrentValueSubject) variable declaration")
        }

        let publisher: DeclSyntax =
        """
        var \(raw: identifier.text)Publisher: AnyPublisher<\(genericArgumentClause.arguments)> {
            \(raw: identifier.text).eraseToAnyPublisher()
        }
        """
        return [publisher]
    }
}

extension PatternBindingListSyntax.Element {
    var genericArgumentClause: GenericArgumentClauseSyntax? {
        initializer?.value.as(FunctionCallExprSyntax.self)?
            .calledExpression.as(GenericSpecializationExprSyntax.self)?
            .genericArgumentClause
        ?? typeAnnotation?.type.as(IdentifierTypeSyntax.self)?.genericArgumentClause
    }

    var typeName: String? {
        initializer?.value.as(FunctionCallExprSyntax.self)?.calledExpression.as(GenericSpecializationExprSyntax.self)?.expression.as(DeclReferenceExprSyntax.self)?.baseName.text
        ?? typeAnnotation?.type.as(IdentifierTypeSyntax.self)?.name.text
    }
}
