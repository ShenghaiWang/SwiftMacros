# SwiftMacros

A practical collection of Swift Macros that help code correctly and smartly.

## Install

    .package(url: "https://github.com/ShenghaiWang/SwiftMacros.git", from: "0.1.0")

## Macros

| Macro | Description  | Example  |
|------------|------------------------------------------------------------|------------|
| @Singleton | Generate Swift singleton code for struct and class types  | <pre>@Singleton<br>struct A {}<pre>|
| #encode    | Encode an Encodable to data using JSONEncoder | <pre>#encode(value)<pre>|
| #decode    | Decode a Decodable to a typed value using JSONDecoder  | <pre>#decode(TestStruct.self, from: data)<pre>|