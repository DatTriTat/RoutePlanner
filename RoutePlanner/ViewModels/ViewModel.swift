import SwiftUI
import Firebase
import Combine
import FirebaseStorage
class ViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var user: User?
    @Published var trips: [Trip] = []
    @Published var publicTrips: [Trip] = []
    private var dbRef = Database.database().reference()
    private var cancellables = Set<AnyCancellable>()
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    
    init() {
        setupAuthenticationListener()
    }
    
    deinit {
        removeAuthenticationListener()
    }
    
    private func setupAuthenticationListener() {
        if authStateListenerHandle != nil && user != nil{
            print("Authentication listener already set up.")
            return
        }
        
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            DispatchQueue.main.async {
                if let user = user {
                    self?.isAuthenticated = true
                    self?.fetchUserData(userID: user.uid)
                    self?.fetchPublicTrips()
                } else {
                    self?.isAuthenticated = false
                    self?.user = nil
                    self?.trips = []
                }
            }
        }
    }
    
    private func removeAuthenticationListener() {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
            authStateListenerHandle = nil
            print("Authentication listener removed.")
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                if let user = authResult?.user, error == nil {
                    self?.isAuthenticated = true
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
            guard let dict = snapshot.value as? [String: Any] else {
                print("Error: Unable to fetch user data.")
                return
            }
            DispatchQueue.main.async {
                self?.user = User(dictionary: dict)
                print("User data set, calling fetchTrips()")
                
                self?.fetchTrips()
            }
        }
    }
    
    func fetchPublicTrips() {
        if NetworkMonitor.shared.isReachable {
            
            dbRef.child("trips").queryOrdered(byChild: "isPublic").queryEqual(toValue: true).observe(.value, with: { snapshot in
                var newTrips: [Trip] = []
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                       let dict = snapshot.value as? [String: Any] {
                        let trip = Trip(dictionary: dict)
                        newTrips.append(trip!)
                    }
                }
                DispatchQueue.main.async {
                    self.publicTrips = newTrips
                }
            })
        } else {
            print("Offline: Cannot fetch public trips")
            
        }
    }
    
    func fetchTrips() {
        guard let tripIds = user?.tripIds else {
            print("No trip IDs found for the user.")
            return
        }
        tripIds.forEach { tripId in
            dbRef.child("trips").child(tripId).observeSingleEvent(of: .value) { [weak self] snapshot in
                guard let self = self else {
                    print("Failed to retain self during trip fetching.")
                    return
                }
                guard let dict = snapshot.value as? [String: Any] else {
                    print("Failed to convert snapshot value to dictionary for trip ID \(tripId).")
                    updateUserTripIds(afterDeleting: tripId)
                    return
                }
                
                print("Fetched trip dictionary for ID \(tripId): \(dict)")
                if let trip = Trip(dictionary: dict) {
                    DispatchQueue.main.async {
                        self.trips.append(trip)
                        print("Successfully added trip: \(trip.title) to trips array.")
                    }
                } else {
                    print("Failed to initialize a Trip object from the dictionary: \(dict)")
                }
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
            removeAuthenticationListener() // Consider removing the listener on logout
            setupAuthenticationListener() // Re-setup if necessary
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
    
    func addTrip(trip: Trip, completion: @escaping (Bool, String) -> Void) {
        guard let uid = user?.id else {
            completion(false, "User must be logged in to add trips.")
            return
        }
        
        let newTripRef = dbRef.child("trips").child(trip.id)
        newTripRef.setValue(trip.dictionary) { [weak self] error, _ in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    print("Error saving trip: \(error.localizedDescription)")
                    completion(false, "Failed to save trip: \(error.localizedDescription)")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.trips.append(trip)
                if ((self.user?.tripIds.append(trip.id)) != nil) {
                    self.updateUserTripIds(completion: completion)
                } else {
                    completion(true, "Trip added successfully, but failed to update user trip IDs.")
                }
            }
        }
    }
    
    func updateTrip(trip: Trip, user: User, completion: @escaping (Bool) -> Void) {
        let tripRef = dbRef.child("trips").child(trip.id)
        
        tripRef.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("Error fetching trip: Snapshot is not a dictionary")
                completion(false)
                return
            }
            print("Fetched trip data: \(value)")
            tripRef.updateChildValues(trip.dictionary) { error, _ in
                if let error = error {
                    print("Error updating trip: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Trip successfully updated.")
                    self.handlePublicTripsList(trip: trip)
                    completion(true)
                }
            }
        }
    }
    
    private func handlePublicTripsList(trip: Trip) {
        if trip.isPublic {
            if !publicTrips.contains(where: { $0.id == trip.id }) {
                publicTrips.append(trip)
            }
        } else {
            if let index = publicTrips.firstIndex(where: { $0.id == trip.id }) {
                publicTrips.remove(at: index)
            }
        }
    }
    
    func uploadImages(_ images: [UIImage], completion: @escaping ([String]) -> Void) {
        var urls = [String]()
        let uploadGroup = DispatchGroup()
        
        for image in images {
            uploadGroup.enter()
            let storageRef = Storage.storage().reference().child("trip_images/\(UUID().uuidString).jpg")
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                storageRef.putData(imageData, metadata: nil) { _, error in
                    if let error = error {
                        print("Upload error: \(error.localizedDescription)")
                        uploadGroup.leave()
                        return
                    }
                    
                    storageRef.downloadURL { url, error in
                        if let url = url {
                            urls.append(url.absoluteString)
                        } else {
                            print("Failed to get download URL: \(error?.localizedDescription ?? "Unknown error")")
                        }
                        uploadGroup.leave()
                    }
                }
            } else {
                print("Failed to convert image to JPEG data")
                uploadGroup.leave()
            }
        }
        
        uploadGroup.notify(queue: .main) {
            completion(urls)
        }
    }
    
    
    
    
    func deleteTrip(trip: Trip) {
        guard let uid = user?.id else {
            print("User must be logged in to delete trips.")
            return
        }
        
        dbRef.child("trips").child(trip.id).removeValue { [weak self] error, _ in
            guard let self = self else { return }
            if let error = error {
                print("Error deleting trip: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    if let index = self.trips.firstIndex(where: { $0.id == trip.id }) {
                        self.trips.remove(at: index)
                    }
                    if let publicIndex = self.publicTrips.firstIndex(where: { $0.id == trip.id }) {
                        self.publicTrips.remove(at: publicIndex)
                    }
                    self.updateUserTripIds(afterDeleting: trip.id)
                    
                    print("Trip successfully deleted.")
                    
                }
            }
        }
    }
    
    private func updateUserTripIds(completion: @escaping (Bool, String) -> Void) {
        guard let uid = user?.id else {
            completion(false, "User must be logged in to update trip IDs.")
            return
        }
        
        let tripIds = user?.tripIds ?? []
        dbRef.child("users").child(uid).child("tripIds").setValue(tripIds) { error, _ in
            if let error = error {
                DispatchQueue.main.async {
                    print("Failed to update user trip IDs: \(error.localizedDescription)")
                    completion(false, "Failed to update user trip IDs: \(error.localizedDescription)")
                }
            } else {
                DispatchQueue.main.async {
                    completion(true, "Trip added and user trip IDs updated successfully.")
                }
            }
        }
    }
    
    private func updateUserTripIds(afterDeleting tripId: String) {
        guard let uid = user?.id else {
            print("User must be logged in to update trip IDs.")
            return
        }
        
        if let tripIndex = user?.tripIds.firstIndex(of: tripId) {
            user?.tripIds.remove(at: tripIndex)
        }
        dbRef.child("users").child(uid).child("tripIds").setValue(user?.tripIds) { error, _ in
            if let error = error {
                print("Failed to update user trip IDs after deletion: \(error.localizedDescription)")
            } else {
                print("User trip IDs updated successfully after deletion.")
            }
        }
    }
    
    func shareTripWithEmail(tripId: String, email: String, completion: @escaping (Bool, String) -> Void) {
        dbRef.child("users").queryOrdered(byChild: "email").queryEqual(toValue: email)
            .observeSingleEvent(of: .value, with: { snapshot in
                guard let dict = snapshot.value as? [String: Any], let key = dict.keys.first else {
                    completion(false, "No user found with that email")
                    return
                }
                let userId = key
                self.dbRef.child("trips").child(tripId).child("sharedWith").runTransactionBlock({ currentData in
                    var sharedWith = currentData.value as? [String] ?? []
                    if !sharedWith.contains(userId) {
                        sharedWith.append(userId)
                        currentData.value = sharedWith
                    }
                    return TransactionResult.success(withValue: currentData)
                }) { error, _, _ in
                    if let error = error {
                        completion(false, error.localizedDescription)
                    } else {
                        self.dbRef.child("users").child(userId).child("tripIds").runTransactionBlock({ currentData in
                            var tripIds = currentData.value as? [String] ?? []
                            if !tripIds.contains(tripId) {
                                tripIds.append(tripId)
                                currentData.value = tripIds
                            }
                            return TransactionResult.success(withValue: currentData)
                        }) { error, _, _ in
                            if let error = error {
                                completion(false, error.localizedDescription)
                            } else {
                                completion(true, "Trip shared successfully")
                            }
                        }
                    }
                }
            })
    }
}
