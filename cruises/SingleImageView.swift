//
//  SingleImageView.swift
//  cruises
//
//  Created by Manuel Braun on 23.11.24.
//

import Foundation
import SwiftUI


struct SingleImageView: View {
    let imageId: Int
    let tripId: Int
    let imageApi: ImagesAPI
    @State private var imageUrl: String?
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if let url = imageUrl {
                AsyncImage(url: URL(string: url)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
            } else  {
                ProgressView()
            }
        }
        .task {
            do {
                imageUrl = try await imageApi.getSingleImage(imageId: imageId, tripId: tripId).imageUrl
            } catch {
                imageUrl = nil
            }
            
        }
    }
}
