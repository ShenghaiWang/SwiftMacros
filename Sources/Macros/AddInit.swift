import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftUI

public struct AddInit: MemberMacro {
    public static func expansion<Declaration: DeclGroupSyntax,
                                 Context: MacroExpansionContext>(of node: AttributeSyntax,
                                                                 providingMembersOf declaration: Declaration,
                                                                 in context: Context) throws -> [DeclSyntax] {
        guard [SwiftSyntax.SyntaxKind.classDecl, .structDecl, .actorDecl].contains(declaration.kind) else {
            throw MacroDiagnostics.errorMacroUsage(message: "Can only be applied to a struct, class or actor")
        }
        let (parameters, body) = initBodyAndParams(for: declaration)
        let bodyExpr: ExprSyntax = "\(raw: body.joined(separator: "\n"))"
        var parametersLiteral = "init(\(parameters.joined(separator: ", ")))"
        if let modifiers = declaration.modifiers {
            parametersLiteral = "\(modifiers)\(parametersLiteral)"
        }
        let initDecl = try InitializerDeclSyntax(PartialSyntaxNodeString(stringLiteral: parametersLiteral),
                                                 bodyBuilder: { bodyExpr })
        var result = [DeclSyntax(initDecl)]
        if node.argument(for: "withMock")?.as(BooleanLiteralExprSyntax.self)?.booleanLiteral.tokenKind.keyword == .true {
            let randomValue = node.argument(for: "randomMockValue")?.as(BooleanLiteralExprSyntax.self)?
                .booleanLiteral.tokenKind.keyword != .false
            result.append(mock(basedOn: declaration, randomValue: randomValue))
        }
        return result
    }

    private static func initBodyAndParams(for declaration: DeclGroupSyntax) -> (params: [String], body: [String]) {
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
        return (params: parameters, body: body)
    }

    private static func mock(basedOn declaration: DeclGroupSyntax, randomValue: Bool) -> DeclSyntax {
        let identifier = (declaration as? StructDeclSyntax)?.identifier.text
        ?? (declaration as? ClassDeclSyntax)?.identifier.text
        ??  (declaration as? ActorDeclSyntax)?.identifier.text ?? ""
        var parameters: [String] = []
        declaration.memberBlock.members.forEach { member in
            if let patternBinding = member.decl.as(VariableDeclSyntax.self)?.bindings
                .as(PatternBindingListSyntax.self)?.first?.as(PatternBindingSyntax.self),
               let identifier = patternBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
               let type =  patternBinding.typeAnnotation?.as(TypeAnnotationSyntax.self)?.type {
                var parameter = "\(identifier): "
                if let mockValue = type.mockValue(randomValue: randomValue)
                    ?? type.as(OptionalTypeSyntax.self)?.mockValue(randomValue: randomValue)  {
                    parameter = "\(parameter)\(mockValue)"
                }
                parameters.append(parameter)
            }
        }
        var varDelcaration: DeclSyntax = "static let mock = \(raw: identifier)(\(raw: parameters.joined(separator: ", ")))"
        if let modifiers = declaration.modifiers {
            varDelcaration = "\(modifiers)varDelcaration"
        }
        varDelcaration = "#if DEBUG\n\(varDelcaration)\n#endif"
        return varDelcaration
    }
}

extension AttributeSyntax {
    func argument(for label: String) -> ExprSyntax? {
        argument?.as(TupleExprElementListSyntax.self)?.filter({ $0.label?.text == label }).first?.expression
    }
}

extension SimpleTypeIdentifierSyntax {
    func mockValue(randomValue: Bool) -> String? {
        guard let type = self.as(SimpleTypeIdentifierSyntax.self)?.name.text else { return nil }
        if let fun = mockFunctions[type] {
            return fun(randomValue)
        } else if name.text != "Set" {
            return "\(type).mock"
        }
        return nil
    }
}

extension OptionalTypeSyntax {
    func mockValue(randomValue: Bool) -> String? {
        if randomValue,
           let mockValue = wrappedType.mockValue(randomValue: randomValue) {
            return mockValue
        } else {
            return "nil"
        }
    }
}

extension FunctionTypeSyntax {
    func mockValue(randomValue: Bool) -> String? {
        let args = repeatElement("_", count: max(arguments.count, 1)).joined(separator: ", ")
        let returnValue = output.returnType.as(SimpleTypeIdentifierSyntax.self)?.mockValue(randomValue: randomValue) ?? ""
        return "{ \(args) in return \(returnValue) }"
    }
}

extension TypeSyntax {
    func mockValue(randomValue: Bool) -> String? {
        if let mockValue = self.as(SimpleTypeIdentifierSyntax.self)?.mockValue(randomValue: randomValue) {
            return mockValue
        } else if let type = self.as(DictionaryTypeSyntax.self) {
            let mockKeyValue = type.keyType.mockValue(randomValue: randomValue) ?? ""
            let mockValueValue = type.valueType.mockValue(randomValue: randomValue) ?? "nil"
            return "[\(mockKeyValue): \(mockValueValue)]"
        } else if let mockValue = self.as(FunctionTypeSyntax.self)?.mockValue(randomValue: randomValue) {
            return mockValue
        } else if let mockValue = self.as(TupleTypeSyntax.self)?.elements.first?.type
            .as(FunctionTypeSyntax.self)?.mockValue(randomValue: randomValue) {
            return mockValue
        } else if let type = self.as(ArrayTypeSyntax.self)?.elementType {
            return "[" + (type.mockValue(randomValue: randomValue) ?? "nil") + "]"
        } else if let type = self.as(SimpleTypeIdentifierSyntax.self),
                  type.name.text == "Set",
                  let genericType = type.genericArgumentClause?.arguments.first?.argumentType {
            return "[" + (genericType.mockValue(randomValue: randomValue) ?? "nil") + "]"
        }
        return nil
    }
}
