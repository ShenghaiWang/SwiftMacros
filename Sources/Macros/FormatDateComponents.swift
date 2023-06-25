import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct FormatDateComponents: ExpressionMacro {
    public static func expansion<Node: FreestandingMacroExpansionSyntax,
                                 Context: MacroExpansionContext>(of node: Node,
                                                                 in context: Context) throws -> ExprSyntax {
        let statementList: CodeBlockItemListSyntax
        if let fromDate = node.argument(for: "from"),
           let toDate = node.argument(for: "to") {
            statementList = parseFromToFunction(for: node.argumentList, from: fromDate, to: toDate)
        } else if let fromInterval = node.argument(for: "fromInterval") {
            statementList = parseFromFunction(for: node.argumentList, from: fromInterval)
        } else if let fromComponents = node.argument(for: "fromComponents") {
            statementList = parseFromFunction(for: node.argumentList, from: fromComponents)
        } else {
            throw MacroDiagnostics.errorMacroUsage(message: "Not supported parameters")
        }
        let closure = ClosureExprSyntax(statements: statementList)
        let function = FunctionCallExprSyntax(callee: closure)
        return ExprSyntax(function)
    }

    private static func parseFromToFunction(for argumentList: TupleExprElementListSyntax,
                                            from fromDate: ExprSyntax,
                                            to toDate: ExprSyntax) -> CodeBlockItemListSyntax {
        let formatter: DeclSyntax = "let formatter = DateComponentsFormatter()"
        let formatterStatement = CodeBlockItemSyntax(item: .decl(formatter))
        var statementList = CodeBlockItemListSyntax(arrayLiteral: formatterStatement)
        argumentList.dropFirst(2).forEach { tupleExprElementSyntax in
            if let codeblock = codeblock(for: tupleExprElementSyntax) {
                statementList = statementList.appending(codeblock)
            }
        }
        let returnValue: ExprSyntax = "return formatter.string(from: \(fromDate), to: \(toDate))"
        let returnblock = CodeBlockItemSyntax(item: .expr(returnValue))
        statementList = statementList.appending(returnblock)
        return statementList
    }

    private static func parseFromFunction(for argumentList: TupleExprElementListSyntax,
                                                  from fromInterval: ExprSyntax) -> CodeBlockItemListSyntax {
        let formatter: DeclSyntax = "let formatter = DateComponentsFormatter()"
        let formatterStatement = CodeBlockItemSyntax(item: .decl(formatter))
        var statementList = CodeBlockItemListSyntax(arrayLiteral: formatterStatement)
        argumentList.dropFirst(1).forEach { tupleExprElementSyntax in
            if let codeblock = codeblock(for: tupleExprElementSyntax) {
                statementList = statementList.appending(codeblock)
            }
        }
        let returnValue: ExprSyntax = "return formatter.string(from: \(fromInterval))"
        let returnblock = CodeBlockItemSyntax(item: .expr(returnValue))
        statementList = statementList.appending(returnblock)
        return statementList
    }

    private static func codeblock(for tupleExprElementSyntax: TupleExprElementSyntax) -> CodeBlockItemSyntax? {
        if let parameter = tupleExprElementSyntax.label?.text,
           !tupleExprElementSyntax.expression.is(NilLiteralExprSyntax.self) {
            let stmt: StmtSyntax = "formatter.\(raw: parameter) = \(tupleExprElementSyntax.expression)"
            let codeblock = CodeBlockItemSyntax(item: .stmt(stmt))
            return codeblock
        }
        return nil
    }
}
