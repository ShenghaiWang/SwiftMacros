import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AddAssociatedValueVariable.self,
        AddInit.self,
        AddPublisher.self,
        BuildDate.self,
        BuildURL.self,
        BuildURLRequest.self,
        Encode.self,
        Decode.self,
        Mock.self,
        PostNotification.self,
        Singleton.self,
    ]
}
