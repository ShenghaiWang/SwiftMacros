import Foundation

@attached(member, names: arbitrary)
public macro AddAssociatedValueVariable() = #externalMacro(module: "Macros", type: "AddAssociatedValueVariable")

@attached(member, names: named(init), named(mock))
public macro AddInit(withMock: Bool = false, randomMockValue: Bool = true) = #externalMacro(module: "Macros", type: "AddInit")

@attached(peer, names: suffixed(Publisher))
public macro AddPublisher() = #externalMacro(module: "Macros", type: "AddPublisher")

@freestanding(expression)
public macro buildDate(_ components: DateComponent...) -> Date? = #externalMacro(module: "Macros", type: "BuildDate")

@freestanding(expression)
public macro buildURL(_ components: URLComponent...) -> URL? = #externalMacro(module: "Macros", type: "BuildURL")

@freestanding(expression)
public macro buildURLRequest(_ components: URLRequestComponent...) -> URLRequest? = #externalMacro(module: "Macros", type: "BuildURLRequest")

@freestanding(expression)
public macro encode(_ value: Encodable,
                    outputFormatting: JSONEncoder.OutputFormatting = [],
                    dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate,
                    dataEncodingStrategy: JSONEncoder.DataEncodingStrategy = .deferredToData,
                    nonConformingFloatEncodingStrategy: JSONEncoder.NonConformingFloatEncodingStrategy = .throw,
                    keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys,
                    userInfo: [CodingUserInfoKey: Any] = [:]) -> Data = #externalMacro(module: "Macros", type: "Encode")
@freestanding(expression)
public macro decode<T>(_ type: T.Type,
                       from value: Data,
                       dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                       dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
                       nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .throw,
                       keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                       userInfo: [CodingUserInfoKey: Any] = [:],
                       allowsJSON5: Bool = false,
                       assumesTopLevelDictionary: Bool = false) -> T = #externalMacro(module: "Macros", type: "Decode")

@attached(peer, names: named(mock))
public macro Mock(typeName: String, randomMockValue: Bool = true) = #externalMacro(module: "Macros", type: "Mock")

@freestanding(expression)
public macro postNotification(_ name: NSNotification.Name,
                              object: Any? = nil,
                              userInfo: [AnyHashable : Any]? = nil,
                              from notificationCenter: NotificationCenter = .default) = #externalMacro(module: "Macros", type: "PostNotification")

@attached(member, names: named(init), named(shared))
public macro Singleton() = #externalMacro(module: "Macros", type: "Singleton")
