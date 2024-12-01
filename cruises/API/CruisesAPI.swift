//
//  CruisesAPI.swift
//  cruises
//
//  Created by Manuel Braun on 21.11.24.
//

import Foundation

enum HttpError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
}

struct Cruises: Codable {
    var cruises: [Cruise]
}

struct Cruise: Codable {
    var id: Int
    var title: String
    var description: String
    var departureDate: Date
    var arrivalDate: Date
    var startingPort: String
    var destinationPort: String
}

class CruisesAPI: ObservableObject {
    
    let cruisesIds = Array(1...20)
    @Published var titles: [Int: String] = [:]
    
    func getTitle(for tripId: Int) -> String? {
        return titles[tripId]
    }
    
    func loadTitle(for tripId: Int) async {
        do {
            let title = try await getSingleCruise(tripId: tripId).title
            DispatchQueue.main.async {
                self.titles[tripId] = title
            }
        } catch {
            print("Error loading title: \(tripId): \(error)")
        }
    }
    
    
    ///  Downloads the Cruise data with the id from the database
    /// - Parameter tripId: id from the Cruise you want to fetch
    /// - Returns: the Cruise with the given id
    func getSingleCruise(tripId: Int) async throws -> Cruise {
        
        let urlString = "https://cruise-api.manuel-braun.net/api.php?tripId=\(tripId)"
        guard let url = URL(string: urlString) else { throw HttpError.invalidUrl }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw HttpError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let cruises = try decoder.decode([Cruise].self, from: data) 
            guard let firstCruise = cruises.first else {
                    throw HttpError.invalidData
                }
            return firstCruise
        } catch {
            throw HttpError.invalidData
        }
    }
}
