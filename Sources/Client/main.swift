import SwiftMacros
import Foundation
import Combine

@Singleton
struct TestSingletonMacro {
    let name = "Tim Wang"
}

@Singleton
public struct TestPublicSingletonMacro {
    let name = "Tim Wang"
}

@Singleton
class TestPublicSingletonNSOjbectMacro: NSObject {
    let name = "Tim Wang"
}

struct TestStruct: Codable {
    var name = "Tim Wang"
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

@AddInit
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

print(urlrequest?.timeoutInterval)
