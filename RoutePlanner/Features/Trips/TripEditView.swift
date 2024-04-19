import SwiftUI
import MapKit

struct TripEditView: View {
    @Binding var originalTrip: Trip
    @State private var trip: Trip
    @Environment(\.dismiss) private var dismiss
    @State private var isShowing = false
    @Environment(\.colorScheme) private var colorScheme
    @State private var navigate = false
    
    var saveAction: (Trip) -> Void
    
    init(trip: Binding<Trip>, saveAction: @escaping (Trip) -> Void) {
        self._originalTrip = trip
        self._trip = State(initialValue: trip.wrappedValue)
        self.saveAction = saveAction
    }
    
    var currentDate: Date {
        Date()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("Trip Title", text: $trip.title)
                }
                DatePicker(
                    "Start Date",
                    selection: $trip.startDate,
                    in: currentDate...,
                    displayedComponents: .date
                )
                Section(header: Text("Places to Visit")) {
                    List {
                        ForEach(Array(trip.locations.enumerated()), id: \.offset) { index, location in
                            Text(location.name) // directly use location.name since it's non-optional

                        }
                        .onDelete(perform: deleteLocation)
                    }
                    
                    Button {
                        isShowing.toggle()
                    } label: {
                        Label("Add Stop", systemImage: "plus.circle.fill")
                    }
                    .sheet(isPresented: $isShowing) {
                        SearchMapsView(isShowing: $isShowing) { location in
                            let lo = convertMapItemToLocation(mapItem: location)  // Convert MKMapItems to Locations
                            trip.locations.append(lo)
                        }
                    }
                }
            }
            .navigationTitle("Edit Trip")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        print("Saving trip with title: \(trip.title) and \(trip.locations.count) locations.")
                        saveAction(trip)
                        originalTrip = trip
                    }
                    .disabled(trip.title.isEmpty || trip.locations.isEmpty)
                }
            }
            
            Button(action: {
                saveAction(trip)
                navigate = true
            }) {
                Text("Save and Go to Detail View")
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
    }
    
    private func deleteLocation(at offsets: IndexSet) {
        trip.locations.remove(atOffsets: offsets)
    }
}

