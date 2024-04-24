import SwiftUI

struct TripsView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showingDeleteAlert = false
    @State private var indexSetToDelete: IndexSet?
    @State private var textSearch = ""
    
    var body: some View {
        NavigationStack {
            List() {
                ForEach(filteredTrips.indices, id: \.self) { index in
                    NavigationLink(destination: TripEditView(trip: Binding(get: {
                        filteredTrips[index]
                    }, set: { updatedTrip in
                        updateTrip(updatedTrip)
                    }), saveAction: { updatedTrip in
                        updateTrip(updatedTrip)
                    })) {
                        LocationRowView(trip: filteredTrips[index])
                    }
                }
                .onDelete(perform: { indexSet in
                    indexSetToDelete = indexSet
                    showingDeleteAlert = true
                })
                
            }
            .alert("Delete Trip", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive, action: deleteTrip)
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this trip? This action cannot be undone.")
            }
            .navigationTitle("Trip Plans")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("New Trip", destination: NewTripView())
                }
            }
            .searchable(text: $textSearch, prompt: "Search Trip Name...")
            
        }
    }
    
    var filteredTrips: [Trip] {
        if textSearch.isEmpty {
            return viewModel.trips
        } else {
            return viewModel.trips.filter { $0.title.localizedCaseInsensitiveContains(textSearch) }
        }
    }
    
    private func updateTrip(_ updatedTrip: Trip) {
        viewModel.updateTrip(trip: updatedTrip, user: viewModel.user!) { success in
            if success {
                DispatchQueue.main.async {
                    if let index = self.viewModel.trips.firstIndex(where: { $0.id == updatedTrip.id }) {
                        self.viewModel.trips[index] = updatedTrip
                    }
                }
            } else {
                print("Failed to update trip in the data store")
            }
        }
    }
    
    private func deleteTrip() {
        guard let indexSet = indexSetToDelete else { return }
        indexSet.forEach { index in
            viewModel.deleteTrip(trip: filteredTrips[index])
        }
        indexSetToDelete = nil
    }
}
