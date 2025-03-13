import SwiftUI

struct ResponseView: View {
    let url: String
    let method: String
    
    @StateObject private var apiManager = ApiManager.shared
    
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
            apiManager.builderApiCall(url: url, method: method)
        }
    }
}

#Preview {
    ResponseView(url: "https://fakestoreapi.com/products", method: "GET")
}
