import SwiftUI
import SwiftData

struct ArchiveView: View {
    @Query(sort: [SortDescriptor(\ParkingSpot.date, order: .reverse)]) var spots: [ParkingSpot]
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(spots) { spot in
                    NavigationLink {
                        ParkingSpotDetailView(spot: spot)
                    } label: {
                        ArchiveRowLabel(spot: spot)
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        withAnimation {
                            modelContext.delete(spots[index])
                        }
                    }
                })
            }
            .navigationTitle("Past Parking Spots")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ArchiveView()
}
