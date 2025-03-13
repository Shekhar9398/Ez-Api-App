import SwiftUI

struct MainApiView: View {
    @State private var url = "https://dummyjson.com"
    @State private var endpoint = "/auth/login"
    @State private var method = "POST"
    
    @State private var headersString: String = """
{
    "Content-Type": "application/json"
}
"""
    
    @State private var requestBody = """
{
    "username": "emilys",
    "password": "emilyspass",
    "expiresInMins": 30
}
"""
    @State private var gotoResponseView = false
    @State private var tag = 0
    
    let methods = ["GET", "POST", "PUT", "DELETE"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    // MARK: - HTTP Method Picker
                    VStack {
                        Text("Select HTTP Method")
                            .font(.custom("Verdana", size: 16))
                            .foregroundColor(Color.mint)
                            .bold()
                            .padding(.vertical)
                        
                        Picker("Pick Method", selection: $tag) {
                            ForEach(0..<methods.count, id: \.self) { index in
                                Text(methods[index]).tag(index)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(12)
                        .accentColor(.white)
                        .onChange(of: tag) { newValue in
                            method = methods[newValue]
                        }
                    }
                    .padding()
                    
                    // MARK: - Base URL Input
                    VStack(alignment: .leading) {
                        Text("Enter Base URL")
                            .font(.custom("Verdana", size: 16))
                            .bold()
                        
                        TextField("Base URL", text: $url)
                            .font(.custom("Verdana", size: 16))
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                    
                    // MARK: - Endpoint Input
                    VStack(alignment: .leading) {
                        Text("Enter Endpoint")
                            .font(.custom("Verdana", size: 16))
                            .bold()
                        
                        TextField("Endpoint", text: $endpoint)
                            .font(.custom("Verdana", size: 16))
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                    
                    // MARK: - Headers Input as JSON String
                    VStack(alignment: .leading) {
                        Text("Enter Headers (JSON)")
                            .font(.custom("Verdana", size: 16))
                            .bold()
                        
                        TextEditor(text: $headersString)
                            .frame(height: 100)
                            .border(Color.gray, width: 1)
                    }
                    .padding()
                    
                    // MARK: - Body Input (Only for POST & PUT)
                    if method == "POST" || method == "PUT" {
                        VStack(alignment: .leading) {
                            Text("Enter Request Body (JSON)")
                                .font(.custom("Verdana", size: 16))
                                .bold()
                            
                            TextEditor(text: $requestBody)
                                .frame(height: 150)
                                .border(Color.gray, width: 1)
                                .padding(.vertical)
                        }
                        .padding()
                    }
                    
                    // MARK: - Submit Button
                    HStack {
                        Spacer()
                        Button("Submit") {
                            withAnimation {
                                gotoResponseView = true
                            }
                        }
                        .frame(width: 200, height: 40)
                        .foregroundColor(.white)
                        .background(Color.mint)
                        .cornerRadius(12)
                        .bold()
                        Spacer()
                    }
                    .padding()
                }
                .navigationTitle("EzApi")
                .navigationDestination(isPresented: $gotoResponseView) {
                    ResponseView(
                        url: url,
                        endpoint: endpoint,
                        method: method,
                        headersString: headersString,
                        requestBody: requestBody
                    )
                }
            }
        }
    }
}

#Preview {
    MainApiView()
}
