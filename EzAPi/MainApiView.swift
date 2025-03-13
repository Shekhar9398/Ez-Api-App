import SwiftUI

struct MainApiView: View {
    @State var url = "https://fakestoreapi.com/products"
    @State var endpoint = ""
    @State var contentType = ""
    @State var authorization = ""
    @State var method = "GET"
    
    @State private var gotoResponseView = false
    @State private var tag = 0
    
    let methods = ["GET", "POST", "PUT", "DELETE"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    /// MARK: API Method Picker
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
                    
                    /// MARK: Base URL
                    VStack(alignment: .leading) {
                        Text("Enter Base URL")
                            .font(.custom("Verdana", size: 16))
                            .foregroundStyle(Color.black)
                            .bold()
                        
                        TextField("Base URL", text: $url)
                            .font(.custom("Verdana", size: 16))
                            .foregroundStyle(Color.green)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                    
                    /// MARK: Endpoint
                    VStack(alignment: .leading) {
                        Text("Enter Endpoint")
                            .font(.custom("Verdana", size: 16))
                            .foregroundStyle(Color.black)
                            .bold()
                        
                        TextField("Endpoint", text: $endpoint)
                            .font(.custom("Verdana", size: 16))
                            .foregroundStyle(Color.green)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                    
                    /// MARK: Headers
                    VStack(alignment: .leading) {
                        Text("Enter Headers")
                            .font(.custom("Verdana", size: 16))
                            .foregroundStyle(Color.black)
                            .bold()
                        
                        /// MARK: Content-Type Header
                        HStack {
                            Text("Content-Type")
                                .font(.custom("Verdana", size: 16))
                                .foregroundStyle(Color.black)
                            
                            TextField("Content-Type", text: $contentType)
                                .font(.custom("Verdana", size: 16))
                                .foregroundStyle(Color.green)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        /// MARK: Authorization Header
                        HStack {
                            Text("Authorization")
                                .font(.custom("Verdana", size: 16))
                                .foregroundStyle(Color.black)
                            
                            TextField("Authorization", text: $authorization)
                                .font(.custom("Verdana", size: 16))
                                .foregroundStyle(Color.green)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    .padding()
                    
                    /// MARK: Submit Button{
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
                }
                .navigationTitle("EzApi")
                .navigationDestination(isPresented: $gotoResponseView) {
                    ResponseView(url: url, method: method)
                }
        }
    }
}

#Preview {
    MainApiView()
}
