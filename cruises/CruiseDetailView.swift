//
//  CruiseDetailView.swift
//  cruises
//
//  Created by Manuel Braun on 22.11.24.
//

import SwiftUI

struct CruiseDetailView: View {
    
    var cruiseId: Int
    @State private var cruise: Cruise?
    @State private var image: CruiseImage?
    @State private var imageIds: [ImageId] = []
    @State private var noImagesAvailable = false
    
    @StateObject private var api = CruisesAPI()
    @StateObject private var imageApi = ImagesAPI()
    @State private var isLoading = true
    
    @State private var imgUrls: [String] = []
    
    
    var body: some View {
        
        VStack {
            if isLoading {
                ProgressView()
            } else {
                List {
                    Section("Beschreibung") {
                        Text(cruise!.description)
                    }
                    Section("Zeitraum") {
                        Text("von \(cruise!.arrivalDate.formatted()) bis \(cruise!.departureDate.formatted())")
                    }
                    Section("Ort") {
                        Text("Start: \(cruise!.startingPort)")
                        Text("Ziel: \(cruise!.destinationPort)")
                    }
                    
                    if !imageIds.isEmpty {
                        Section("Bilder") {
                            ScrollView(.horizontal) {
                                LazyHStack(spacing: 10) {
                                    ForEach(imageIds, id: \.id) { imageId in
                                        SingleImageView(imageId: imageId.id, tripId: cruiseId, imageApi: imageApi)
                                            .frame(width: 150, height: 150)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            }
                        }
                    }
                    if noImagesAvailable {
                        Section("Bilder") {
                            Text("Keine Bilder verfügbar")
                        }
                    }
                    
                }
                .navigationTitle(cruise!.title)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear {
            Task {
                do {
                    cruise = try await api.getSingleCruise(tripId: cruiseId)
                    isLoading = false
                } catch {
                    print("Error loading data: \(error.localizedDescription)")
                }
                do {
                    imageIds = try await imageApi.getImageIds(tripId: cruiseId)
                } catch {
                    noImagesAvailable = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CruiseDetailView(cruiseId: 1)
    }
    
}
