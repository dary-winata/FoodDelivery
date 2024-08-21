//
//  LocationViewController.swift
//  FoodDelivery
//
//  Created by dary winata nugraha djati on 20/08/24.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {
    
    private lazy var mapView: MKMapView = {
        let map: MKMapView = MKMapView(frame: .zero)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        
        return map
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let textField: UISearchTextField = UISearchTextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(searchTextFieldValueDidChanged), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var locationTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LocationCell.self, forCellReuseIdentifier: "location")
        
        return tableView
    }()
    
    private lazy var setLocationButton: UIButton = {
        let btn: UIButton = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btn.setTitle("Set Location", for: .normal)
        btn.setTitleColor(UIColor(ciColor: .black), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 10
        btn.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 250)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(setLocationButtonDidTapped), for: .touchUpInside)
        
        return btn
    }()
    
    let viewModel: LocationViewModelProtocol
    
    init(viewModel: LocationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
    }
}

extension LocationViewController: LocationViewModelDelegate {
    func setupView() {
        view.backgroundColor = .white
        title = "Set Location"
        
        view.addSubview(mapView)
        view.addSubview(searchTextField)
        view.addSubview(locationTableView)
        view.addSubview(setLocationButton)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor),
            
            searchTextField.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            locationTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            locationTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            locationTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationTableView.bottomAnchor.constraint(equalTo: setLocationButton.topAnchor, constant: -16),
            
            setLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            setLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            setLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func updateMapRegion(region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
    
    func setAnnotation(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        let annotationView: MKPointAnnotation = MKPointAnnotation()
        annotationView.coordinate = coordinate
        annotationView.title = title // nama tempat
        annotationView.subtitle = subtitle // nama jalan
        if let existingAnnotation = mapView.annotations.first {
            mapView.removeAnnotation(existingAnnotation)
        }
        mapView.addAnnotation(annotationView)
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}

extension LocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let identifier: String = "draggablePin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.isDraggable = true
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        // hasil drag
        if newState == .ending {
            if let annotation = view.annotation as? MKPointAnnotation {
                viewModel.onMapViewDidChangeState(annotation: annotation)
            }
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.locationTableView.reloadData()
        }
    }
}

extension LocationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getLocationList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "location") as? LocationCell else {
            return UITableViewCell()
        }
        
        cell.setupCellModel(cellModel: viewModel.getLocationList()[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onLocationCellDidTapped(index: indexPath.row)
    }
}

private extension LocationViewController {
    @objc
    func searchTextFieldValueDidChanged() {
        viewModel.onSearchValueDidChanged(text: searchTextField.text ?? "")
    }
    
    @objc
    func setLocationButtonDidTapped() {
        viewModel.onSetLocationButtonDidTapped()
    }
}

