import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showingDeleteAlert = false
    @State private var indexSetToDelete: IndexSet?
    @State private var textSearch = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredTrips.indices, id: \.self) { index in
                    NavigationLink(destination: PublicTripView(trip: filteredTrips[index])) {
                        LocationRowView(trip: filteredTrips[index])
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $textSearch, prompt: "Search Trip Name...")
        }
    }

    var filteredTrips: [Trip] {
        if textSearch.isEmpty {
            return viewModel.publicTrips
        } else {
            return viewModel.publicTrips.filter { $0.title.localizedCaseInsensitiveContains(textSearch) }
        }
    }


}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(ViewModel())
    }
}
