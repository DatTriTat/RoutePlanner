import Foundation

struct User {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var trips: [Trip] = []

    // Initialize from individual properties
    init(id: String, firstName: String, lastName: String, email: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    
    }

    // Initialize from a dictionary (useful for Firebase operations)
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? UUID().uuidString
        self.firstName = dictionary["firstName"] as? String ?? { print("Warning: firstName not found"); return "" }()
        self.lastName = dictionary["lastName"] as? String ?? { print("Warning: lastName not found"); return "" }()
        self.email = dictionary["email"] as? String ?? { print("Warning: email not found"); return "" }()
        print("Raw trips data: \(dictionary["trips"] ?? "No trips data")") // Debugging line
        if let tripsData = dictionary["trips"] as? [String: [String: Any]] {
                    self.trips = tripsData.values.map(Trip.init)
                }
        print("Parsed trip: \(self.dictionary)") // Debugging line to see what gets created

    }
    
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "trips": trips.map { $0.dictionary }
        ]
    }
}
