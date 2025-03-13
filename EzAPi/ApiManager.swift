import Foundation

class ApiManager: ObservableObject {
    static let shared = ApiManager()
    
    @Published var responseString = ""
    
    private init() {}
    
    func builderApiCall(url: String, method: String) {
        guard let request = RequestBuilder()
            .setUrl(urlStr: url)
            .setMethod(method: method)
            .build()
        else { return }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error while API Call: \(error)")
                    self?.responseString = "Error: \(error.localizedDescription)"
                    return
                }
                
                if let urlResponse = response as? HTTPURLResponse {
                    print("urlResponse: \(urlResponse)")
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
