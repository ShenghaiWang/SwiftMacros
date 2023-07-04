import Foundation

/// An easy interface to retrieve value from or store value to ``AccessContentType`` like [UserDefault](https://developer.apple.com/documentation/foundation/userdefaults), [NSCache](https://developer.apple.com/documentation/foundation/nscache), [NSMAPTable](https://developer.apple.com/documentation/foundation/nsmaptable) and Keychain
///
/// - Parameters:
///   - type: One type of ``AccessContentType``.
///
/// For example:
/// ```swift
/// struct TestAccess {
///     static let cache = NSCache<NSString, AnyObject>()
///     static let mapTable = NSMapTable<NSString, AnyObject>(keyOptions: .copyIn, valueOptions: .weakMemory)
///
///     // without defalut value
///     // make sure the generic type is the same as the type of the variable
///     @Access<Bool?>(.userDefaults())
///     var isPaidUser: Bool?
///
///     // with default value
///     @Access<Bool>(.userDefaults())
///     var isPaidUser2: Bool = false
///
///     @Access<NSObject?>(.nsCache(TestAccess.cache))
///     var hasPaid: NSObject?
///
///     @Access<NSObject?>(.nsMapTable(TestAccess.mapTable))
///     var hasPaid2: NSObject?
///
///     @Access<CodableStruct?>(.keychain)
///     var value: CodableStruct?
/// }
/// ```
/// will expand to
///
/// ```swift
/// struct TestAccess {
///     static let cache = NSCache<NSString, AnyObject>()
///     static let mapTable = NSMapTable<NSString, AnyObject>(keyOptions: .copyIn, valueOptions: .weakMemory)
///
///     // without defalut value
///     // make sure the generic type is the same as the type of the variable
///     var isPaidUser: Bool?
///     {
///         get {
///             (UserDefaults.standard.object(forKey: "AccessKey_isPaidUser") as? Bool)
///         }
///
///         set {
///             UserDefaults.standard.set(newValue, forKey: "AccessKey_isPaidUser")
///         }
///     }
///
///     // with default value
///     var isPaidUser2: Bool = false
///     {
///         get {
///             (UserDefaults.standard.object(forKey: "AccessKey_isPaidUser2") as? Bool) ?? false
///         }
///
///         set {
///             UserDefaults.standard.set(newValue, forKey: "AccessKey_isPaidUser2")
///         }
///     }
///
///     var hasPaid: NSObject?
///     {
///         get {
///             (TestAccess.cache.object(forKey: "AccessKey_hasPaid") as? NSObject)
///         }
///
///         set {
///             if let value = newValue {
///                 TestAccess.cache.setObject(value, forKey: "AccessKey_hasPaid")
///             } else {
///                 TestAccess.cache.removeObject(forKey: "AccessKey_hasPaid")
///             }
///         }
///     }
///
///     var hasPaid2: NSObject?
///     {
///         get {
///             (TestAccess.mapTable.object(forKey: "AccessKey_hasPaid2") as? NSObject)
///         }
///
///         set {
///             if let value = newValue {
///                 TestAccess.mapTable.setObject(value, forKey: "AccessKey_hasPaid2")
///             } else {
///                 TestAccess.mapTable.removeObject(forKey: "AccessKey_hasPaid2")
///             }
///         }
///     }
///
///     var keychainValue: CodableStruct?
///     {
///         get {
///             try? SwiftKeychain.search(key: "AccessKey_keychainValue")
///         }
///
///         set {
///             if let value = newValue {
///                 SwiftKeychain.delete(key: "AccessKey_keychainValue")
///                 try? SwiftKeychain.add(value: value, for: "AccessKey_keychainValue")
///             } else {
///                 SwiftKeychain.delete(key: "AccessKey_keychainValue")
///             }
///         }
///     }
/// }
/// ```
@attached(accessor)
public macro Access<T>(_ type: AccessContentType) = #externalMacro(module: "Macros", type: "Access")

/// Add variables for cases that have associated values in order to easily retrieve them
///
/// For example:
///
/// ```swift
/// @AddAssociatedValueVariable
/// enum TestEnum {
///     case test(Int)
/// }
/// ```
///
/// will expand to
///
/// ```swift
/// enum TestEnum {
///     case test(Int)
///     var testValue: Int? {
///         if case let .test(v0) = self {
///             return v0
///         }
///         return nil
///     }
/// }
/// ```
@attached(member, names: arbitrary)
public macro AddAssociatedValueVariable() = #externalMacro(module: "Macros", type: "AddAssociatedValueVariable")

