import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct FormatDateInterval: ExpressionMacro {
    public static func expansion<Node: FreestandingMacroExpansionSyntax,
                                 Context: MacroExpansionContext>(of node: Node,
                                                                 in context: Context) throws -> ExprSyntax {
        guard let fromDate = node.argument(for: "from"),
              let toDate = node.argument(for: "to") else {
            throw MacroDiagnostics.errorMacroUsage(message: "Must specify dates")
        }

        let formatter: DeclSyntax = "let formatter = DateIntervalFormatter()"
        let formatterStatement = CodeBlockItemSyntax(item: .decl(formatter))
        let arguments = node.argumentList.dropFirst(2).compactMap { tupleExprElementSyntax in
            if let parameter = tupleExprElementSyntax.label?.text,
               !tupleExprElementSyntax.expression.is(NilLiteralExprSyntax.self) {
                let stmt: StmtSyntax = "\n    formatter.\(raw: parameter) = \(tupleExprElementSyntax.expression)"
                return CodeBlockItemSyntax(item: .stmt(stmt))
            }
            return nil
        }
        let returnValue: ExprSyntax = "\n    return formatter.string(from: \(fromDate), to: \(toDate))"
        let returnblock = CodeBlockItemSyntax(item: .expr(returnValue))
        let statementList = CodeBlockItemListSyntax([formatterStatement] + arguments + [returnblock])
        let closure = ClosureExprSyntax(statements: statementList)
        let function = FunctionCallExprSyntax(callee: closure)
        return ExprSyntax(function)
    }
}

extension FreestandingMacroExpansionSyntax {
    func argument(for label: String) -> ExprSyntax? {
        argumentList.as(LabeledExprListSyntax.self)?.filter({ $0.label?.text == label }).first?.expression
    }
}
