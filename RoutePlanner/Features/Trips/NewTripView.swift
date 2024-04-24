import SwiftUI
import MapKit

struct NewTripView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isShowing = false
    @State private var startDate = Date()
    @State private var title = String()
    @State private var locations: [MKMapItem] = []
    @EnvironmentObject var viewModel: ViewModel
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var selectedImages: [UIImage] = []
    @State private var isImagePickerShowing = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("Trip Title", text: $title)
                }
                
                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: $startDate, in: Date()..., displayedComponents: .date)
                }
                
                Section(header: Text("Images")) {
                    Button("Add Images") {
                        isImagePickerShowing = true
                    }
                    if !selectedImages.isEmpty {
                        TabView {
                            
                            ForEach(selectedImages, id: \.self) { uiImage in
                                Image(uiImage: uiImage)
                                    .resizable()
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .frame(height: 300)
                    }
                }
                
                Section(header: Text("Places to Visit")) {
                    List {
                        ForEach(locations, id: \.self) { mapItem in
                            Text(mapItem.name ?? "Unknown Location")
                        }
                        .onDelete(perform: deleteLocation)
                    }
                    
                    Button(action: {
                        isShowing.toggle()
                    }) {
                        Label("Add Stop", systemImage: "plus.circle.fill")
                    }
                    .sheet(isPresented: $isShowing) {
                        SearchMapsView(isShowing: $isShowing) { location in
                            locations.append(location)
                        }
                    }
                }
            }
            .navigationTitle("Add New Trip")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTrip()
                    }
                    .disabled(title.isEmpty || locations.isEmpty)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $isImagePickerShowing) {
                ImagePicker(images: $selectedImages)
            }
        }
    }
    
    private func deleteLocation(at offsets: IndexSet) {
        locations.remove(atOffsets: offsets)
    }
    
    private func saveTrip() {
        if selectedImages.isEmpty {
            saveTripWithImageURLs([])
        } else {
            viewModel.uploadImages(selectedImages) { urls in
                saveTripWithImageURLs(urls)
            }
        }
    }
    
    private func saveTripWithImageURLs(_ urls: [String]) {
        let ownerFullName = [viewModel.user?.firstName, viewModel.user?.lastName].compactMap { $0 }.joined(separator: " ")
        let locationObjects = convertMapItemsToLocations(mapItems: locations)
        let newTrip = Trip(id: UUID().uuidString, title: title, startDate: startDate, locations: locationObjects, ownerId: viewModel.user?.id ?? "", sharedWith: [], pictureURLs: urls, isPublic: false, nameOwner: ownerFullName)
        print(urls)
        viewModel.addTrip(trip: newTrip) { success, message in
            DispatchQueue.main.async {
                if success {
                    dismiss()
                } else {
                    alertMessage = message
                    showingAlert = true
                }
            }
        }
    }
}
