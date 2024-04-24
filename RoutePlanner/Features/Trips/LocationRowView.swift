import SwiftUI

struct LocationRowView: View {
    var trip: Trip

    var body: some View {
        HStack(spacing: 15) {
            if let urlString = trip.pictureURLs.first, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 110, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Image("placeholder")  
                    .resizable()
                    .frame(width: 110, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            VStack(alignment: .leading) {
                Text(trip.title)
                    .font(.headline)
                    .lineLimit(2)

                Text("By \(trip.nameOwner)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("By \(trip.startDate.formatted(date: .abbreviated, time: .shortened))") 
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
    }
}
