import SwiftUI
import Firebase
import Combine

class ViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var user: User?
    private var dbRef = Database.database().reference()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        listenToAuthenticationState()
    }
    
    func listenToAuthenticationState() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            DispatchQueue.main.async {
                if let user = user {
                    self?.isAuthenticated = true
                    self?.fetchUserData(userID: user.uid)
                } else {
                    self?.isAuthenticated = false
                    self?.user = nil
                }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                if let user = authResult?.user, error == nil {
                    self?.isAuthenticated = true
                    self?.fetchUserData(userID: user.uid)
                    completion(true)
                } else {
                    print(error?.localizedDescription ?? "Unknown error")
                    self?.isAuthenticated = false
                    completion(false)
                }
            }
        }
    }
    
    
    func fetchUserData(userID: String) {
        dbRef.child("users").child(userID).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                return
            }
            DispatchQueue.main.async {
                self?.user = User(dictionary: value)
            }
        }
    }
    
    
    func signUp(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self, let user = authResult?.user, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                completion(false)
                return
            }
            
            let userData = User(id: user.uid, firstName: firstName, lastName: lastName, email: email)
            self.storeUserData(user: userData)
            completion(true)
        }
    }
    
    private func storeUserData(user: User) {
        dbRef.child("users").child(user.id).setValue(user.dictionary) { error, _ in
            if let error = error {
                print("Data could not be saved: \(error.localizedDescription)")
            } else {
                self.fetchUserData(userID: user.id)
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            user = nil
            print("Logged out: isAuthenticated = \(isAuthenticated), user = \(String(describing: user))")
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Reset password email sent.")
            }
        }
    }
    
    func addTrip(trip: Trip) {
        guard let uid = user?.id else { return }
        dbRef.child("users").child(uid).child("trips").child(trip.id).setValue(trip.dictionary) { [self] error, _ in
            if let error = error {
                print("Failed to save trip: \(error.localizedDescription)")
            } else {
                print("Trip added successfully.")
                user?.trips.append(trip)
                
            }
        }
    }
    
    func updateTrip(trip: Trip) {
        guard let uid = user?.id else { return }
        let tripRef = dbRef.child("users").child(uid).child("trips").child(trip.id)
        
        let updatedTripData = trip.dictionary
        
        tripRef.updateChildValues(updatedTripData) { [weak self] error, _ in
            if let error = error {
                print("Failed to update trip: \(error.localizedDescription)")
            } else {
                print("Trip updated successfully.")
                if let index = self?.user?.trips.firstIndex(where: { $0.id == trip.id }) {
                    self?.user?.trips[index] = trip
                }
            }
        }
    }
    
    func deleteTrip(trip: Trip) {
        guard let uid = user?.id else { return }
        let tripRef = dbRef.child("users").child(uid).child("trips").child(trip.id)
        tripRef.removeValue { [weak self] error, _ in
            if let error = error {
                print("Failed to delete trip: \(error.localizedDescription)")
            } else {
                print("Trip deleted successfully.")
                self?.user?.trips.removeAll(where: { $0.id == trip.id })
            }
        }
    }
    
    
}
