import SwiftUI
import MapKit

struct TripEditView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var originalTrip: Trip
    @State private var trip: Trip
    @State private var isShowing = false
    @State private var navigate = false
    @State private var shareEmail = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State private var isImagePickerShowing = false
    @State private var inputImages: [UIImage] = []
    private var ownerFullName: String {
        [viewModel.user?.firstName, viewModel.user?.lastName].compactMap { $0 }.joined(separator: " ")
    }
    var saveAction: (Trip) -> Void
    
    init(trip: Binding<Trip>, saveAction: @escaping (Trip) -> Void) {
        self._originalTrip = trip
        self._trip = State(initialValue: trip.wrappedValue)
        self.saveAction = saveAction
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("Trip Title", text: $trip.title)
                }
                .disabled(trip.nameOwner != ownerFullName)

                DatePicker("Start Date", selection: $trip.startDate, in: currentDate()..., displayedComponents: .date)
                    .disabled(trip.nameOwner != ownerFullName)

                imageSection
                placeToVisitSection
                shareTripSection
                if(trip.nameOwner == ownerFullName) {
                    publicPrivateSection
                }
            }
            .navigationTitle("Edit Trip")
            .toolbar {
                saveToolbarItem
            }
        }
        .sheet(isPresented: $isImagePickerShowing) {
            ImagePicker(images: $inputImages)
        }
        Button(action: {
            
            if(trip.nameOwner == ownerFullName) {
                viewModel.uploadImages(inputImages) { urls in
                    trip.pictureURLs.append(contentsOf: urls)
                    saveAction(trip)
                    originalTrip = trip
                }
            }
            navigate = true
        }) {
            if(trip.nameOwner == ownerFullName) {
                
                Text("Save and Go to Detail View")
                    .font(.headline)
                    .foregroundColor(colorScheme == .light ? .white : .black)
                    .frame(maxWidth: .infinity, maxHeight: 52)
                    .background(colorScheme == .light ? Color.black : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Text("Go to Detail View")
                    .font(.headline)
                    .foregroundColor(colorScheme == .light ? .white : .black)
                    .frame(maxWidth: .infinity, maxHeight: 52)
                    .background(colorScheme == .light ? Color.black : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
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
    
    private var publicPrivateSection: some View {
        
        Section(header: Text("Trip Visibility")) {
            Picker("Visibility", selection: $trip.isPublic) {
                Text("Private").tag(false)
                Text("Public").tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: trip.isPublic) { newValue in
                trip.isPublic = newValue
                print("Trip visibility changed to: \(newValue ? "Public" : "Private")")
                
            }
        }
    }
    
    private var imageSection: some View {
        Section(header: Text("Pictures")) {
            if !trip.pictureURLs.isEmpty {
                GeometryReader { geometry in
                    TabView {
                        ForEach(trip.pictureURLs, id: \.self) { url in
                            AsyncImage(url: URL(string: url)) { image  in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        ForEach(inputImages, id: \.self) { uiImage in
                            Image(uiImage: uiImage)
                                .resizable()
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 300)
                }
                .frame(height: 300)
                
            }
            if(trip.nameOwner == ownerFullName) {
                Button("Add Images") {
                    isImagePickerShowing = true
                }
            }
        }
    }
    
    private var placeToVisitSection: some View {
        Section(header: Text("Places to Visit")) {
            List {
                ForEach(Array(trip.locations.enumerated()), id: \.offset) { index, location in
                    Text(location.name)
                }
                .onDelete(perform: deleteLocation)
                .onMove(perform: moveLocation)
                
            }
            if(trip.nameOwner == ownerFullName) {
                Button("Add Stop") {
                    isShowing.toggle()
                }
                .sheet(isPresented: $isShowing) {
                    SearchMapsView(isShowing: $isShowing) { location in
                        let lo = convertMapItemToLocation(mapItem: location)
                        trip.locations.append(lo)
                    }
                }
            }
           
        }
    }
    
    private var shareTripSection: some View {
        Section(header: Text("Share Trip")) {
            TextField("Enter email to share", text: $shareEmail)
            Button("Share") {
                shareTrip()
            }
            .disabled(shareEmail.isEmpty)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private var saveToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
                if NetworkMonitor.shared.isReachable {
                    viewModel.uploadImages(inputImages) { urls in
                        trip.pictureURLs.append(contentsOf: urls)
                        saveAction(trip)
                        originalTrip = trip
                        if let userId = viewModel.user?.id {
                            let orderedTripIds = viewModel.trips.map { $0.id }
                            viewModel.updateTripOrder(for: userId, with: orderedTripIds)
                        }
                    }
                } else {
                    showingAlert = true
                    alertMessage = "You are currently offline. Please connect to the internet to save changes."
                }
            }
            .disabled(trip.title.isEmpty || trip.locations.isEmpty || (trip.sharedWith.contains(viewModel.user?.id ?? "") && viewModel.user != nil))
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Offline"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func moveLocation(from source: IndexSet, to destination: Int) {
        trip.locations.move(fromOffsets: source, toOffset: destination)
    }
    
    private func deleteLocation(at offsets: IndexSet) {
        trip.locations.remove(atOffsets: offsets)
    }
    
    private func shareTrip() {
        guard !trip.sharedWith.contains(shareEmail) else {
            alertMessage = "Already shared with this email"
            showingAlert = true
            return
        }
        viewModel.shareTripWithEmail(tripId: trip.id, email: shareEmail) { success, message in
            if success {
                trip.sharedWith.append(shareEmail)
                alertMessage = "Trip shared successfully with \(shareEmail)"
                showingAlert = true
                shareEmail = ""
            } else {
                alertMessage = "Failed to share trip: \(message)"
                showingAlert = true
            }
        }
    }
    
    
    
    private func currentDate() -> Date {
        Date()
    }
}
