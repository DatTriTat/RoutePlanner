import SwiftUI
import MapKit


struct TripsView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showingDeleteAlert = false
    @State private var indexSetToDelete: IndexSet?
    
    var body: some View {
        NavigationStack {
            List {
                if let trips = viewModel.user?.trips {
                    ForEach(trips.indices, id: \.self) { index in
                        NavigationLink(destination: TripEditView(trip: Binding(get: {
                            viewModel.user!.trips[index]
                        }, set: { newTrip in
                            viewModel.user!.trips[index] = newTrip
                        }), saveAction: updateTrip)) {
                            Text(trips[index].title)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        indexSetToDelete = indexSet
                        showingDeleteAlert = true
                    })
                }
            }
            .alert("Delete Trip", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive, action: deleteTrip)
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this trip? This action cannot be undone.")
            }
            .navigationTitle("Trip Plans")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("New Trip") {
                        NewTripView()
                    }
                }
            }
        }
    }
    
    private func deleteTrip() {
        guard let indexSet = indexSetToDelete else { return }
        let trips = viewModel.user?.trips
        
        indexSet.forEach { index in
            if let trip = trips?[index] {
                viewModel.deleteTrip(trip: trip)
            }
        }
        
        viewModel.user?.trips.remove(atOffsets: indexSet)
        indexSetToDelete = nil
    }
    
    
    private func updateTrip(_ updatedTrip: Trip) {
        if let index = viewModel.user?.trips.firstIndex(where: { $0.id == updatedTrip.id }) {
            viewModel.user?.trips[index] = updatedTrip
            viewModel.updateTrip(trip: updatedTrip)
        }
    }
}

