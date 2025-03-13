import Foundation

/// MARK: - NetworkCall with Builder Pattern
class RequestBuilder {
    private var url: URL?
    private var method: String = "GET"
    private var headers: [String: String] = [:]
    private var body: Data?
    private var includeCredentials: Bool = false
    
    func setUrl(urlStr: String) -> RequestBuilder {
        self.url = URL(string: urlStr)
        return self
    }
    
    func setMethod(method: String) -> RequestBuilder {
        self.method = method
        return self
    }
    
    func addHeader(key: String, value: String) -> RequestBuilder {
        self.headers[key] = value
        return self
    }
    
    func setBody(body: [String: Any]) -> RequestBuilder {
        self.body = try? JSONSerialization.data(withJSONObject: body, options: [])
        return self
    }
    
    func includeCredentials(_ include: Bool) -> RequestBuilder {
        self.includeCredentials = include
        return self
    }
    
    func build() -> URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.method
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        if includeCredentials {
            request.setValue("include", forHTTPHeaderField: "credentials")
        }
        return request
    }
}

