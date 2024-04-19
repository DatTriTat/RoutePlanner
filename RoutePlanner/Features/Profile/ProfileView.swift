import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                if let user = viewModel.user {
                    userDetailsView(user: user)
                } else {
                    Text("No user logged in.")
                        .foregroundColor(.secondary)
                        .padding()
                }
                Spacer()
                signOutButton
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
            .navigationTitle("Your Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    private func userDetailsView(user: User) -> some View {
        VStack {
            Text(user.firstName)
                .font(.title)
                .fontWeight(.medium)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 45)
                .padding(.leading, 10)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(user.lastName)
                .font(.title)
                .fontWeight(.medium)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 45)
                .padding(.leading, 10)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(user.email)
                .font(.title)
                .fontWeight(.medium)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 45)
                .padding(.leading, 10)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.vertical)
    }

    private var signOutButton: some View {
        Button("Sign Out") {
            viewModel.signOut()
        }
        .fontWeight(.semibold)
        .foregroundStyle(colorScheme == .light ? .white : .black)
        .frame(maxWidth: .infinity, maxHeight: 52)
        .background(colorScheme == .light ? .black : .white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

