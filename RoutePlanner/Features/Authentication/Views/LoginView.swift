//
//  LoginView.swift
//  RoutePlanner
//
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewmodel: ViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            Spacer()
            
            ZStack(alignment: .topTrailing) {
                Image(systemName: "paperplane.fill")
                    .font(.title2)
                    .padding(.bottom, 50)
                
                Text("tripify")
                    .font(.system(size: 60))
                    .minimumScaleFactor(0.01)
                    .fontWeight(.bold)
            }
            
            VStack {
                TextField("Enter your email", text: $email)
                    .frame(height: 45)
                    .padding(.leading, 10)
                    .background(.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                SecureField("Enter your password", text: $password)
                    .frame(height: 45)
                    .padding(.leading, 10)
                    .background(.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Text("Forgot Password?")
                .font(.footnote)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.vertical)
            
            Button {
                isLoading = true
                viewmodel.signIn(email: email, password: password) { success in
                    isLoading = false
                    if !success {
                        self.errorMessage = "Authentication failed. Check your credentials and try again."
                    }
                }
            } label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Login")
                        .fontWeight(.semibold)
                        .foregroundStyle(colorScheme == .light ? .white : .black)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 52)
            .background(colorScheme == .light ? .black : .white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
            
            VStack {
                Divider()
                NavigationLink {
                    SignUpView()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing: 5) {
                        Text("Don't have an account?")
                        Text("Sign Up").fontWeight(.semibold)
                    }
                }
                .padding(.top, 10)
                .buttonStyle(.plain)
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewmodel: ViewModel())
    }
}
