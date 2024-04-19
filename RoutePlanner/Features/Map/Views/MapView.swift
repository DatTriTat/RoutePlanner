import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @EnvironmentObject var locationManager: LocationManager
    var locations: [MKMapItem]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        updateAnnotations(mapView: uiView)
    }
    
    private func updateAnnotations(mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        let annotations = locations.map { location -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.title = location.name ?? "Unknown"
            annotation.coordinate = location.placemark.coordinate
            return annotation
        }
        mapView.addAnnotations(annotations)
        
        if !locations.isEmpty, let _ = locationManager.currentLocation {
            calculateRoute(from: MKMapItem.forCurrentLocation(), to: locations[0], mapView: mapView)
            for index in 0..<(locations.count - 1) {
                calculateRoute(from: locations[index], to: locations[index + 1], mapView: mapView)
            }
        }
    }
    
    private func calculateRoute(from source: MKMapItem, to destination: MKMapItem, mapView: MKMapView) {
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            mapView.addOverlay(route.polyline)
            if mapView.overlays.count == 1 {
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40), animated: true)
            } else {
                let mapRect = mapView.overlays.reduce(MKMapRect.null) { $0.union($1.boundingMapRect) }
                mapView.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40), animated: true)
            }
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}


struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    var locations = [
        MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437))),
        MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)))
    ]
    var body: some View {
        MapView(locations: locations)
            .onAppear {
                locationManager.requestLocationAuthorization()
                locationManager.startReceivingLocationChanges()
            }
            .environmentObject(locationManager) // Ensure locationManager is injected correctly.
            .frame(height: 250)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
