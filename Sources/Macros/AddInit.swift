import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AddInit: MemberMacro {
    public static func expansion<Declaration: DeclGroupSyntax,
                                 Context: MacroExpansionContext>(of node: AttributeSyntax,
                                                                 providingMembersOf declaration: Declaration,
                                                                 in context: Context) throws -> [DeclSyntax] {
        guard [SwiftSyntax.SyntaxKind.classDecl, .structDecl, .actorDecl].contains(declaration.kind) else {
            throw MacroDiagnostics.errorMacroUsage(message: "Can only be applied to a struct, class or actor")
        }
        var parameters: [String] = []
        var body: [String] = []
        declaration.memberBlock.members.forEach { member in
            if let patternBinding = member.decl.as(VariableDeclSyntax.self)?.bindings
                .as(PatternBindingListSyntax.self)?.first?.as(PatternBindingSyntax.self),
               let identifier = patternBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
               let type =  patternBinding.typeAnnotation?.as(TypeAnnotationSyntax.self)?.type {
                var parameter = "\(identifier): "
                if type.is(FunctionTypeSyntax.self) {
                    parameter += "@escaping "
                }

                parameter += "\(type)"
                if type.is(OptionalTypeSyntax.self) {
                    parameter += " = nil"
                }
                parameters.append(parameter)

                body.append("self.\(identifier) = \(identifier)")
            }
        }
        let bodyExpr: ExprSyntax = "\(raw: body.joined(separator: "\n"))"
        var parametersLiteral = "init(\(parameters.joined(separator: ", ")))"
        if let modifiers = declaration.modifiers {
            parametersLiteral = "\(modifiers)\(parametersLiteral)"
        }
        let initDecl = try InitializerDeclSyntax(PartialSyntaxNodeString(stringLiteral: parametersLiteral),
                                                 bodyBuilder: { bodyExpr }
        )

        return [DeclSyntax(initDecl)]
    }
}
