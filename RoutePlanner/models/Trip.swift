import Foundation

struct Trip {
    var id: String
    var title: String
    var startDate: Date
    var locations: [Location]
    
    init(id: String = UUID().uuidString, title: String, startDate: Date, locations: [Location]) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.locations = locations
    }
    
    init(dictionary: [String: Any]) {
        print("Initializing Trip with dictionary: \(dictionary)")
        self.id = dictionary["id"] as? String ?? UUID().uuidString
        self.title = dictionary["title"] as? String ?? ""
        if let dateString = dictionary["startDate"] as? String {
            self.startDate = DateFormatter.iso8601Full.date(from: dateString) ?? Date()
        } else {
            self.startDate = Date()
        }
        self.locations = (dictionary["locations"] as? [[String: Any]] ?? []).map(Location.init)
    }

    var dictionary: [String: Any] {
        [
            "id": id,
            "title": title,
            "startDate": DateFormatter.iso8601Full.string(from: startDate),
            "locations": locations.map { $0.dictionary }
        ]
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