/// Generate initialiser for the class/struct/actor.
///
/// - Parameters:
///   - withMock: true - if want to add a mock value as the same time. Default to false.
///   - randomMockValue: true - if want to have random value for the mocked variable. Default to true.
///
/// For example:
///
/// ```swift
/// @AddInit
/// struct InitStruct {
///     let a: Int
///     let b: Int?
///     let c: (Int?) -> Void
///     let d: ((Int?) -> Void)?
/// }
/// ```
/// will expand to
///
/// ```swift
/// struct InitStruct {
///     let a: Int
///     let b: Int?
///     let c: (Int?) -> Void
///     let d: ((Int?) -> Void)?
///     init(a: Int, b: Int? = nil, c: @escaping (Int?) -> Void, d: ((Int?) -> Void)? = nil) {
///         self.a = a
///         self.b = b
///         self.c = c
///         self.d = d
///     }
/// }
///```
/// And
/// 
/// ```swift
/// @AddInit(withMock: true)
/// struct InitStruct {
///     let a: Int
///     let b: Int?
///     let c: (Int?) -> Void
///     let d: ((Int?) -> Void)?
/// }
/// ```
/// will expand to
///
/// ```swift
/// struct InitStruct {
///     let a: Int
///     let b: Int?
///     init(a: Int, b: Int? = nil) {
///         self.a = a
///         self.b = b
///     }
///     #if DEBUG
///     static let mock = InitStruct(a: 4285361067953494500, b: -2664036447940829071)
///     #endif
/// }
/// ```
@attached(member, names: named(init), named(mock))
public macro AddInit(withMock: Bool = false, randomMockValue: Bool = true) = #externalMacro(module: "Macros", type: "AddInit")

/// Generate a Combine publisher to a Combine subject in order to avoid overexposing subject variable
///
/// For example:
///
/// ```swift
/// struct MyType {
///     @AddPublisher
///     private let mySubject = PassthroughSubject<Void, Never>()
/// }
///```
/// will expand to
///
/// ```swift
/// struct MyType {
///     private let mySubject = PassthroughSubject<Void, Never>()
///     var mySubjectPublisher: AnyPublisher<Void, Never> {
///         mySubject.eraseToAnyPublisher()
///     }
/// }
/// ```
@attached(peer, names: suffixed(Publisher))
public macro AddPublisher() = #externalMacro(module: "Macros", type: "AddPublisher")

/// Build a Date from components.
/// This solution addes in a resultBulder `DateBuilder`,
/// which can be used directly if prefer builder pattern.
///
/// For example:
///
/// ```swift
/// let date = #buildDate(DateString("03/05/2003", dateFormat: "MM/dd/yyyy"),
///                       Date(),
///                       Month(10),
///                       Year(1909),
///                       YearForWeekOfYear(2025))
///
/// // or use build pattern directly
/// let date = buildDate(DateString("03/05/2003", dateFormat: "MM/dd/yyyy")
///                      Date()
///                      Month(10)
///                      Year(1909)
///                      YearForWeekOfYear(2025))
/// ```
/// > Note: this is for a simpler API. Please use it with caution in places that require efficiency.
@freestanding(expression)
public macro buildDate(_ components: DateComponent...) -> Date? = #externalMacro(module: "Macros", type: "BuildDate")

/// Build a url from components.
/// This solution addes in a resultBulder `URLBuilder`, which can be used directly if prefer builder pattern.
///
/// For exmaple:
/// ```swift
/// let url = #buildURL("http://google.com",
///                     URLScheme.https,
///                     URLQueryItems([.init(name: "q1", value: "q1v"), .init(name: "q2", value: "q2v")]))
///
/// // or use build pattern directly:
/// let url2 = buildURL {
///     "http://google.com"
///     URLScheme.https
///     URLQueryItems([.init(name: "q1", value: "q1v"), .init(name: "q2", value: "q2v")])
/// }
/// ```
@freestanding(expression)
public macro buildURL(_ components: URLComponent...) -> URL? = #externalMacro(module: "Macros", type: "BuildURL")

/// Build a URLRequest from components.
/// This solution addes in a resultBulder URLRequestBuilder, which can be used directly if prefer builder pattern.
/// For example:
/// ```swift
/// let urlrequest = #buildURLRequest(url!, RequestTimeOutInterval(100))
///
/// // or use build pattern
/// let urlRequest2 = buildURLRequest { url!
///                                     RequestTimeOutInterval(100)
///                                    }
/// ```
@freestanding(expression)
public macro buildURLRequest(_ components: URLRequestComponent...) -> URLRequest? = #externalMacro(module: "Macros", type: "BuildURLRequest")

