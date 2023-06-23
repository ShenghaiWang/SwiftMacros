import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AddAssociatedValueVariable.self,
        AddInit.self,
        AddPublisher.self,
        BuildURL.self,
        Encode.self,
        Decode.self,
        PostNotification.self,
        Singleton.self,
    ]
}
