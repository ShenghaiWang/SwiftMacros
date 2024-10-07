import SwiftMacros
import Foundation
import Combine
import SwiftUI
import SwiftKeychain

@Singleton
struct TestSingletonMacro {
    let name = "Tim Wang"
}

@MainActor
@Singleton
public struct TestPublicSingletonMacro {
    let name = "Tim Wang"
}

@MainActor
@Singleton
class TestPublicSingletonNSOjbectMacro: NSObject {
    let name = "Tim Wang"
}

struct TestStruct: Codable {
    var name = "Tim Wang"
}

@Singleton
struct A {

}

let data = try #encode(TestStruct(), dateEncodingStrategy: .iso8601, dataEncodingStrategy: .base64)
let value = try #decode(TestStruct.self, from: data, dateDecodingStrategy: .deferredToDate)

struct MyType {
    @AddPublisher
    private let mySubject = PassthroughSubject<Void, Never>()
}

_ = MyType().mySubjectPublisher.sink { _ in

}

struct TestNotification {
    func post() {
        #postNotification(.NSCalendarDayChanged, object: NSObject(), userInfo: ["value": 0])
    }
}

@AddInit
struct InitStruct {
    let a: Int
    let b: Int?
    let c: (Int?) -> Void
    let d: ((Int?) -> Void)?
}

@AddInit(withMock: true)
actor InitActor {
    let a: Int
    let b: Int?
    let c: (Int?) -> Void
    let d: ((Int?) -> Void)?
}

@AddAssociatedValueVariable
enum MyEnum {
    case first
    case second(Int)
    case third(String, Int)
    case forth(a: String, b: Int), forth2(String, Int)
    case seventh(() -> Void)
}

@AddAssociatedValueVariable
 enum TestEnum {
    case test(Int)
}

assert(MyEnum.first.forth2Value == nil)

let url = #buildURL("http://google.com",
                   URLScheme.https,
                   URLQueryItems([.init(name: "q1", value: "q1v"), .init(name: "q2", value: "q2v")]))

let url2 = buildURL {
    "http://google.com"
    URLScheme.https
    URLQueryItems([.init(name: "q1", value: "q1v"), .init(name: "q2", value: "q2v")])
}

let urlrequest = #buildURLRequest(url!, RequestTimeOutInterval(100))
let urlRequest2 = buildURLRequest {
    url!
    RequestTimeOutInterval(100)
}

@MainActor
class AClassForMock {
    let a: Float
    @Mock(type: AClassForMock.self)
    init(a: Float) {
        self.a = a
    }
}

@MainActor
@AddInit(withMock: true)
class BClassForMock {
    let a: Float
    let b: CStruct
}

struct CStruct {
    static let mock = CStruct()
}
print(AClassForMock.mock.a)
print(BClassForMock.mock.a)

let date = #buildDate(DateString("03/05/2003", dateFormat: "MM/dd/yyyy"),
                      Date(),
                      Month(10),
                      Year(1909),
                      YearForWeekOfYear(2025))
let string = #formatDate(Date(), dateStyle: .full)

let intervalString = #formatDateInterval(from: Date(), to: Date(timeIntervalSinceNow: 200))
let componentsString = #formatDateComponents(from: Date(), to: Date(timeIntervalSinceNow: 200), allowedUnits: [.day, .hour, .minute, .second])

@MainActor
struct TestAccess {
    static let cache = NSCache<NSString, AnyObject>()
    static let mapTable = NSMapTable<NSString, AnyObject>(keyOptions: .copyIn, valueOptions: .weakMemory)

    // without defalut value
    // make sure the generic type is the same as the type of the variable
    @Access<Bool?>(.userDefaults())
    var isPaidUser: Bool?

    // with default value
    @Access<Bool>(.userDefaults())
    var isPaidUser2: Bool = false

    @Access<NSObject?>(.nsCache(TestAccess.cache))
    var hasPaid: NSObject?

    @Access<NSObject?>(.nsMapTable(TestAccess.mapTable))
    var hasPaid2: NSObject?

    @Access<TestStruct?>(.keychain)
    var keychainValue: TestStruct?
}

@AddInit
@ConformToEquatable
@ConformToHashable
class AClass {
    let a: Int?
    let b: () -> Void
}