/// Encode an Encodable to data using JSONEncoder
///
/// - Parameters:
///   - value: the value to be encoded. Need to conform Encodable
///   - outputFormatting: [JSONEncoder.OutputFormatting](https://developer.apple.com/documentation/foundation/jsonencoder/outputformatting)
///   - dataEncodingStrategy: [JSONEncoder.DataEncodingStrategy](https://developer.apple.com/documentation/foundation/jsonencoder/dataencodingstrategy)
///   - nonConformingFloatEncodingStrategy: JSONEncoder.NonConformingFloatEncodingStrategy
///   - keyEncodingStrategy: [JSONEncoder.KeyEncodingStrategy](https://developer.apple.com/documentation/foundation/jsonencoder/nonconformingfloatencodingstrategy)
///   - userInfo: [[CodingUserInfoKey: Any]](https://developer.apple.com/documentation/foundation/jsonencoder/2895176-userinfo)
///
/// For example:
/// ```swift
/// let data = #encode(value)
/// let anotherData = #encode(value, dateEncodingStrategy: .secondsSince1970)
/// ```
@freestanding(expression)
public macro encode(_ value: Encodable,
                    outputFormatting: JSONEncoder.OutputFormatting = [],
                    dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate,
                    dataEncodingStrategy: JSONEncoder.DataEncodingStrategy = .deferredToData,
                    nonConformingFloatEncodingStrategy: JSONEncoder.NonConformingFloatEncodingStrategy = .throw,
                    keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys,
                    userInfo: [CodingUserInfoKey: Any] = [:]) -> Data = #externalMacro(module: "Macros", type: "Encode")

/// Decode a Decodable to a typed value using JSONDecoder
///  - Parameters:
///    - type: The type of the value to decode from the supplied JSON object.
///    - dateDecodingStrategy: [JSONDecoder.DateDecodingStrategy](https://developer.apple.com/documentation/foundation/jsondecoder/datedecodingstrategy)
///    - dataDecodingStrategy: [JSONDecoder.DataDecodingStrategy](https://developer.apple.com/documentation/foundation/jsondecoder/datadecodingstrategy)
///    - nonConformingFloatDecodingStrategy:  [JSONDecoder.NonConformingFloatDecodingStrategy](https://developer.apple.com/documentation/foundation/jsondecoder/nonconformingfloatdecodingstrategy)
///    - keyDecodingStrategy: [JSONDecoder.KeyDecodingStrategy](https://developer.apple.com/documentation/foundation/jsondecoder/keydecodingstrategy)
///    - userInfo: [[CodingUserInfoKey: Any]](https://developer.apple.com/documentation/foundation/jsondecoder/2895340-userinfo)
///    - allowsJSON5: [Bool](https://developer.apple.com/documentation/foundation/jsondecoder/3766916-allowsjson5)
///    - assumesTopLevelDictionary: [Bool](https://developer.apple.com/documentation/foundation/jsondecoder/3766917-assumestopleveldictionary)
///
/// For exmample:
/// ```swift
/// let value = #decode(TestStruct.self, from: data)
/// let anotherValue = #decode(TestStruct.self, from: data, dateDecodingStrategy: .iso8601)
/// ```
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

