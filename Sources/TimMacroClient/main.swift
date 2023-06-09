import TimMacro

struct TestSingleton {
    let name = "Tim Wang"
    private init() {
    }

    static let shared = Self ()
}

@Singleton
struct TestSingletonMacro {
    let name = "Tim Wang"
}


@Singleton
public struct TestPublicSingletonMacro {
    let name = "Tim Wang"
}

print(TestSingleton.shared.name)
print(TestSingletonMacro.shared.name)
print(TestPublicSingletonMacro.shared.name)
