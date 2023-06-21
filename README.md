# SwiftMacros

A practical collection of Swift Macros that help code correctly and smartly.

## Install

    .package(url: "https://github.com/ShenghaiWang/SwiftMacros.git", from: "0.1.0")

## Macros

| Macro | Description  |
|------------|------------------------------------------------------------|
| @AddPublisher |Generate a Combine publisher to a Combine subject so that we can have a limited ACL for the subject |
|               |<pre>@AutoPublisher<br>private let mySubject = PassthroughSubject<Void, Never>()</pre>|
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
