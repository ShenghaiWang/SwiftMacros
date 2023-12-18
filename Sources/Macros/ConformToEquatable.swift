import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct ConformToEquatable: ExtensionMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, 
                                 attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
                                 providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
                                 conformingTo protocols: [SwiftSyntax.TypeSyntax],
                                 in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        guard [SwiftSyntax.SyntaxKind.classDecl].contains(declaration.kind) else {
            throw MacroDiagnostics.errorMacroUsage(message: "Can only be applied to a class type")
        }
        let equatableProtocol = InheritanceClauseSyntax(inheritedTypes: InheritedTypeListSyntax(
            arrayLiteral: InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "Equatable")))
        )

        let mambers = declaration.memberBlock.members.compactMap { member in
            if let patternBinding = member.decl.as(VariableDeclSyntax.self)?.bindings
                .as(PatternBindingListSyntax.self)?.first?.as(PatternBindingSyntax.self),
               let identifier = patternBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
               let type =  patternBinding.typeAnnotation?.as(TypeAnnotationSyntax.self)?.type {
                if type.is(IdentifierTypeSyntax.self) {
                    return "lhs.\(identifier) == rhs.\(identifier)"
                }
                if let wrappedType = type.as(OptionalTypeSyntax.self)?.wrappedType,
                   wrappedType.is(IdentifierTypeSyntax.self) {
                    return "lhs.\(identifier) == rhs.\(identifier)"
                }
            }
            return nil
        }.joined(separator: "\n    && ")

        let equtableFunction = """
        static func == (lhs: \(type), rhs: \(type)) -> Bool {
            \(mambers)
        }
        """

        let member = MemberBlockSyntax(members: MemberBlockItemListSyntax(stringLiteral: equtableFunction))
        let extensionDecl = ExtensionDeclSyntax(extendedType: type,
                                                inheritanceClause: equatableProtocol,
                                                memberBlock: member)
        return [extensionDecl]
    }
}
