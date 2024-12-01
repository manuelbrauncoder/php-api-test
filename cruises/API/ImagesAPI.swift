//
//  ImagesAPI.swift
//  cruises
//
//  Created by Manuel Braun on 22.11.24.
//

import Foundation

struct CruiseImages: Codable {
    var images: [CruiseImage]
}

struct CruiseImage: Codable {
    var id: Int
    var tripId: Int
    var imageUrl: String
}

struct ImageId: Codable, Identifiable, Hashable {
    var id: Int
}

struct ImageIds: Codable {
    var ids: [ImageId]
}

class ImagesAPI: ObservableObject {
    
    
    func getSingleImage(imageId: Int, tripId: Int) async throws -> CruiseImage {
        let urlString = "https://cruise-api.manuel-braun.net/api-images.php?imgId=\(imageId)&tripId=\(tripId)"
        
        guard let url = URL(string: urlString) else { throw HttpError.invalidUrl }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw HttpError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let images = try decoder.decode([CruiseImage].self, from: data)
            guard let firstImage = images.first else {
                throw HttpError.invalidData
            }
            return firstImage
        } catch {
            throw HttpError.invalidData
        }
    }
    
    func getImageIds(tripId: Int) async throws -> [ImageId] {
        let urlString = "https://cruise-api.manuel-braun.net/api-image-id.php?tripId=\(tripId)"
        guard let url = URL(string: urlString) else { throw HttpError.invalidUrl}
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw HttpError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([ImageId].self, from: data)
            
        } catch {
            throw HttpError.invalidData
        }
    }
}