/// Format date to a string
///
/// - Parameters:
///   - date: the date to be formatted
///   - dateStyle: [DateFormatter.Style?](https://developer.apple.com/documentation/foundation/dateformatter/1415411-datestyle)
///   - timeStyle:  [DateFormatter.Style?](https://developer.apple.com/documentation/foundation/dateformatter/1413467-timestyle)
///   - formattingContext: [Formatter.Context?](https://developer.apple.com/documentation/foundation/dateformatter/1408066-formattingcontext)
///   - formatterBehavior: [DateFormatter.Behavior?](https://developer.apple.com/documentation/foundation/dateformatter/1409720-formatterbehavior)
///   - doesRelativeDateFormatting: [Bool?](https://developer.apple.com/documentation/foundation/dateformatter/1415848-doesrelativedateformatting)
///   - amSymbol: [String?](https://developer.apple.com/documentation/foundation/dateformatter/1409506-amsymbol)
///   - pmSymbol: [String?](https://developer.apple.com/documentation/foundation/dateformatter/1412367-pmsymbol)
///   - weekdaySymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1412405-weekdaysymbols)
///   - shortWeekdaySymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1416121-shortweekdaysymbols)
///   - veryShortWeekdaySymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1415109-veryshortweekdaysymbols)
///   - standaloneWeekdaySymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1413618-standaloneweekdaysymbols)
///   - shortStandaloneWeekdaySymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1409119-shortstandaloneweekdaysymbols)
///   - veryShortStandaloneWeekdaySymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1418238-veryshortstandaloneweekdaysymbol)
///   - monthSymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1412049-monthsymbols)
///   - shortMonthSymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1409209-shortmonthsymbols)
///   - veryShortMonthSymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1413632-veryshortmonthsymbols)
///   - standaloneMonthSymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1416227-standalonemonthsymbols)
///   - shortStandaloneMonthSymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1414771-shortstandalonemonthsymbols)
///   - veryShortStandaloneMonthSymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1413322-veryshortstandalonemonthsymbols)
///   - quarterSymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1417587-quartersymbols)
///   - shortQuarterSymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1409851-shortquartersymbols)
///   - standaloneQuarterSymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1411487-standalonequartersymbols)
///   - shortStandaloneQuarterSymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1416421-shortstandalonequartersymbols)
///   - eraSymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1418282-erasymbols)
///   - longEraSymbols: [[String]?](https://developer.apple.com/documentation/foundation/dateformatter/1418081-longerasymbols)
///
///  For example:
///  ```swift
///  let string = #formatDate(Date(), dateStyle: .full)
///  ```
@freestanding(expression)
public macro formatDate(_ date: Date,
                        dateStyle: DateFormatter.Style? = nil,
                        timeStyle:  DateFormatter.Style? = nil,
                        formattingContext: Formatter.Context? = nil,
                        formatterBehavior: DateFormatter.Behavior? = nil,
                        doesRelativeDateFormatting: Bool? = nil,
                        amSymbol: String? = nil,
                        pmSymbol: String? = nil,
                        weekdaySymbols: [String]? = nil,
                        shortWeekdaySymbols: [String]? = nil,
                        veryShortWeekdaySymbols: [String]? = nil,
                        standaloneWeekdaySymbols: [String]? = nil,
                        shortStandaloneWeekdaySymbols: [String]? = nil,
                        veryShortStandaloneWeekdaySymbols: [String]? = nil,
                        monthSymbols: [String]? = nil,
                        shortMonthSymbols: [String]? = nil,
                        veryShortMonthSymbols: [String]? = nil,
                        standaloneMonthSymbols: [String]? = nil,
                        shortStandaloneMonthSymbols: [String]? = nil,
                        veryShortStandaloneMonthSymbols: [String]? = nil,
                        quarterSymbols: [String]? = nil,
                        shortQuarterSymbols: [String]? = nil,
                        standaloneQuarterSymbols: [String]? = nil,
                        shortStandaloneQuarterSymbols: [String]? = nil,
                        eraSymbols: [String]? = nil,
                        longEraSymbols: [String]? = nil) -> String = #externalMacro(module: "Macros", type: "FormatDate")

/// Format date differences to a string
///
/// - Parameters:
///   - from: from date
///   - to: to date
///   - allowedUnits: [NSCalendar.Unit?](https://developer.apple.com/documentation/foundation/nscalendar/unit)
///   - allowsFractionalUnits: [Bool?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/1413084-allowsfractionalunits)
///   - calendar: [Calendar?](https://developer.apple.com/documentation/foundation/calendar)
///   - collapsesLargestUnit: [Bool?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/1410812-collapseslargestunit)
///   - includesApproximationPhrase: [Bool?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/1416387-includesapproximationphrase)
///   - includesTimeRemainingPhrase:[ Bool?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/1416416-includestimeremainingphrase)
///   - maximumUnitCount: [Int?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/1416214-maximumunitcount)
///   - unitsStyle: [DateComponentsFormatter.UnitsStyle?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/unitsstyle)
///   - zeroFormattingBehavior: [DateComponentsFormatter.ZeroFormattingBehavior?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/zeroformattingbehavior)
///   - formattingContext: [Formatter.Context?](https://developer.apple.com/documentation/foundation/formatter/context)
///   - referenceDate:[ Date?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/2878110-referencedate)
///
/// For example:
/// ```swift
/// let string = #formatDateComponents(from: Date(), to: Date(), allowedUnits: [.day, .hour, .minute, .second])
/// ```
@freestanding(expression)
public macro formatDateComponents(from fromDate: Date,
                                  to toDate: Date,
                                  allowedUnits: NSCalendar.Unit? = nil,
                                  allowsFractionalUnits: Bool? = nil,
                                  calendar: Calendar? = nil,
                                  collapsesLargestUnit: Bool? = nil,
                                  includesApproximationPhrase: Bool? = nil,
                                  includesTimeRemainingPhrase: Bool? = nil,
                                  maximumUnitCount: Int? = nil,
                                  unitsStyle: DateComponentsFormatter.UnitsStyle? = nil,
                                  zeroFormattingBehavior: DateComponentsFormatter.ZeroFormattingBehavior? = nil,
                                  formattingContext: Formatter.Context? = nil,
                                  referenceDate: Date? = nil) -> String? = #externalMacro(module: "Macros", type: "FormatDateComponents")

