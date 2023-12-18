import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        Access.self,
        AddAssociatedValueVariable.self,
        AddInit.self,
        AddPublisher.self,
        BuildDate.self,
        BuildURL.self,
        BuildURLRequest.self,
        Encode.self,
        Decode.self,
        FormatDate.self,
        FormatDateComponents.self,
        FormatDateInterval.self,
        Mock.self,
        PostNotification.self,
        Singleton.self,
        ConformToEquatable.self,
        ConformToHashable.self
    ]
}
