import Foundation

@attached(member, names: named(init), named(shared))
public macro Singleton() = #externalMacro(module: "Macros", type: "Singleton")

@freestanding(expression)
public macro encode(_ value: Encodable) -> Data = #externalMacro(module: "Macros", type: "Encode")
@freestanding(expression)
public macro decode<T>(_ type: T.Type, from value: Data) -> T = #externalMacro(module: "Macros", type: "Decode")
