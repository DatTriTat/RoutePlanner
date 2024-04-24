import SwiftUI

struct PublicTripView: View {
    @State private var trip: Trip
    @State private var navigate = false
    @Environment(\.colorScheme) private var colorScheme
    
    init(trip: Trip) {
        self._trip = State(initialValue: trip)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(trip.title)
                    .font(.largeTitle)
                    .padding(.top)
                
                Text("Start Date: \(trip.startDate, formatter: dateFormatter)")
                    .font(.title2)
                
                Text("Public: \(trip.isPublic ? "Yes" : "No")")
                    .font(.title3)
                
                Text("Created By: \(trip.nameOwner)")
                    .font(.title2)
                
                if !trip.pictureURLs.isEmpty {
                    imagesSection
                }
                
                if !trip.locations.isEmpty {
                    locationsSection
                }
                Button(action: {
                    navigate = true
                }) {
                    Text("Go to Detail View")
                        .font(.headline)
                        .foregroundColor(colorScheme == .light ? .white : .black)
                        .frame(maxWidth: .infinity, maxHeight: 52)
                        .background(colorScheme == .light ? Color.black : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                NavigationLink(
                    destination: TripDetailView(trip: $trip),
                    isActive: $navigate
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .padding()
        }
        .navigationTitle("Trip Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var imagesSection: some View {
        VStack(alignment: .leading) {
            Text("Images")
                .font(.headline)
                .padding(.bottom, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(trip.pictureURLs, id: \.self) { url in
                        AsyncImage(url: URL(string: url)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            
        }
    }
    
    private var locationsSection: some View {
        VStack(alignment: .leading) {
            Text("Locations")
                .font(.headline)
                .padding(.bottom, 5)
            ForEach(trip.locations, id: \.self) { location in
                VStack(alignment: .leading) {
                    Text(location.name)
                        .font(.title3)
                        .font(.subheadline)
                }
                .padding(.bottom, 5)
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }
}

