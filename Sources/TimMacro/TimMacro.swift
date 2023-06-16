import Foundation

@attached(member, names: named(init), named(shared))
public macro Singleton() = #externalMacro(module: "Macros", type: "Singleton")

@freestanding(expression)
public macro encode(_ value: Encodable) -> Data = #externalMacro(module: "Macros", type: "Encode")
