import Foundation

public protocol URLComponent {}

extension String: URLComponent {}

public struct URLFragment: URLComponent {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }
}

public struct URLHost: URLComponent {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }
}

public enum URLScheme: String, URLComponent {
    case http
    case https
}

public struct URLPassword: URLComponent {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }
}

public struct URLPath: URLComponent {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }
}

public struct URLPort: URLComponent {
    public let value: Int

    public init(_ value: Int) {
        self.value = value
    }
}

public struct URLQuery: URLComponent {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }
}

public struct URLQueryItems: URLComponent {
    public let value: [URLQueryItem]

    public init(_ value: [URLQueryItem]) {
        self.value = value
    }
}

public struct URLUser: URLComponent {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }
}

@resultBuilder
public struct URLBuilder {
    public static func buildBlock(_ parts: [URLComponent]...) -> [URLComponent] {
        parts.flatMap { $0 }
    }

    public static func buildExpression(_ expression: URLComponent) -> [URLComponent] {
        [expression]
    }

    public static func buildFinalResult(_ components: [URLComponent]) -> URL? {
        let componentDict = Dictionary(grouping: components) { $0 is String }
        let urlString = componentDict[true]?.last as? String ?? ""
        guard var urlComponents = URLComponents(string: urlString) else { return nil }
        componentDict[false]?.forEach { component in
            if let fragment = component as? URLFragment {
                urlComponents.fragment = fragment.value
            } else if let host = component as? URLHost {
                urlComponents.host = host.value
            } else if let scheme = component as? URLScheme {
                urlComponents.scheme = scheme.rawValue
            } else if let password = component as? URLPassword {
                urlComponents.password = password.value
            } else if let path = component as? URLPath {
                urlComponents.path = path.value
            } else if let port = component as? URLPort {
                urlComponents.port = port.value
            } else if let query = component as? URLQuery {
                urlComponents.query = query.value
            } else if let queryItems = component as? URLQueryItems {
                urlComponents.queryItems = queryItems.value
            } else if let user = component as? URLUser {
                urlComponents.user = user.value
            }
        }
        return urlComponents.url
    }
}

public func buildURL(@URLBuilder builder: () -> URL?) -> URL? {
    builder()
}
