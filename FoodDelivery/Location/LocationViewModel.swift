//
//  LocationViewModel.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 20/08/24.
//

import CoreLocation
import MapKit
import Foundation

protocol LocationViewModelDelegate: AnyObject {
    func setupView()
    func updateMapRegion(region: MKCoordinateRegion)
    func setAnnotation(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?)
    func reloadData()
    func popViewController()
}

protocol LocationViewModelProtocol: AnyObject {
    var delegate: LocationViewModelDelegate? {get set}
    var action: LocationViewModelAction? {get set}
    func getLocationList() -> [LocationCellModel]
    func onViewDidLoad()
    func onSearchValueDidChanged(text: String)
    func onLocationCellDidTapped(index: Int)
    func onMapViewDidChangeState(annotation: MKPointAnnotation)
    func onSetLocationButtonDidTapped()
}

protocol LocationViewModelAction: AnyObject {
    func onLocationPageDidPop()
}

class LocationViewModel: NSObject, LocationViewModelProtocol {
    
    private let locationManager: CLLocationManager = CLLocationManager()
    weak var delegate: LocationViewModelDelegate?
    weak var action: LocationViewModelAction?
    private var locationList: [LocationCellModel] = []
    private var searchLocationMapItems: [MKMapItem] = []
    private var selectedLocation: SavedLocation?
    
    func onViewDidLoad() {
        delegate?.setupView()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        setupSavedLocation()
    }
    
    func getLocationList() -> [LocationCellModel] {
        return locationList
    }
    
    func onSearchValueDidChanged(text: String) {
        if text.isEmpty {
            locationList = []
            delegate?.reloadData()
        } else {
            fetchLocationSearch(text: text)
        }
    }
    
    func onLocationCellDidTapped(index: Int) {
        updateSelectedLocation(coordinate: searchLocationMapItems[index].placemark.coordinate, title: searchLocationMapItems[index].placemark.name, subtitle: searchLocationMapItems[index].placemark.subtitle)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: searchLocationMapItems[index].placemark.coordinate,
                                                            latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        delegate?.setAnnotation(coordinate: searchLocationMapItems[index].placemark.coordinate,
                                title: searchLocationMapItems[index].placemark.name ?? "",
                                subtitle: searchLocationMapItems[index].placemark.title ?? "")
        delegate?.updateMapRegion(region: region)
    }
    
    func onMapViewDidChangeState(annotation: MKPointAnnotation) {
        reverseGeocodeCoordinate(annotation.coordinate) { title, subtitle in
            self.updateSelectedLocation(coordinate: annotation.coordinate, title: title, subtitle: subtitle)
            annotation.title = title
            annotation.subtitle = title
        }
    }
    
    func onSetLocationButtonDidTapped() {
        guard let selectedLocation else { return }
        // save location to local
        SavedLocationService.shared.savedLocation(savedLocation: selectedLocation)
        // pop location view controller
        delegate?.popViewController()
        action?.onLocationPageDidPop()
    }
}

private extension LocationViewModel {
    func fetchLocationSearch(text: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] response, error in
            guard let self else { return }
            if let response {
                searchLocationMapItems = response.mapItems
                self.locationList = convertMapItemToListOfLocationCellModel(mapItems: response.mapItems)
                delegate?.reloadData()
            } else {
                print("\(error?.localizedDescription ?? "")")
            }
        }
    }
    
    func convertMapItemToListOfLocationCellModel(mapItems: [MKMapItem]) -> [LocationCellModel] {
        var listCell: [LocationCellModel] = []
        for mapItem in mapItems {
            let cellModel: LocationCellModel = LocationCellModel(locationName: mapItem.placemark.name ?? "",
                                                                 locationDetails: mapItem.placemark.thoroughfare ?? "")
            listCell.append(cellModel)
        }
        return listCell
    }
    
    func setupSavedLocation() {
        guard let savedLocation: SavedLocation = SavedLocationService.shared.getSavedLocation() else { return }
        let cellModel: LocationCellModel = LocationCellModel(locationName: savedLocation.locationName, locationDetails: savedLocation.locationName)
        locationList = [cellModel]
        delegate?.reloadData()
    }
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completion: @escaping (String?, String?) -> Void) {
        let geocode = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocode.reverseGeocodeLocation(location) { placemarks, error in
            if let error {
                print("Georeverse code error \(error.localizedDescription)")
                completion(nil, nil)
                return
            }
            var nameText: String = ""
            var descriptionText: String = ""
            
            if let placemark = placemarks?.first {
                if let name = placemark.name {
                    nameText += name
                }
                if let locality = placemark.locality {
                    descriptionText += locality
                }
                
                if let administrativeArea = placemark.administrativeArea {
                    descriptionText += ", " + administrativeArea
                }
                
                if let postalCode = placemark.postalCode {
                    descriptionText += ", " + postalCode
                }
                if let country = placemark.country {
                    descriptionText += ", " + country
                }
                completion(nameText, descriptionText)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    func updateSelectedLocation(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        selectedLocation = SavedLocation(latitude: coordinate.latitude, longitude: coordinate.longitude, locationName: title ?? "", locationDetails: subtitle ?? "")
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {return}
        //set current location ke MKMapview
        let region: MKCoordinateRegion = MKCoordinateRegion(center: currentLocation.coordinate,
                                                            latitudinalMeters: 1000, longitudinalMeters: 1000)
        //set user location pin
        // reverse geocode
        reverseGeocodeCoordinate(currentLocation.coordinate) { title, subtitle in
            self.updateSelectedLocation(coordinate: currentLocation.coordinate, title: title, subtitle: subtitle)
            self.delegate?.setAnnotation(coordinate: currentLocation.coordinate,
                                         title: title,
                                         subtitle: subtitle)
        }
        delegate?.updateMapRegion(region: region)
        locationManager.stopUpdatingLocation()
    }
}
