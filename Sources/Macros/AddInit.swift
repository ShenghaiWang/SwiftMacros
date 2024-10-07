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
        parametersLiteral = "\(declaration.modifiers)\(parametersLiteral)"
        let initDecl = try InitializerDeclSyntax(SyntaxNodeString(stringLiteral: parametersLiteral),
                                                 bodyBuilder: { bodyExpr })
        var result = [DeclSyntax(initDecl)]
        if node.argument(for: "withMock")?.as(BooleanLiteralExprSyntax.self)?.literal.tokenKind.keyword == .true {
            let randomValue = node.argument(for: "randomMockValue")?.as(BooleanLiteralExprSyntax.self)?
                .literal.tokenKind.keyword != .false
            result.append(mock(basedOn: declaration, randomValue: randomValue))
        }
        return result
    }

    private static func initBodyAndParams(for declaration: DeclGroupSyntax) -> (params: [String], body: [String]) {
        var parameters: [String] = []
        var body: [String] = []
        declaration.memberBlock.members.forEach { member in
            if let patternBinding = member.decl.as(VariableDeclSyntax.self)?.bindings.first,
               let identifier = patternBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
               let type =  patternBinding.typeAnnotation?.type,
               patternBinding.accessorBlock == nil {
                var parameter = "\(identifier): "
                if type.is(FunctionTypeSyntax.self) {
                    parameter += "@escaping "
                }
                parameter += "\(type)"
                if type.is(OptionalTypeSyntax.self) {
                    parameter += " = nil"
                }
                parameters.append(parameter)
                body.append("    self.\(identifier) = \(identifier)")
            }
        }
        return (params: parameters, body: body)
    }

    private static func mock(basedOn declaration: DeclGroupSyntax, randomValue: Bool) -> DeclSyntax {
        let identifier = (declaration as? StructDeclSyntax)?.name.text
        ?? (declaration as? ClassDeclSyntax)?.name.text
        ??  (declaration as? ActorDeclSyntax)?.name.text ?? ""
        let parameters = declaration.memberBlock.members.compactMap { member -> String? in
            guard let patternBinding = member.decl.as(VariableDeclSyntax.self)?.bindings.first,
                  let identifier = patternBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
                  let type =  patternBinding.typeAnnotation?.type,
                  patternBinding.accessorBlock == nil else { return nil }
            let mockValue = type.mockValue(randomValue: randomValue)
            ?? type.as(OptionalTypeSyntax.self)?.mockValue(randomValue: randomValue)
            ?? "nil"
            return "\(identifier): \(mockValue)"
        }
        var varDelcaration: DeclSyntax = "static let mock = \(raw: identifier)(\(raw: parameters.joined(separator: ", ")))"
        varDelcaration = "\(declaration.modifiers)\(varDelcaration)"
        varDelcaration = "#if DEBUG\n\(varDelcaration)\n#endif"
        return varDelcaration
    }
}

extension AttributeSyntax {
    func argument(for label: String) -> ExprSyntax? {
        arguments?.as(LabeledExprListSyntax.self)?.filter({ $0.label?.text == label }).first?.expression
    }
}

extension IdentifierTypeSyntax {
    func mockValue(randomValue: Bool) -> String? {
        let mockFunctions: [String: @Sendable (Bool) -> String] = {
            let common = [
                "Int": Int.mock(random:),
                "Int8": Int8.mock(random:),
                "Int32": Int32.mock(random:),
                "Int64": Int64.mock(random:),
                "UInt": UInt.mock(random:),
                "UInt32": UInt32.mock(random:),
                "UInt64": UInt64.mock(random:),
                "UInt8": UInt8.mock(random:),
                "Bool": Bool.mock(random:),
                "String": String.mock(random:),
                "Double": Double.mock(random:),
                "Float": Float.mock(random:),
                "Character": Character.mock(random:),
                "CharacterSet": CharacterSet.mock(random:),
            ]
            if #available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *) {
                return common.merging(["Image": Image.mock(random:)]) { first, _ in first }
            } else {
                return common
            }
        }()
        let type = self.name.text
        if let fun = mockFunctions[type] {
            return fun(randomValue)
        } else if name.text == "Void" {
            return "return"
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
        let args = repeatElement("_", count: max(parameters.count, 1)).joined(separator: ", ")
        let returnValue = returnClause.type.mockValue(randomValue: randomValue) ?? ""
        return "{ \(args) in return \(returnValue) }"
    }
}

extension TypeSyntax {
    func mockValue(randomValue: Bool) -> String? {
        if let mockValue = self.as(IdentifierTypeSyntax.self)?.mockValue(randomValue: randomValue) {
            return mockValue
        } else if let type = self.as(DictionaryTypeSyntax.self) {
            let mockKeyValue = type.key.mockValue(randomValue: randomValue) ?? ""
            let mockValueValue = type.value.mockValue(randomValue: randomValue) ?? "nil"
            return "[\(mockKeyValue): \(mockValueValue)]"
        } else if let mockValue = self.as(FunctionTypeSyntax.self)?.mockValue(randomValue: randomValue) {
            return mockValue
        } else if let mockValue = self.as(TupleTypeSyntax.self)?.elements.first?.type
            .as(FunctionTypeSyntax.self)?.mockValue(randomValue: randomValue) {
            return mockValue
        } else if let type = self.as(ArrayTypeSyntax.self)?.element {
            return "[" + (type.mockValue(randomValue: randomValue) ?? "nil") + "]"
        } else if let type = self.as(IdentifierTypeSyntax.self),
                  type.name.text == "Set",
                  let genericType = type.genericArgumentClause?.arguments.first?.argument {
            return "[" + (genericType.mockValue(randomValue: randomValue) ?? "nil") + "]"
        }
        return nil
    }
}
