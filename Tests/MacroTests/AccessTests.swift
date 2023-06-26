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
            var isPaidUser1 = false
            @Access<Bool?>(.userDefaults)
            var isPaidUser2: Bool = false
            @Access<Bool?>(.userDefaults)
            var isPaidUser3: Bool?
            """,
            expandedSource:
            """
            
            var isPaidUser1 = false {
                get {
                    (UserDefaults.standard.object(forKey: "AccessKey_isPaidUser1") as? Bool) ?? false
                }
                set {
                    UserDefaults.standard.set(newValue, forKey: "AccessKey_isPaidUser1")
                }
            }
            var isPaidUser2: Bool = false {
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
            var isPaidUser1 = false
            @Access<Bool>(.userDefaults(UserDefaults()))
            var isPaidUser2 = false
            """,
            expandedSource:
            """

            var isPaidUser1 = false {
                get {
                    (UserDefaults.standard.object(forKey: "AccessKey_isPaidUser1") as? Bool) ?? false
                }
                set {
                    UserDefaults.standard.set(newValue, forKey: "AccessKey_isPaidUser1")
                }
            }
            var isPaidUser2 = false {
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
            var isPaidUser1 = NSObject()
            @Access<NSObject?>(.nsCache(cache))
            var isPaidUser2: NSObject?
            """,
            expandedSource:
            """

            var isPaidUser1 = NSObject() {
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
}
