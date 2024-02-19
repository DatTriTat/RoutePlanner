//
//  LoginView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/18/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
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
            
            Text("Forgot Password?")
                .font(.footnote)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.vertical)
            
            Button {
                
            } label: {
                Text("Login")
                    .fontWeight(.semibold)
                    .foregroundStyle(colorScheme == .light ? .white : .black)
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

#Preview {
    LoginView()
}
