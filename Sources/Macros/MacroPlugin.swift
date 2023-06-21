import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AddPublisher.self,
        Encode.self,
        Decode.self,
        Singleton.self,
    ]
}
