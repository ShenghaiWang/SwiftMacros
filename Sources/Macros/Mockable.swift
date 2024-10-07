import Foundation
import SwiftUI

public protocol Mockable {
    static func mock(random: Bool) -> String
}

extension Int: Mockable {
    public static func mock(random: Bool) -> String {
        String(random ? Int.random(in: Int.min..<Int.max) : 1)
    }
}

extension Int8: Mockable {
    public static func mock(random: Bool) -> String {
        String(random ? Int8.random(in: Int8.min..<Int8.max) : 1)
    }
}

extension Int32: Mockable {
    public static func mock(random: Bool) -> String {
        String(random ? Int32.random(in: Int32.min..<Int32.max) : 1)
    }
}

extension Int64: Mockable {
    public static func mock(random: Bool) -> String {
        String(String(random ? Int64.random(in: Int64.min..<Int64.max) : 1))
    }
}

extension UInt: Mockable {
    public static func mock(random: Bool) -> String {
        String(random ? UInt.random(in: UInt.min..<UInt.max) : 1)
    }
}

extension UInt8: Mockable {
    public static func mock(random: Bool) -> String {
        String(random ? UInt8.random(in: UInt8.min..<UInt8.max) : 1)
    }
}

extension UInt32: Mockable {
    public static func mock(random: Bool) -> String {
        String(random ? UInt32.random(in: UInt32.min..<UInt32.max) : 1)
    }
}

extension UInt64: Mockable {
    public static func mock(random: Bool) -> String {
        String(random ? UInt64.random(in: UInt64.min..<UInt64.max) : 1)
    }
}

extension Bool: Mockable {
    public static func mock(random: Bool) -> String {
        String(random ? Bool.random() : true)
    }
}

extension String: Mockable {
    public static func mock(random: Bool) -> String {
        let string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        return random
        ? "\"\(String(repeatElement(string.randomElement() ?? "a", count: Int.random(in: 0..<50))))\""
        : #""abcd""#
    }
}

extension Double: Mockable {
    public static func mock(random: Bool) -> String {
        String(random ? Double.random(in: Double.leastNormalMagnitude..<Double.greatestFiniteMagnitude) : 1)
    }
}

extension Float: Mockable {
    public static func mock(random: Bool) -> String {
        String(random ? Float.random(in: Float.leastNormalMagnitude..<Float.greatestFiniteMagnitude) : 1)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image: Mockable {
    public static func mock(random: Bool) -> String {
        let names = ["apple.logo",
                     "applescript",
                     "applewatch",
                     "appletv",
                     "homepodmini.and.appletv",
        ]
        return random
        ? "Image(systemName: \"\(names.randomElement() ?? "apple.logo")\")"
        : #"Image(systemName: "apple.logo")"#
    }
}

extension Character: Mockable {
    public static func mock(random: Bool) -> String {
        "\"" + String("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".randomElement() ?? "A") + "\""
    }
}

extension CharacterSet: Mockable {
    public static func mock(random: Bool) -> String {
        "[]"
    }
}
