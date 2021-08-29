//
//  MapsViewController.swift
//  Navigation
//
//  Created by Dmitrii KRY on 29.08.2021.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import SnapKit

class MapsViewController: UIViewController {
    
    weak var coordinator: MapsCoordinator?
    
    private lazy var locationManager: CLLocationManager = {
        let location = CLLocationManager()
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBest
        return location
    }()
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        return map
    }()
    
    lazy var searchBar: UITextField = {
        let view = UITextField()
        view.textColor = .black
        view.tintColor = UIColor.init(named: "accentColor")
        view.layer.borderWidth = 0.5
        view.addInternalPaddings(left: 10, right: 10)
        view.autocapitalizationType = .none
        view.backgroundColor = .white
        view.placeholder = "Search"
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.leftView = searchBtn
        view.leftView?.snp.makeConstraints { make in
            make.height.width.equalTo(50)
        }
        return view
    }()
    
    let searchBtn: UIButton = {
        let image = UIImage(systemName: "magnifyingglass")
        let view = UIButton(type: .system)
        view.setImage(image, for: .normal)
        view.backgroundColor = .white
        view.addTarget(self, action: #selector(getLocationFromSearchBar), for: .touchUpInside)
        return view
    }()
    
    let myLocationBtn: UIButton = {
        let image = UIImage(systemName: "location")
        let view = UIButton(type: .system)
        view.setImage(image, for: .normal)
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(mapView, searchBar, myLocationBtn)
        requestAccessToGeo()
        setupConstraints()
    }
    
    func setCurrentLocationAction() {
            
            guard let currentLocation = locationManager.location
                else { return }
            
            currentLocation.lookUpLocationName { (name) in
                self.updateLocationOnMap(to: currentLocation, with: name)
            }
        }
    
    func updateLocationOnMap(to location: CLLocation, with title: String?) {
        
        let point = MKPointAnnotation()
        point.title = title
        point.coordinate = location.coordinate
        mapView.removeAnnotations(self.mapView.annotations)
        mapView.addAnnotation(point)
        
        let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(viewRegion, animated: true)
    }
    
    func updatePlaceMark(to address: String) {
           
           let geoCoder = CLGeocoder()
           geoCoder.geocodeAddressString(address) { (placemarks, error) in
               guard
                   let placemark = placemarks?.first,
                   let location = placemark.location
               else { return }
               
               self.updateLocationOnMap(to: location, with: address)
           }
       }
    
    @objc func getCurrentLocation() {
//        updateLocationOnMap(to: locationManager.location ?? CLLocation(), with: "Я")
        setCurrentLocationAction()
    }
    
    @objc func getLocationFromSearchBar() {
        updatePlaceMark(to: searchBar.text ?? "")
        searchBar.text = nil
    }
    
    func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.width.equalTo(400)
            make.height.equalTo(50)
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        
        myLocationBtn.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(30)
        }
    }
    
    private func requestAccessToGeo() {
        if #available(iOS 14.0, *) {
            switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                
            case .denied, .restricted:
                let alert = UIAlertController(
                    title: "Сервис выключен",
                    message: "Пожалуйста, включите в настройках",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.present(alert, animated: true, completion: nil)
                }
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            @unknown default:
                break
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
}

extension MapsViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        // Указываем желательный уровень масштабирования карты
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        // Прямоугольный географический регион с центром на определенной широте и долготе.
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed to update \(error)")
    }
    
}

extension CLLocation {
    
    func lookUpPlaceMark(_ handler: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(self) { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                handler(firstLocation)
            }
            else {
                handler(nil)
            }
        }
    }
    
    func lookUpLocationName(_ handler: @escaping (String?) -> Void) {
        var fullAddress: String?
        
        lookUpPlaceMark { placemark in
            fullAddress = "\(placemark?.locality ?? "") \(placemark?.thoroughfare ?? "") \(placemark?.subThoroughfare ?? "")"
            handler(fullAddress)
        }
    }
}

extension MapsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        annotationView.markerTintColor = UIColor.blue
        return annotationView
    }
    
}


