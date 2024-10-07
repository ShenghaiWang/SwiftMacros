# SwiftMacros

A practical collection of Swift Macros that help code correctly and swiftly.

## Install

    .package(url: "https://github.com/ShenghaiWang/SwiftMacros.git", from: "2.0.0")

## Macros [API Doc](https://m.timwang.au/swiftmacros/documentation/swiftmacros/)

| Macro | Description  |
|------------|------------------------------------------------------------|
| @Access    |An easy API to access UserDefaults, Keychain, NSCache and NSMapTable. |
|            |<pre>struct TestAccess {<br>    static let cache = NSCache<NSString, AnyObject>()<br><br>    // Please make sure the generic type is the same as the type of the variable<br>    // Without defalut value<br>    @Access<Bool?>(.userDefaults())<br>    var isPaidUser: Bool?<br><br>    // With default value<br>    @Access< Bool>(.userDefaults())<br>    var isPaidUser2: Bool = false<br><br>    @Access<NSObject?>(.nsCache(TestAccess.cache))<br>    var hasPaid: NSObject?<br><br>    @Access<NSObject?>(.nsMapTable(TestAccess.mapTable))<br>    var hasPaid2: NSObject?<br><br>    @Access<TestStruct?>(.keychain)<br>    var keychainValue: TestStruct?<br>}</pre>|
|@AddAssociatedValueVariable|Add variables to retrieve the associated values|
|    |<pre>@AddAssociatedValueVariable<br>enum MyEnum {<br>    case first<br>    case second(Int)<br>    case third(String, Int)<br>    case forth(a: String, b: Int), forth2(String, Int)<br>    case fifth(() -> Void)<br>}</pre>|
| @AddInit      |Generate initialiser for the class/struct/actor. The variables with optional types will have nil as default values. Using `withMock: true` if want to generate mock data. <br> For custmoised data type, it will use `Type.mock`. In case there is no this value, need to define this yourself or use `@Mock` or `@AddInit(withMock: true)` to generate this variable. |
| @AddPublisher |Generate a Combine publisher to a Combine subject in order to avoid overexposing subject variable |
|               |<pre>@AddPublisher<br>private let mySubject = PassthroughSubject<Void, Never>()</pre>|
|               |<pre>@AddInit<br>struct InitStruct {<br>    let a: Int<br>    let b: Int?<br>    let c: (Int?) -> Void<br>    let d: ((Int?) -> Void)?<br>}<br>@AddInit(withMock: true)<br>class AStruct {<br>    let a: Float<br>}</pre>|
| #buildDate    |Build a Date from components<br>This solution addes in a resultBulder `DateBuilder`, which can be used directly if prefer builder pattern.<br>Note: this is for a simpler API. Please use it with caution in places that require efficiency.|
|            |<pre>let date = #buildDate(DateString("03/05/2003", dateFormat: "MM/dd/yyyy"),<br>                      Date(),<br>                      Month(10),<br>                      Year(1909),<br>                      YearForWeekOfYear(2025))</pre>|
| #buildURL    |Build a url from components.<br>This solution addes in a resultBulder `URLBuilder`, which can be used directly if prefer builder pattern. |
|            |<pre>let url = #buildURL("http://google.com",<br>                   URLScheme.https,<br>                   URLQueryItems([.init(name: "q1", value: "q1v"), .init(name: "q2", value: "q2v")]))<br>let url2 = buildURL {<br>    "http://google.com"<br>    URLScheme.https<br>    URLQueryItems([.init(name: "q1", value: "q1v"), .init(name: "q2", value: "q2v")])<br>}</pre>|
| #buildURLRequest    |Build a URLRequest from components.<br>This solution addes in a resultBulder `URLRequestBuilder`, which can be used directly if prefer builder pattern. |
|            |<pre>let urlrequest = #buildURLRequest(url!, RequestTimeOutInterval(100))<br>let urlRequest2 = buildURLRequest {<br>    url!<br>    RequestTimeOutInterval(100)<br>}</pre>|
| @ConformToEquatable|Add Equtable conformance to a class type<br>Use it with caution per https://github.com/apple/swift-evolution/blob/main/proposals/0185-synthesize-equatable-hashable.md#synthesis-for-class-types-and-tuples|
|            |<pre>@AddInit<br>@ConformToEquatable<br>class AClass {<br>    let a: Int?<br>    let b: () -> Void<br>}</pre>|
| @ConformToHashable|Add Hashable conformance to a class type<br>Use it with caution per https://github.com/apple/swift-evolution/blob/main/proposals/0185-synthesize-equatable-hashable.md#synthesis-for-class-types-and-tuples|
|            |<pre>@AddInit<br>@ConformToHashable<br>class AClass {<br>    let a: Int?<br>    let b: () -> Void<br>}</pre>|
| #encode    |Encode an Encodable to data using JSONEncoder |
|            |<pre>#encode(value)</pre>|
| #decode    |Decode a Decodable to a typed value using JSONDecoder  |
|            |<pre>#decode(TestStruct.self, from: data)</pre>|
| #formatDate |Format date to a string |
|            |<pre>#formatDate(Date(), dateStyle: .full)</pre>|
| #formatDateComponents |Format date differences/timeinterval/date components to a string |
|            |<pre>#formatDateComponents(from: Date(), to: Date(), allowedUnits: [.day, .hour, .minute, .second])<br>#formatDateComponents(fromInterval: 100, allowedUnits: [.day, .hour, .minute, .second])<br>#formatDateComponents(fromComponents: DateComponents(hour: 10), allowedUnits: [.day, .hour, .minute, .second])</pre>|
| #formatDateInterval |Format two dates into interval string |
|            |<pre>#formatDateInterval(from: Date(), to: Date(), dateStyle: .short)</pre>|
| @Mock      |Generate a static variable `mock` using the attached initializer. <br>For custmoised data type, it will use `Type.mock`. In case there is no this value, need to define this yourself or use `@Mock` or `@AddInit(withMock: true)` to generate this variable. |
|            |<pre>class AStruct {<br>    let a: Float<br>    @Mock(type: AStruct.self)<br>    init(a: Float) {<br>        self.a = a<br>    }<br>}</pre>|
| #postNotification    | An easy way to post notifications  |
|                      |<pre>#postNotification(.NSCalendarDayChanged)</pre>|
| @Singleton |Generate Swift singleton code for struct and class types  |
|            |<pre>@Singleton<br>struct A {}</pre>|

## To be added

Please feel free to add the macros you want here. All PRs(with or without implementations) are welcome.

| Macro | Description  |
|------------|------------------------------------------------------------|
| @          |  Your new macro ideas |
