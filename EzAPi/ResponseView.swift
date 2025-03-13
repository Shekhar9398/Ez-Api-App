import SwiftUI

struct ResponseView: View {
    let url: String
    let endpoint: String
    let method: String
    let headersString: String?
    let requestBody: String?
    
    @ObservedObject private var apiManager = ApiManager.shared
    
    var body: some View {
        ScrollView {
            Text("API Response")
                .font(.custom("Verdana", size: 16))
                .foregroundColor(Color.orange)
                .bold()
                .padding(.vertical)
            
            Text(apiManager.responseString.isEmpty ? "Fetching response..." : apiManager.responseString)
                .font(.custom("Verdana", size: 16))
                .foregroundColor(Color.purple)
                .padding(.vertical)
        }
        .padding()
        .onAppear {
            let parsedBody = parseJsonString(requestBody)
            let parsedHeaders = parseHeaders(headersString)
            
            apiManager.apiCall(
                baseUrl: url,
                endpoint: endpoint,
                method: method,
                headers: parsedHeaders ?? [:],
                body: parsedBody
            )
        }
    }
    
    /// Converts a JSON string into a [String: Any] dictionary.
    private func parseJsonString(_ jsonString: String?) -> [String: Any]? {
        guard let jsonString = jsonString,
              let data = jsonString.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    }
    
    /// Converts a JSON string into a [String: String] dictionary for headers.
    private func parseHeaders(_ jsonString: String?) -> [String: String]? {
        guard let jsonString = jsonString,
              let data = jsonString.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
    }
}

#Preview {
    ResponseView(
        url: "https://fakestoreapi.com",
        endpoint: "/products",
        method: "GET",
        headersString: "{\"Content-Type\": \"application/json\"}",
        requestBody: nil
    )
}
