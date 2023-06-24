import Foundation

public protocol URLRequestComponent {}

extension URL: URLRequestComponent {}

public struct RequestCachePolicy: URLRequestComponent {
    public let value: URLRequest.CachePolicy

    public init(_ value: URLRequest.CachePolicy) {
        self.value = value
    }
}

public struct RequestTimeOutInterval: URLRequestComponent {
    public let value: TimeInterval

    public init(_ value: TimeInterval) {
        self.value = value
    }
}

public enum RequestHTTPMethod: String, URLRequestComponent {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}

public struct RequestHTTPBody: URLRequestComponent {
    public let value: Data

    public init(_ value: Data) {
        self.value = value
    }
}

public struct RequestHTTPBodyStream: URLRequestComponent {
    public let value: InputStream

    public init(_ value: InputStream) {
        self.value = value
    }
}

public struct RequestMainDocumentURL: URLRequestComponent {
    public let value: URL

    public init(_ value: URL) {
        self.value = value
    }
}

public struct RequestHTTPHeaderFields: URLRequestComponent {
    public let value: [String : String]

    public init(_ value: [String : String]) {
        self.value = value
    }
}

public struct RequestShouldHandleCookies: URLRequestComponent {
    public let value: Bool

    public init(_ value: Bool) {
        self.value = value
    }
}

public struct RequestShouldUsePipelining: URLRequestComponent {
    public let value: Bool

    public init(_ value: Bool) {
        self.value = value
    }
}

public struct RequestAllowsCellularAccess: URLRequestComponent {
    public let value: Bool

    public init(_ value: Bool) {
        self.value = value
    }
}

public struct RequestAllowsConstrainedNetworkAccess: URLRequestComponent {
    public let value: Bool

    public init(_ value: Bool) {
        self.value = value
    }
}

public struct RequestAllowsExpensiveNetworkAccess: URLRequestComponent {
    public let value: Bool

    public init(_ value: Bool) {
        self.value = value
    }
}

public struct RequestNetworkServiceType: URLRequestComponent {
    public let value: URLRequest.NetworkServiceType

    public init(_ value: URLRequest.NetworkServiceType) {
        self.value = value
    }
}

@available(macOS 12.0, *)
public struct RequestAttribution: URLRequestComponent {
    public let value: URLRequest.Attribution

    public init(_ value: URLRequest.Attribution) {
        self.value = value
    }
}

public struct RequestAssumesHTTP3Capable: URLRequestComponent {
    public let value: Bool

    public init(_ value: Bool) {
        self.value = value
    }
}

public struct RequestRequiresDNSSECValidation: URLRequestComponent {
    public let value: Bool

    public init(_ value: Bool) {
        self.value = value
    }
}

@resultBuilder
public struct URLRequestBuilder {
    public static func buildBlock(_ parts: [URLRequestComponent]...) -> [URLRequestComponent] {
        parts.flatMap { $0 }
    }

    public static func buildExpression(_ expression: URLRequestComponent) -> [URLRequestComponent] {
        [expression]
    }

    public static func buildFinalResult(_ components: [URLRequestComponent]) -> URLRequest? {
        let componentDict = Dictionary(grouping: components) { $0 is URL }
        guard let url = componentDict[true]?.last as? URL else { return nil }
        var request = URLRequest(url: url)
        componentDict[false]?.forEach { component in
            if let value = component as? RequestCachePolicy {
                request.cachePolicy = value.value
            } else if let value = component as? RequestTimeOutInterval {
                request.timeoutInterval = value.value
            } else if let value = component as? RequestHTTPMethod {
                request.httpMethod = value.rawValue
            } else if let value = component as? RequestHTTPBody {
                request.httpBody = value.value
            } else if let value = component as? RequestHTTPBodyStream {
                request.httpBodyStream = value.value
            } else if let value = component as? RequestMainDocumentURL {
                request.mainDocumentURL = value.value
            } else if let value = component as? RequestHTTPHeaderFields {
                request.allHTTPHeaderFields = value.value
            } else if let value = component as? RequestShouldHandleCookies {
                request.httpShouldHandleCookies = value.value
            } else if let value = component as? RequestShouldUsePipelining {
                request.httpShouldUsePipelining = value.value
            } else if let value = component as? RequestAllowsCellularAccess {
                request.allowsCellularAccess = value.value
            } else if let value = component as? RequestAllowsConstrainedNetworkAccess {
                request.allowsConstrainedNetworkAccess = value.value
            } else if let value = component as? RequestAllowsExpensiveNetworkAccess {
                request.allowsExpensiveNetworkAccess = value.value
            } else if let value = component as? RequestNetworkServiceType {
                request.networkServiceType = value.value
            }
            if #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *),
                let value = component as? RequestAttribution {
                    request.attribution = value.value
            }

            if #available(macOS 11.3, iOS 14.5, watchOS 7.4, tvOS 14.5, *),
               let value = component as? RequestAssumesHTTP3Capable {
                request.assumesHTTP3Capable = value.value
            }

            if  #available(macOS 13.0, iOS 16.1, watchOS 9.1, tvOS 16.1, *),
                let value = component as? RequestRequiresDNSSECValidation {
                request.requiresDNSSECValidation = value.value
            }
        }
        return request
    }
}

public func buildURLRequest(@URLRequestBuilder builder: () -> URLRequest?) -> URLRequest? {
    builder()
}
