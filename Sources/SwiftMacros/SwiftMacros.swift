import Foundation

@attached(peer, names: suffixed(Publisher))
public macro AddPublisher() = #externalMacro(module: "Macros", type: "AddPublisher")

@freestanding(expression)
public macro encode(_ value: Encodable,
                    outputFormatting: JSONEncoder.OutputFormatting = [],
                    dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate,
                    dataEncodingStrategy: JSONEncoder.DataEncodingStrategy = .deferredToData,
                    nonConformingFloatEncodingStrategy: JSONEncoder.NonConformingFloatEncodingStrategy = .throw,
                    keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys,
                    userInfo: [CodingUserInfoKey : Any] = [:]) -> Data = #externalMacro(module: "Macros", type: "Encode")
@freestanding(expression)
public macro decode<T>(_ type: T.Type,
                       from value: Data,
                       dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                       dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
                       nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .throw,
                       keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                       userInfo: [CodingUserInfoKey : Any] = [:],
                       allowsJSON5: Bool = false,
                       assumesTopLevelDictionary: Bool = false) -> T = #externalMacro(module: "Macros", type: "Decode")

@attached(member, names: named(init), named(shared))
public macro Singleton() = #externalMacro(module: "Macros", type: "Singleton")
