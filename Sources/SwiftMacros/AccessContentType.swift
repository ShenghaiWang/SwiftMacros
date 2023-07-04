import Foundation

public enum AccessContentType {
    /// Retrieve value from or store value to [UserDefault](https://developer.apple.com/documentation/foundation/userdefaults).
    /// Default to [.standard](https://developer.apple.com/documentation/foundation/userdefaults/1416603-standard).
    case userDefaults(UserDefaults = .standard)
    /// Retrieve value from or store value to [NSCache](https://developer.apple.com/documentation/foundation/nscache).
    /// Have to provide an instance of **<NSString, AnyObject>**.
    case nsCache(NSCache<NSString, AnyObject>)
    /// Retrieve value from or store value to [NSMAPTable](https://developer.apple.com/documentation/foundation/nsmaptable)
    /// Have to provide an instance of **NSMapTable<NSString, AnyObject>**.
    case nsMapTable(NSMapTable<NSString, AnyObject>)

    /// Access system keychain
    case keychain
}
