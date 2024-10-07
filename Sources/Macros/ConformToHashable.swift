import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct ConformToHashable: ExtensionMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax,
                                 attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
                                 providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
                                 conformingTo protocols: [SwiftSyntax.TypeSyntax],
                                 in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        guard [SwiftSyntax.SyntaxKind.classDecl].contains(declaration.kind) else {
            throw MacroDiagnostics.errorMacroUsage(message: "Can only be applied to a class type")
        }
        let equatableProtocol = InheritanceClauseSyntax(inheritedTypes: InheritedTypeListSyntax(
            arrayLiteral: InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "Hashable")))
        )

        let mambers = declaration.memberBlock.members.compactMap { member in
            if let patternBinding = member.decl.as(VariableDeclSyntax.self)?.bindings.first,
               let identifier = patternBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
               let type =  patternBinding.typeAnnotation?.type {
                if type.is(IdentifierTypeSyntax.self) {
                    return "hasher.combine(\(identifier))"
                }
                if let wrappedType = type.as(OptionalTypeSyntax.self)?.wrappedType,
                   wrappedType.is(IdentifierTypeSyntax.self) {
                    return "hasher.combine(\(identifier))"
                }
            }
            return nil
        }.joined(separator: "\n    ")

        let equtableFunction = """
        func hash(into hasher: inout Hasher) {
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