/// Format a timeInterval components to a string
///
/// - Parameters:
///   - fromInterval: the time interval to be formatted
///   - allowedUnits: [NSCalendar.Unit?](https://developer.apple.com/documentation/foundation/nscalendar/unit)
///   - allowsFractionalUnits: [Bool?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/1413084-allowsfractionalunits)
///   - calendar: [Calendar?](https://developer.apple.com/documentation/foundation/calendar)
///   - collapsesLargestUnit: [Bool?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/1410812-collapseslargestunit)
///   - includesApproximationPhrase: [Bool?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/1416387-includesapproximationphrase)
///   - includesTimeRemainingPhrase:[ Bool?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/1416416-includestimeremainingphrase)
///   - maximumUnitCount: [Int?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/1416214-maximumunitcount)
///   - unitsStyle: [DateComponentsFormatter.UnitsStyle?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/unitsstyle)
///   - zeroFormattingBehavior: [DateComponentsFormatter.ZeroFormattingBehavior?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/zeroformattingbehavior)
///   - formattingContext: [Formatter.Context?](https://developer.apple.com/documentation/foundation/formatter/context)
///   - referenceDate:[ Date?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/2878110-referencedate)
///
/// For example:
/// ```swift
/// let string = #formatDateComponents(fromInterval: 100, allowedUnits: [.day, .hour, .minute, .second])
/// ```
@freestanding(expression)
public macro formatDateComponents(fromInterval timeInterval: TimeInterval,
                                  allowedUnits: NSCalendar.Unit? = nil,
                                  allowsFractionalUnits: Bool? = nil,
                                  calendar: Calendar? = nil,
                                  collapsesLargestUnit: Bool? = nil,
                                  includesApproximationPhrase: Bool? = nil,
                                  includesTimeRemainingPhrase: Bool? = nil,
                                  maximumUnitCount: Int? = nil,
                                  unitsStyle: DateComponentsFormatter.UnitsStyle? = nil,
                                  zeroFormattingBehavior: DateComponentsFormatter.ZeroFormattingBehavior? = nil,
                                  formattingContext: Formatter.Context? = nil,
                                  referenceDate: Date? = nil) -> String? = #externalMacro(module: "Macros", type: "FormatDateComponents")

/// Format a date components to a string
///
/// - Parameters:
///   - fromComponents: the date components to be formatted
///   - allowedUnits: [NSCalendar.Unit?](https://developer.apple.com/documentation/foundation/nscalendar/unit)
///   - allowsFractionalUnits: [Bool?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/1413084-allowsfractionalunits)
///   - calendar: [Calendar?](https://developer.apple.com/documentation/foundation/calendar)
///   - collapsesLargestUnit: [Bool?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/1410812-collapseslargestunit)
///   - includesApproximationPhrase: [Bool?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/1416387-includesapproximationphrase)
///   - includesTimeRemainingPhrase:[ Bool?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/1416416-includestimeremainingphrase)
///   - maximumUnitCount: [Int?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/1416214-maximumunitcount)
///   - unitsStyle: [DateComponentsFormatter.UnitsStyle?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/unitsstyle)
///   - zeroFormattingBehavior: [DateComponentsFormatter.ZeroFormattingBehavior?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/zeroformattingbehavior)
///   - formattingContext: [Formatter.Context?](https://developer.apple.com/documentation/foundation/formatter/context)
///   - referenceDate:[ Date?](https://developer.apple.com/documentation/foundation/datecomponentsformatter/2878110-referencedate)
///
/// For example:
/// ```swift
/// let string = #formatDateComponents(fromComponents: DateComponents(hour: 10), allowedUnits: [.day, .hour, .minute, .second])
/// ```
@freestanding(expression)
public macro formatDateComponents(fromComponents components: DateComponents,
                                  allowedUnits: NSCalendar.Unit? = nil,
                                  allowsFractionalUnits: Bool? = nil,
                                  calendar: Calendar? = nil,
                                  collapsesLargestUnit: Bool? = nil,
                                  includesApproximationPhrase: Bool? = nil,
                                  includesTimeRemainingPhrase: Bool? = nil,
                                  maximumUnitCount: Int? = nil,
                                  unitsStyle: DateComponentsFormatter.UnitsStyle? = nil,
                                  zeroFormattingBehavior: DateComponentsFormatter.ZeroFormattingBehavior? = nil,
                                  formattingContext: Formatter.Context? = nil,
                                  referenceDate: Date? = nil) -> String? = #externalMacro(module: "Macros", type: "FormatDateComponents")
