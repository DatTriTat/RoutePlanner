import SwiftUI
import MapKit

struct TripDetailView: View {
    @Binding var trip: Trip
    @State private var showingDirectionOptions = false
    @State private var directionsMode = MKLaunchOptionsDirectionsModeDriving
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d, yyyy"
        return formatter
    }
    var formattedDateRange: String {
        let startDateString = dateFormatter.string(from: trip.startDate)
        return startDateString
    }
    
    var mapItems: [MKMapItem] {
        let items = convertLocationsToMapItems(locations: trip.locations)
        print("Map Items: \(items)")
        return items
    }

    var body: some View {
        VStack {
            MapView(locations: mapItems)
                .frame(height: 250)
                .environmentObject(LocationManager())
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Places to Visit")
                        .font(.title)
                        .fontWeight(.bold)
                    Text(formattedDateRange)                         .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                .padding()
                
                locationList
                
                Button("Get Directions") {
                    showingDirectionOptions = true
                }
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
                .actionSheet(isPresented: $showingDirectionOptions) {
                    ActionSheet(title: Text("Select Directions Mode"), message: Text("Choose a mode of transportation"), buttons: [
                        .default(Text("Driving"), action: {
                            directionsMode = MKLaunchOptionsDirectionsModeDriving
                            openMap()
                        }),
                        .default(Text("Walking"), action: {
                            directionsMode = MKLaunchOptionsDirectionsModeWalking
                            openMap()
                        }),
                        .cancel()
                    ])
                }
            }
        }
        .navigationTitle(trip.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var locationList: some View {
        List {
            ForEach(mapItems.indices, id: \.self) { index in
                
                HStack(alignment: .top, spacing: 15) {
                    VStack(spacing: 0) {
                        Image(systemName: "\(index + 1).circle")
                            .font(.title2)
                        Rectangle()
                            .frame(width: 2, height: 30)
                            .foregroundStyle(.gray)
                    }
                    
                    Text(mapItems[index].name!)
                        .fontWeight(.semibold)
                        .frame(alignment: .leading)
                    
                    Spacer()
                    
                    Button(action: {
                        openMapToIndex(index: index)
                    }) {
                        Image(systemName: "location.circle.fill")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
        }
        .listStyle(PlainListStyle())
        .frame(maxHeight: .infinity)
    }
    
    
    
    func openMap() {
        MKMapItem.openMaps(
            with: [MKMapItem.forCurrentLocation()] + mapItems,
            launchOptions: [MKLaunchOptionsDirectionsModeKey: directionsMode])
    }
    func openMapToIndex(index: Int) {
        guard index >= 0 && index < trip.locations.count else {
            print("Index out of range: \(index)")
            return
        }
        
        let selectedLocation = mapItems[index]
        print("Opening directions to: \(selectedLocation.name ?? "Unknown location")")
        
        let mapItems = [MKMapItem.forCurrentLocation(), selectedLocation]
        MKMapItem.openMaps(
            with: mapItems,
            launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        )
    }
    
    
    
}

