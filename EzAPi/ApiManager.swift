import Foundation

class ApiManager: ObservableObject {
    static let shared = ApiManager()
    @Published var responseString = ""
    private init() {}
    
    func apiCall(baseUrl: String, endpoint: String, method: String, headers: [String: String] = [:], body: [String: Any]? = nil, includeCredentials: Bool = false) {
        guard let request = RequestBuilder()
            .setUrl(urlStr: baseUrl + endpoint)
            .setMethod(method: method)
            .includeCredentials(includeCredentials)
            .applyHeaders(headers)
            .applyBody(body)
            .build()
        else { return }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error while API Call: \(error)")
                    self?.responseString = "Error: \(error.localizedDescription)"
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Response Status Code: \(httpResponse.statusCode)")
                }
                
                if let data = data {
                    self?.responseString = self?.prettyPrintJSON(from: data) ?? "Invalid JSON Response"
                }
            }
        }
        task.resume()
    }
    
    private func prettyPrintJSON(from data: Data) -> String {
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        } else {
            return "Invalid JSON Response"
        }
    }
}

// MARK: - RequestBuilder Extensions
extension RequestBuilder {
    func applyHeaders(_ headers: [String: String]) -> RequestBuilder {
        headers.forEach { addHeader(key: $0.key, value: $0.value) }
        return self
    }
    
    func applyBody(_ body: [String: Any]?) -> RequestBuilder {
        if let body = body {
            setBody(body: body)
        }
        return self
    }
}
