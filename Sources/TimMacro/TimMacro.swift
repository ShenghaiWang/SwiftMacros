@attached(member, names: named(init), named(shared))
public macro Singleton() = #externalMacro(module: "TimMacroMacros", type: "Singleton")
