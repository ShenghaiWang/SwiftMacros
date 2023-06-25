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

@freestanding(expression)
public macro formatDate(_ date: Date,
                        dateStyle: DateFormatter.Style? = nil,
                        timeStyle:  DateFormatter.Style? = nil,
                        localizedDateFormatFromTemplate: String? = nil,
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

@freestanding(expression)
public macro formatDateInterval(from fromDate: Date,
                                to toDate: Date,
                                dateStyle: DateIntervalFormatter.Style? = nil,
                                timeStyle: DateIntervalFormatter.Style? = nil,
                                dateTemplate: String? = nil,
                                calendar: Calendar? = nil,
                                locale: Locale? = nil,
                                timeZone: TimeZone? = nil) -> String = #externalMacro(module: "Macros", type: "FormatDateInterval")

@attached(peer, names: named(mock))
public macro Mock(typeName: String, randomMockValue: Bool = true) = #externalMacro(module: "Macros", type: "Mock")

@freestanding(expression)
public macro postNotification(_ name: NSNotification.Name,
                              object: Any? = nil,
                              userInfo: [AnyHashable : Any]? = nil,
                              from notificationCenter: NotificationCenter = .default) = #externalMacro(module: "Macros", type: "PostNotification")

@attached(member, names: named(init), named(shared))
public macro Singleton() = #externalMacro(module: "Macros", type: "Singleton")
