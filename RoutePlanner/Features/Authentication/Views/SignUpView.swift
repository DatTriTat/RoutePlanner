//
//  SignUpView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/18/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
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
            .padding(.bottom, 20)
            
            VStack {
                TextField("Enter full name", text: $name)
                    .frame(height: 45)
                    .padding(.leading, 10)
                    .background(.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
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
            .padding(.vertical)
            
            Button {
                
            } label: {
                Text("Sign Up")
                    .fontWeight(.semibold)
                    .foregroundStyle(colorScheme == .light ? .white : .black)
            }
            .frame(maxWidth: .infinity, maxHeight: 52)
            .background(colorScheme == .light ? .black : .white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
            
            VStack {
                Divider()
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 5) {
                        Text("Already have an account?")
                        Text("Login").fontWeight(.semibold)
                    }
                }
                .padding(.top, 10)
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    SignUpView()
}
