//
//  Location.swift
//  RoutePlanner
//
//  Created by Tri Tat on 4/18/24.
//

import MapKit

struct Location {
    var name: String
    var latitude: Double
    var longitude: Double

    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }

    var dictionary: [String: Any] {
        return [
            "name": name,
            "latitude": latitude,
            "longitude": longitude
        ]
    }

    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? "Unknown"
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
    }
}


func convertMapItemsToLocations(mapItems: [MKMapItem]) -> [Location] {
    return mapItems.map { mapItem in
        let name = mapItem.name ?? "Unknown"
        let latitude = mapItem.placemark.coordinate.latitude
        let longitude = mapItem.placemark.coordinate.longitude
        
        return Location(name: name, latitude: latitude, longitude: longitude)
    }
}

func convertMapItemToLocation(mapItem: MKMapItem) -> Location {
        // Extract name and coordinates from the placemark
        let name = mapItem.name ?? "Unknown"
        let latitude = mapItem.placemark.coordinate.latitude
        let longitude = mapItem.placemark.coordinate.longitude
        return Location(name: name, latitude: latitude, longitude: longitude)
}

func convertLocationsToMapItems(locations: [Location]) -> [MKMapItem] {
    return locations.map { location in
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: ["name": location.name])
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name  // Set the name directly on the map item
        return mapItem
    }
}
