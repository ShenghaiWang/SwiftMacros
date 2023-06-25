import Foundation

public protocol DateComponent {}

extension Calendar: DateComponent {}

extension TimeZone: DateComponent {}

extension Date: DateComponent {}

public struct DateString: DateComponent {
    public let string: String
    public let locale: Locale?
    public let dateFormat: String?
    public let timeZone: TimeZone?
    public let twoDigitStartDate: Date?
    public let isLenient: Bool

    public init(_ string: String,
                locale: Locale? = nil,
                dateFormat: String? = nil,
                timeZone: TimeZone? = nil,
                twoDigitStartDate: Date? = nil,
                isLenient: Bool = false) {
        self.string = string
        self.locale = locale
        self.dateFormat = dateFormat
        self.timeZone = timeZone
        self.twoDigitStartDate = twoDigitStartDate
        self.isLenient = isLenient
    }
}

public struct ISO8601DateString: DateComponent {
    public let string: String
    public let timeZone: TimeZone?
    public let formatOptions: ISO8601DateFormatter.Options

    public init(_ string: String,
                timeZone: TimeZone? = nil,
                formatOptions: ISO8601DateFormatter.Options = []) {
        self.string = string
        self.timeZone = timeZone
        self.formatOptions = formatOptions
    }
}

public struct Era: DateComponent {
    public let value: Int

    public init(_ value: Int) {
        self.value = value
    }
}

public struct Year: DateComponent {
    public let value: Int

    public init(_ value: Int) {
        self.value = value
    }
}

public struct Month: DateComponent {
    public let value: Int

    public init(_ value: Int) {
        self.value = value
    }
}

public struct Hour: DateComponent {
    public let value: Int

    public init(_ value: Int) {
        self.value = value
    }
}

public struct Day: DateComponent {
    public let value: Int

    public init(_ value: Int) {
        self.value = value
    }
}

public struct Minute: DateComponent {
    public let value: Int

    public init(_ value: Int) {
        self.value = value
    }
}

public struct Second: DateComponent {
    public let value: Int

    public init(_ value: Int) {
        self.value = value
    }
}

public struct NanoSecond: DateComponent {
    public let value: Int

    public init(_ value: Int) {
        self.value = value
    }
}

public struct Weekday: DateComponent {
    public let value: Int

    public init(_ value: Int) {
        self.value = value
    }
}

public struct WeekdayOrdinal: DateComponent {
    public let value: Int

    public init(_ value: Int) {
        self.value = value
    }
}

public struct Quarter: DateComponent {
    public let value: Int

    public init(_ value: Int) {
        self.value = value
    }
}

public struct WeekOfMonth: DateComponent {
    public let value: Int

    public init(_ value: Int) {
        self.value = value
    }
}

public struct WeekOfYear: DateComponent {
    public let value: Int

    public init(_ value: Int) {
        self.value = value
    }
}

public struct YearForWeekOfYear: DateComponent {
    public let value: Int

    public init(_ value: Int) {
        self.value = value
    }
}

public typealias LeapMonth = Bool
extension LeapMonth: DateComponent {}

@resultBuilder
public struct DateBuilder {
    public static func buildBlock(_ parts: [DateComponent]...) -> [DateComponent] {
        parts.flatMap { $0 }
    }

    public static func buildExpression(_ expression: DateComponent) -> [DateComponent] {
        [expression]
    }

    public static func buildFinalResult(_ components: [DateComponent]) -> Date? {
        var dateComponents = DateComponents()
        components.forEach { component in
            if let value = component as? Calendar {
                dateComponents.calendar = value
            } else if let value = component as? TimeZone {
                dateComponents.timeZone = value
            } else if let value = component as? Era {
                dateComponents.era = value.value
            } else if let value = component as? Year {
                dateComponents.yearForWeekOfYear = nil
                dateComponents.year = value.value
            } else if let value = component as? Month {
                dateComponents.month = value.value
            } else if let value = component as? Hour {
                dateComponents.hour = value.value
            } else if let value = component as? Day {
                dateComponents.day = value.value
            } else if let value = component as? Minute {
                dateComponents.minute = value.value
            } else if let value = component as? Second {
                dateComponents.second = value.value
            } else if let value = component as? NanoSecond {
                dateComponents.nanosecond = value.value
            } else if let value = component as? Weekday {
                dateComponents.weekday = value.value
            } else if let value = component as? WeekdayOrdinal {
                dateComponents.weekdayOrdinal = value.value
            } else if let value = component as? Quarter {
                dateComponents.quarter = value.value
            } else if let value = component as? WeekOfMonth {
                dateComponents.weekOfMonth = value.value
            } else if let value = component as? WeekOfYear {
                dateComponents.weekOfYear = value.value
            } else if let value = component as? YearForWeekOfYear {
                dateComponents.year = nil
                dateComponents.yearForWeekOfYear = value.value
            } else if let value = component as? LeapMonth {
                dateComponents.isLeapMonth = value
            } else if let value = component as? Date {
                let calendar = dateComponents.calendar ?? Calendar.current
                dateComponents = calendar.dateComponents(Calendar.Component.all, from: value)
            } else if let value = component as? DateString {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = value.locale
                dateFormatter.dateFormat = value.dateFormat
                dateFormatter.timeZone = value.timeZone
                dateFormatter.twoDigitStartDate = value.twoDigitStartDate
                dateFormatter.isLenient = value.isLenient
                if let date = dateFormatter.date(from: value.string) {
                    let calendar = dateComponents.calendar ?? Calendar.current
                    dateComponents = calendar.dateComponents(Calendar.Component.all, from: date)
                }
            } else if let value = component as? ISO8601DateString {
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.timeZone = value.timeZone
                dateFormatter.formatOptions = value.formatOptions
                if let date = dateFormatter.date(from: value.string) {
                    let calendar = dateComponents.calendar ?? Calendar.current
                    dateComponents = calendar.dateComponents(Calendar.Component.all, from: date)
                }
            }
        }
        return dateComponents.date
    }
}

public func buildDate(@DateBuilder builder: () -> Date?) -> Date? {
    builder()
}

extension Calendar.Component {
    static let all: Set<Calendar.Component> = {
        [.era,
         .year,
         .month,
         .day,
         .hour,
         .minute,
         .second,
         .weekday,
         .weekdayOrdinal,
         .quarter,
         .weekOfMonth,
         .weekOfYear,
         .yearForWeekOfYear,
         .nanosecond,
         .calendar,
         .timeZone]
    }()
}
