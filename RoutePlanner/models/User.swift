import Foundation

struct User: Hashable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var tripIds: [String]  // IDs of trips this user has access to

    init(id: String, firstName: String, lastName: String, email: String, tripIds: [String] = []) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.tripIds = tripIds
    }

    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? UUID().uuidString
        self.firstName = dictionary["firstName"] as? String ?? "Unknown"
        self.lastName = dictionary["lastName"] as? String ?? "Unknown"
        self.email = dictionary["email"] as? String ?? "Unknown"
        self.tripIds = dictionary["tripIds"] as? [String] ?? []
    }

    var dictionary: [String: Any] {
        [
            "id": id,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "tripIds": tripIds
        ]
    }
}
