import SwiftMacros
import Foundation

struct TestSingleton: Encodable {
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

@Singleton
class TestPublicSingletonNSOjbectMacro: NSObject {
    let name = "Tim Wang"
}

print(TestSingleton.shared.name)
print(TestSingletonMacro.shared.name)
print(TestPublicSingletonMacro.shared.name)
print(TestPublicSingletonNSOjbectMacro.shared.name)


struct TestStruct: Codable {
    var name = "Tim Wang"
}

let data = try #encode(TestStruct())
let value = try #decode(TestStruct.self, from: data)


