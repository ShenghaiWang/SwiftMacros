import Foundation

public enum AccessContentType {
    case userDefaults(UserDefaults = .standard)
    case nsCache(NSCache<NSString, AnyObject>)
    case nsMapTable(NSMapTable<NSString, AnyObject>)
}
