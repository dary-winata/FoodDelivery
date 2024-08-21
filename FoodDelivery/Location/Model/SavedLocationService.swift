//
//  SavedLocationService.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 20/08/24.
//

import Foundation

struct SavedLocation {
    let latitude: Double
    let longitude: Double
    let locationName: String
    let locationDetails: String
}

class SavedLocationService {
    static let shared: SavedLocationService = SavedLocationService()
    
    func getSavedLocation() -> SavedLocation? {
        let savedLat = UserDefaults.standard.double(forKey: "savedLatitude")
        let savedLong = UserDefaults.standard.double(forKey: "savedLongitude")
        let savedName = UserDefaults.standard.string(forKey: "savedName")
        let savedDetails = UserDefaults.standard.string(forKey: "savedDetails")
        
        guard let savedName, let savedDetails, savedLat != 0.0, savedLong != 0.0 else {return nil}
        
        let savedLocation: SavedLocation = SavedLocation(latitude: savedLat,
                                                         longitude: savedLong,
                                                         locationName: savedName,
                                                         locationDetails: savedDetails)
        
        return savedLocation
    }
    
    func savedLocation(savedLocation: SavedLocation) {
        UserDefaults.standard.setValue(savedLocation.latitude, forKey: "savedLatitude")
        UserDefaults.standard.setValue(savedLocation.longitude, forKey: "savedLongitude")
        UserDefaults.standard.setValue(savedLocation.locationName, forKey: "savedName")
        UserDefaults.standard.setValue(savedLocation.locationDetails, forKey: "savedDetails")
    }
}
