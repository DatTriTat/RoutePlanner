//
//  SignUpView.swift
//  RoutePlanner
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var viewmodel: ViewModel  // Using environment object here
    @State private var firstname = ""
    @State private var lastname = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            
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
                    TextField("Enter first name", text: $firstname)
                        .frame(height: 45)
                        .padding(.leading, 10)
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    TextField("Enter last name", text: $lastname)
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
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button {
                    isLoading = true
                    viewmodel.signUp(email: email, password: password, firstName: firstname, lastName: lastname) { success in
                        isLoading = false
                        if !success {
                            self.errorMessage = "Sign up failed. Please try again."
                        } else {
                            dismiss()
                        }
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Sign Up")
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
                    NavigationLink(destination: LoginView(viewmodel: viewmodel)) {
                        HStack(spacing: 5) {
                            Text("Already have an account?")
                            Text("Login").fontWeight(.semibold)
                        }
                    }
                    .padding(.top, 10)
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
