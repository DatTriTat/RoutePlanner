import Foundation

struct Trip: Identifiable {
    var id: String
    var title: String
    var startDate: Date
    var locations: [Location]
    var ownerId: String
    var sharedWith: [String]
    var pictureURLs: [String]
    var isPublic: Bool
    var nameOwner: String

    
    init(id: String = UUID().uuidString, title: String, startDate: Date, locations: [Location], ownerId: String, sharedWith: [String] = [], pictureURLs: [String] = [], isPublic: Bool = false, nameOwner: String) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.locations = locations
        self.ownerId = ownerId
        self.sharedWith = sharedWith
        self.pictureURLs = pictureURLs
        self.isPublic = isPublic
        self.nameOwner = nameOwner

    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let title = dictionary["title"] as? String,
              let dateString = dictionary["startDate"] as? String,
              let startDate = DateFormatter.iso8601Full.date(from: dateString),
              let ownerId = dictionary["ownerId"] as? String,
              let locationsDicts = dictionary["locations"] as? [[String: Any]],
              let nameOwner = dictionary["nameOwner"] as? String

        else {
            print("Failed to initialize Trip: Missing or invalid field.")
            if dictionary["id"] == nil { print("Missing id") }
            if dictionary["title"] == nil { print("Missing title") }
            if dictionary["startDate"] == nil { print("Missing startDate") }
            if dictionary["ownerId"] == nil { print("Missing ownerId") }
            if dictionary["locations"] == nil { print("Missing locations") }
            if dictionary["sharedWith"] == nil { print("Missing sharedWith") }
            return nil
        }
        self.id = id
        self.title = title
        self.startDate = startDate
        self.locations = locationsDicts.map(Location.init)
        self.ownerId = ownerId
        self.sharedWith = dictionary["sharedWith"] as? [String] ?? []
        self.pictureURLs = dictionary["pictures"] as? [String] ?? []
        self.isPublic = dictionary["isPublic"] as? Bool ?? false
        self.nameOwner = nameOwner

    }


    var dictionary: [String: Any] {
        [
            "id": id,
            "title": title,
            "startDate": DateFormatter.iso8601Full.string(from: startDate),
            "locations": locations.map { $0.dictionary },
            "ownerId": ownerId,
            "sharedWith": sharedWith,
            "pictures": pictureURLs,
            "isPublic": isPublic,
            "nameOwner": nameOwner


        ]
    }

    mutating func update(with dictionary: [String: Any]) {
        if let title = dictionary["title"] as? String {
            self.title = title
        }
        if let dateString = dictionary["startDate"] as? String,
           let newDate = DateFormatter.iso8601Full.date(from: dateString) {
            self.startDate = newDate
        }
        if let locationsDicts = dictionary["locations"] as? [[String: Any]] {
            self.locations = locationsDicts.map(Location.init)
        }
        if let sharedWith = dictionary["sharedWith"] as? [String] {
            self.sharedWith = sharedWith
        }
        if let newPictureURLs = dictionary["pictures"] as? [String] {
                    self.pictureURLs = newPictureURLs
                }
        if let isPublic = dictionary["isPublic"] as? Bool {
            self.isPublic = isPublic
        }
    }

    func isEditable(by userId: String) -> Bool {
        return ownerId == userId || sharedWith.contains(userId)
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
