import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension TokenKind {
    var keyword: Keyword? {
        switch self {
        case let .keyword(keyword): return keyword
        default: return nil
        }
    }
}

public struct Singleton: MemberMacro {
    public static func expansion<Declaration: DeclGroupSyntax,
                                 Context: MacroExpansionContext>(of node: AttributeSyntax,
                                                                 providingMembersOf declaration: Declaration,
                                                                 in context: Context) throws -> [DeclSyntax] {
        let initializer = try InitializerDeclSyntax("private init()") {}

        let publicACL: TokenSyntax
        if let modifiers = declaration.modifiers,
            modifiers.compactMap(\.name.tokenKind.keyword).contains(.public) {
            publicACL = "public "
        } else {
            publicACL = ""
        }
        let sharedVariable: DeclSyntax =
        """
        \(publicACL)static let shared = Self()
        """

        return [DeclSyntax(initializer),
                sharedVariable
        ]
    }
}

@main
struct TimMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        Singleton.self
    ]
}
