//
//  ContentView.swift
//  cruises
//
//  Created by Manuel Braun on 21.11.24.
//

import SwiftUI

struct CruisesList: View {
    
    @StateObject private var api = CruisesAPI()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(api.cruisesIds, id: \.self) { tripId in
                    NavigationLink(destination: CruiseDetailView(cruiseId: tripId)) {
                        if let title = api.getTitle(for: tripId) {
                            Text(title)
                                .font(.headline)
                        } else {
                            ProgressView()
                        }
                    }
                    .padding()
                    .task {
                        await api.loadTitle(for: tripId)
                    }
                }
            }
            .navigationTitle("Übersicht")
        }
    }
    
    
    
    
}

#Preview {
    CruisesList()
}
