# SwiftMacros

A practical collection of Swift Macros that help code correctly and smartly.

## Install

    .package(url: "https://github.com/ShenghaiWang/SwiftMacros.git", from: "0.1.0")

## Macros

| Macro | Description  |
|------------|------------------------------------------------------------|
|@AddAssociatedValueVariable|Add variables to retrieve the associated values|
|    |<pre>@AddAssociatedValueVariable<br>enum MyEnum {<br>    case first<br>    case second(Int)<br>    case third(String, Int)<br>    case forth(a: String, b: Int), forth2(String, Int)<br>    case fifth(() -> Void)<br>}</pre>|
| @AddPublisher |Generate a Combine publisher to a Combine subject so that we can have a limited ACL for the subject |
|               |<pre>@AddPublisher<br>private let mySubject = PassthroughSubject<Void, Never>()</pre>|
| @AddInit      |Generate initialiser for the class/struct/actor. the variables with optional types will have nil as default values |
|               |<pre>@AddInit<br>struct InitStruct {<br>    let a: Int<br>    let b: Int?<br>    let c: (Int?) -> Void<br>    let d: ((Int?) -> Void)?<br>}</pre>|
| #buildURL    |Build a url from components. This solution addes in a resultBulder `URLBuilder`, which can be used directly if prefer builder pattern. |
|            |<pre>let url = #builURL("http://google.com",<br>                   URLScheme(.https),<br>                   URLQueryItems([.init(name: "q1", value: "q1v"), .init(name: "q2", value: "q2v")]))<br>let url2 = buildURL {<br>    "http://google.com"<br>    URLScheme(.https)<br>    URLQueryItems([.init(name: "q1", value: "q1v"), .init(name: "q2", value: "q2v")])<br>}</pre>|
| #encode    |Encode an Encodable to data using JSONEncoder |
|            |<pre>#encode(value)</pre>|
| #decode    |Decode a Decodable to a typed value using JSONDecoder  |
|            |<pre>#decode(TestStruct.self, from: data)</pre>|
| #postNotification    | An easy way to post notifications  |
|                      |<pre>#postNotification(.NSCalendarDayChanged)</pre>|
| @Singleton |Generate Swift singleton code for struct and class types  |
|            |<pre>@Singleton<br>struct A {}</pre>|

## To be added

Please feel free to add the macros you want here. All PRs(with or without implementations) are welcome.

| Macro | Description  |
|------------|------------------------------------------------------------|
| @          |  Your new macro ideas |
