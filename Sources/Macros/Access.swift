import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct Access: AccessorMacro {
    public static func expansion<Context: MacroExpansionContext,
                                 Declaration: DeclSyntaxProtocol>(of node: AttributeSyntax,
                                                                  providingAccessorsOf declaration: Declaration,
                                                                  in context: Context) throws -> [AccessorDeclSyntax] {
        guard let firstArg = node.argument?.as(TupleExprElementListSyntax.self)?.first,
              let type = firstArg.type else {
            throw MacroDiagnostics.errorMacroUsage(message: "Must specify a content type")
        }
        if type == "userDefaults",
           let dataType = node.attributeName.as(SimpleTypeIdentifierSyntax.self)?.type {
            return processUserDefaults(for: declaration,
                                       userDefaults: firstArg.userDefaults,
                                       type: "\(dataType)")
        } else if ["nsCache", "nsMapTable"].contains(type),
                  let object = firstArg.object,
                  let dataType = node.attributeName.as(SimpleTypeIdentifierSyntax.self)?.type {
            let isOptionalType = node.attributeName.as(SimpleTypeIdentifierSyntax.self)?.genericArgumentClause?.arguments
                .first?.as(GenericArgumentSyntax.self)?.argumentType.is(OptionalTypeSyntax.self) ?? false
            return processNSCacheAndNSMapTable(for: declaration,
                                               object: object,
                                               type: "\(dataType)",
                                               isOptionalType: isOptionalType)
        } else if type == "keychain" {
            return processKeychain(for: declaration)
        }

        return []
    }

    private static func processKeychain(for declaration: DeclSyntaxProtocol) -> [AccessorDeclSyntax] {
        guard let binding = declaration.as(VariableDeclSyntax.self)?.bindings.first,
              let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
              binding.accessor == nil else { return [] }
        let getAccessor: AccessorDeclSyntax =
          """
          get {
              try? SwiftKeychain.search(key: "AccessKey_\(raw: identifier)")
          }
          """

        let setAccessor: AccessorDeclSyntax =
          """
          set {
              if let value = newValue {
                  SwiftKeychain.delete(key: "AccessKey_\(raw: identifier)")
                  try? SwiftKeychain.add(value: value, for: "AccessKey_\(raw: identifier)")
              } else {
                  SwiftKeychain.delete(key: "AccessKey_\(raw: identifier)")
              }
          }
          """
        return [getAccessor, setAccessor]
    }

    private static func processUserDefaults(for declaration: DeclSyntaxProtocol,
                                            userDefaults: ExprSyntax,
                                            type: String) -> [AccessorDeclSyntax] {
        guard let binding = declaration.as(VariableDeclSyntax.self)?.bindings.first,
              let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
              binding.accessor == nil else { return [] }
        var defaultValue = ""
        if let value = binding.initializer?.value {
            defaultValue = " ?? \(value)"
        }
        let getAccessor: AccessorDeclSyntax =
          """
          get {
              (\(userDefaults).object(forKey: "AccessKey_\(raw: identifier)") as? \(raw: type))\(raw: defaultValue)
          }
          """

        let setAccessor: AccessorDeclSyntax =
          """
          set {
              \(userDefaults).set(newValue, forKey: "AccessKey_\(raw: identifier)")
          }
          """
        return [getAccessor, setAccessor]
    }

    private static func processNSCacheAndNSMapTable(for declaration: DeclSyntaxProtocol,
                                                    object: ExprSyntax,
                                                    type: String,
                                                    isOptionalType: Bool) -> [AccessorDeclSyntax] {
        guard let binding = declaration.as(VariableDeclSyntax.self)?.bindings.first,
              let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
              binding.accessor == nil else { return [] }
        var defaultValue = ""
        if let value = binding.initializer?.value {
            defaultValue = " ?? \(value)"
        }
        let getAccessor: AccessorDeclSyntax =
          """
          get {
              (\(object).object(forKey: "AccessKey_\(raw: identifier)") as? \(raw: type))\(raw: defaultValue)
          }
          """
        let setAccessor: AccessorDeclSyntax
        if isOptionalType {
            setAccessor =
          """
          set {
              if let value = newValue {
                  \(object).setObject(value, forKey: "AccessKey_\(raw: identifier)")
              } else {
                  \(object).removeObject(forKey: "AccessKey_\(raw: identifier)")
              }
          }
          """
        } else {
            setAccessor =
          """
          set {
              \(object).setObject(newValue, forKey: "AccessKey_\(raw: identifier)")
          }
          """
        }
        return [getAccessor, setAccessor]
    }
}

private extension TupleExprElementSyntax {
    var type: String? {
        expression.as(MemberAccessExprSyntax.self)?.name.text
        ?? expression.as(FunctionCallExprSyntax.self)?.calledExpression.as(MemberAccessExprSyntax.self)?.name.text
    }
}

private extension TupleExprElementSyntax {
    var userDefaults: ExprSyntax {
        if expression.is(MemberAccessExprSyntax.self) {
            return "UserDefaults.standard"
        }
        if let memeberAceess = expression.as(FunctionCallExprSyntax.self)?.argumentList.first?
            .as(TupleExprElementSyntax.self)?.expression.as(MemberAccessExprSyntax.self) {
            return "UserDefaults.\(raw: memeberAceess.name.text)"
        } else {
            return expression.as(FunctionCallExprSyntax.self)?.argumentList.first?.expression ?? "UserDefaults.standard"
        }
    }

    var object: ExprSyntax? {
        expression.as(FunctionCallExprSyntax.self)?.argumentList.first?.as(TupleExprElementSyntax.self)?.expression
    }
}

private extension SimpleTypeIdentifierSyntax {
    var type: SyntaxProtocol? {
        genericArgumentClause?.arguments.first?.as(GenericArgumentSyntax.self)?.argumentType.as(OptionalTypeSyntax.self)?.wrappedType
        ?? genericArgumentClause?.arguments.first?.as(GenericArgumentSyntax.self)
    }
}
