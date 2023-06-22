import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AddAssociatedValueVariable: MemberMacro {
    public static func expansion<Declaration: DeclGroupSyntax,
                                 Context: MacroExpansionContext>(of node: AttributeSyntax,
                                                                 providingMembersOf declaration: Declaration,
                                                                 in context: Context) throws -> [DeclSyntax] {
        guard let members = declaration.as(EnumDeclSyntax.self)?
            .memberBlock.members.compactMap({ $0.decl.as(EnumCaseDeclSyntax.self)?.elements }) else {
            throw MacroDiagnostics.errorMacroUsage(message: "Can only be applied to an Enum type")
        }
        var result: [DeclSyntax] = []

        try members.forEach { list in
            try list.forEach { element in
                if let associatedValue = element.associatedValue {
                    let typeValue: String
                    if associatedValue.parameterList.isOneSimpleTypeIdentifierSyntax {
                        typeValue = "\(associatedValue.parameterList.first ?? "")"
                    } else {
                        typeValue = "\(associatedValue)"
                    }
                    var isPublic = ""
                    if declaration.modifiers?.compactMap(\.name.tokenKind.keyword).contains(.public) ?? false {
                        isPublic = "public "
                    }
                    let varSyntax = try VariableDeclSyntax("\(raw: isPublic)var \(element.identifier)Value: \(raw: typeValue)?") {
                        try IfExprSyntax(
                            "if case let .\(element.identifier)(\(raw: associatedValue.parameterList.toVariableNames)) = self",
                               bodyBuilder: {
                                   if associatedValue.parameterList.count == 1 {
                                       StmtSyntax("return \(raw: associatedValue.parameterList.toVariableNames)")
                                   } else {
                                       StmtSyntax("return (\(raw: associatedValue.parameterList.toVariableNames))")
                                   }
                               })
                        StmtSyntax(#"return nil"#)
                    }
                    result.append(DeclSyntax(varSyntax))
                }
            }
        }
        return result
    }
}

extension EnumCaseParameterListSyntax {
    var toVariableNames: String {
        (0..<count).map { "v\($0)" }.joined(separator: ", ")
    }

    var isOneSimpleTypeIdentifierSyntax: Bool {
        count == 1 && (first?.type.is(SimpleTypeIdentifierSyntax.self) ?? false)
    }
}
