import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class AccessTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "Access": Access.self,
    ]
    
    func testAccessUserDefaultsMacro() {
        assertMacroExpansion(
            """
            @Access<Bool?>(.userDefaults)
            var isPaidUser1: Bool = false
            @Access<Bool?>(.userDefaults)
            var isPaidUser2: Bool = false
            @Access<Bool?>(.userDefaults)
            var isPaidUser3: Bool?
            """,
            expandedSource:
            """
            
            var isPaidUser1: Bool {
                get {
                    (UserDefaults.standard.object(forKey: "AccessKey_isPaidUser1") as? Bool) ?? false
                }
                set {
                    UserDefaults.standard.set(newValue, forKey: "AccessKey_isPaidUser1")
                }
            }
            var isPaidUser2: Bool {
                get {
                    (UserDefaults.standard.object(forKey: "AccessKey_isPaidUser2") as? Bool) ?? false
                }
                set {
                    UserDefaults.standard.set(newValue, forKey: "AccessKey_isPaidUser2")
                }
            }
            var isPaidUser3: Bool? {
                get {
                    (UserDefaults.standard.object(forKey: "AccessKey_isPaidUser3") as? Bool)
                }
                set {
                    UserDefaults.standard.set(newValue, forKey: "AccessKey_isPaidUser3")
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAccessUserDefaultsWithValueMacro() {
        assertMacroExpansion(
            """
            @Access<Bool>(.userDefaults(.standard))
            var isPaidUser1: Bool = false
            @Access<Bool>(.userDefaults(UserDefaults()))
            var isPaidUser2: Bool = false
            """,
            expandedSource:
            """

            var isPaidUser1: Bool {
                get {
                    (UserDefaults.standard.object(forKey: "AccessKey_isPaidUser1") as? Bool) ?? false
                }
                set {
                    UserDefaults.standard.set(newValue, forKey: "AccessKey_isPaidUser1")
                }
            }
            var isPaidUser2: Bool {
                get {
                    (UserDefaults().object(forKey: "AccessKey_isPaidUser2") as? Bool) ?? false
                }
                set {
                    UserDefaults().set(newValue, forKey: "AccessKey_isPaidUser2")
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAccessNSCacheMacro() {
        assertMacroExpansion(
            """
            @Access<NSObject>(.nsCache(cache))
            var isPaidUser1: NSObject = NSObject()
            @Access<NSObject?>(.nsCache(cache))
            var isPaidUser2: NSObject?
            """,
            expandedSource:
            """

            var isPaidUser1: NSObject {
                get {
                    (cache.object(forKey: "AccessKey_isPaidUser1") as? NSObject) ?? NSObject()
                }
                set {
                    cache.setObject(newValue, forKey: "AccessKey_isPaidUser1")
                }
            }
            var isPaidUser2: NSObject? {
                get {
                    (cache.object(forKey: "AccessKey_isPaidUser2") as? NSObject)
                }
                set {
                    if let value = newValue {
                        cache.setObject(value, forKey: "AccessKey_isPaidUser2")
                    } else {
                        cache.removeObject(forKey: "AccessKey_isPaidUser2")
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAccessNSMapTableMacro() {
        assertMacroExpansion(
            """
            @Access<NSObject>(.nsMapTable(cache))
            var isPaidUser1: NSObject = NSObject()
            @Access<NSObject?>(.nsMapTable(cache))
            var isPaidUser2: NSObject?
            """,
            expandedSource:
            """

            var isPaidUser1: NSObject {
                get {
                    (cache.object(forKey: "AccessKey_isPaidUser1") as? NSObject) ?? NSObject()
                }
                set {
                    cache.setObject(newValue, forKey: "AccessKey_isPaidUser1")
                }
            }
            var isPaidUser2: NSObject? {
                get {
                    (cache.object(forKey: "AccessKey_isPaidUser2") as? NSObject)
                }
                set {
                    if let value = newValue {
                        cache.setObject(value, forKey: "AccessKey_isPaidUser2")
                    } else {
                        cache.removeObject(forKey: "AccessKey_isPaidUser2")
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAccessKeychainMacro() {
        assertMacroExpansion(
            """
            @Access<CodableStruct?>(.keychain)
            var keychainValue: CodableStruct?
            """,
            expandedSource:
            """

            var keychainValue: CodableStruct? {
                get {
                    try? SwiftKeychain.search(key: "AccessKey_keychainValue")
                }
                set {
                    if let value = newValue {
                        SwiftKeychain.delete(key: "AccessKey_keychainValue")
                        try? SwiftKeychain.add(value: value, for: "AccessKey_keychainValue")
                    } else {
                        SwiftKeychain.delete(key: "AccessKey_keychainValue")
                    }
                }
            }
            """,
            macros: testMacros
        )
    }
}
