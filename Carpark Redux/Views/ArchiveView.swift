//
//  SettingsView.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 1/3/24.
//

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
                        ArchivedSpotView(spot: spot)
                    } label: {
                        VStack(alignment: .leading, content: {
                            Text(spot.date.formatted())
                        })
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