/// Format two dates into interval string
///
/// - Parameters:
///   - from: From date
///   - to: To date
///   - dateStyle: [DateIntervalFormatter.Style?](https://developer.apple.com/documentation/foundation/dateintervalformatter/style)
///   - timeStyle: [DateIntervalFormatter.Style?](https://developer.apple.com/documentation/foundation/dateintervalformatter/style)
///   - dateTemplate: [String? ](https://developer.apple.com/documentation/foundation/dateintervalformatter/1407373-datetemplate)
///   - calendar: [Calendar?](https://developer.apple.com/documentation/foundation/calendar)
///   - locale: [Locale?](https://developer.apple.com/documentation/foundation/locale)
///   - timeZone: [TimeZone?](https://developer.apple.com/documentation/foundation/timezone)
///
/// For example:
/// ```swift
/// let string = #formatDateInterval(from: Date(), to: Date(), dateStyle: .short)
/// ```
@freestanding(expression)
public macro formatDateInterval(from fromDate: Date,
                                to toDate: Date,
                                dateStyle: DateIntervalFormatter.Style? = nil,
                                timeStyle: DateIntervalFormatter.Style? = nil,
                                dateTemplate: String? = nil,
                                calendar: Calendar? = nil,
                                locale: Locale? = nil,
                                timeZone: TimeZone? = nil) -> String = #externalMacro(module: "Macros", type: "FormatDateInterval")

/// Generate a static variable mock using the attached initializer.
/// For custmoised data type, it will use Type.mock. In case there is no this value,
/// need to define this yourself or use @Mock or @AddInit(withMock: true) to generate this variable.
///
/// - Parameters:
///   - type: The value type
///   - randomMockValue: true - if want to have random value for the mocked variable. Default to true.
///
/// For example:
/// ```swift
/// class AStruct {
///     let a: Float
///     @Mock(type: AStruct.self)
///     init(a: Float) {
///         self.a = a
///     }
/// }
/// ```
/// will expand to
/// ```swift
/// class AStruct {
///     let a: Float
///     init(a: Float) {
///         self.a = a
///     }
///     #if DEBUG
///     static let mock = AStruct(a: 3.0339055e+37)
///     #endif
/// }
/// ```
@attached(peer, names: named(mock))
public macro Mock(type: Any.Type, randomMockValue: Bool = true) = #externalMacro(module: "Macros", type: "Mock")

/// An easy way to post notifications
/// - Parameters:
///   - name: The notification name to be posted
///   - object: The object posting the notification.
///   - userInfo: A user info dictionary with optional information about the notification.
///   - from: The notificationCenter used to send the notification. Default to [.default](https://developer.apple.com/documentation/foundation/notificationcenter/1414169-default)
///
/// For example:
/// ```swift
/// #postNotification(.NSCalendarDayChanged)
/// ```
@freestanding(expression)
public macro postNotification(_ name: NSNotification.Name,
                              object: Any? = nil,
                              userInfo: [AnyHashable : Any]? = nil,
                              from notificationCenter: NotificationCenter = .default) = #externalMacro(module: "Macros", type: "PostNotification")

/// Generate Swift singleton code for struct and class types
///
/// For example:
/// ```swift
/// @Singleton
/// struct A {
/// }
/// ```
/// will expand to
/// ```swift
/// struct A {
///     private init() {
///     }
///
///     static let shared = A()
/// }
/// ```
@attached(member, names: named(init), named(shared))
public macro Singleton() = #externalMacro(module: "Macros", type: "Singleton")
