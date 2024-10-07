import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct FormatDate: ExpressionMacro {
    public static func expansion<Node: FreestandingMacroExpansionSyntax,
                                 Context: MacroExpansionContext>(of node: Node,
                                                                 in context: Context) throws -> ExprSyntax {
        guard let date = node.arguments.first else {
            throw MacroDiagnostics.errorMacroUsage(message: "Must specify arguments")
        }

        let formatter: DeclSyntax = "let formatter = DateFormatter()"
        let formatterStatement = CodeBlockItemSyntax(item: .decl(formatter))
        let arguments = node.arguments.filter { $0.label != nil }
            .compactMap { tupleExprElementSyntax in
                if let parameter = tupleExprElementSyntax.label?.text,
                   !tupleExprElementSyntax.expression.is(NilLiteralExprSyntax.self) {
                    let stmt: StmtSyntax = "\n    formatter.\(raw: parameter) = \(tupleExprElementSyntax.expression)"
                    return CodeBlockItemSyntax(item: .stmt(stmt))
                }
                return nil
            }
        let returnValue: ExprSyntax = "\n    return formatter.string(from: \(date.expression))"
        let returnblock = CodeBlockItemSyntax(item: .expr(returnValue))
        let statementList = CodeBlockItemListSyntax([formatterStatement] + arguments + [returnblock])
        let closure = ClosureExprSyntax(statements: statementList)
        let function = FunctionCallExprSyntax(callee: closure)
        return ExprSyntax(function)
    }
}
