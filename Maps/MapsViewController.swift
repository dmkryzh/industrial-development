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
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.delegate = self
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(pinLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 1
        view.addGestureRecognizer(gestureRecognizer)
        return view
    }()
    
    private lazy var searchBar: UITextField = {
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
    
    private let searchBtn: UIButton = {
        let image = UIImage(systemName: "magnifyingglass")
        let view = UIButton(type: .system)
        view.setImage(image, for: .normal)
        view.backgroundColor = .white
        view.addTarget(self, action: #selector(getLocationFromSearchBar), for: .touchUpInside)
        return view
    }()
    
    private let myLocationBtn: UIButton = {
        let image = UIImage(systemName: "location")
        let view = UIButton(type: .system)
        view.setImage(image, for: .normal)
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
        return view
    }()
    
    private let searchRoute: UIButton = {
        let image = UIImage(systemName: "map")
        let view = UIButton(type: .system)
        view.setImage(image, for: .normal)
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.addTarget(self, action: #selector(calculateRoute), for: .touchUpInside)
        return view
    }()
    
    private let removePins: UIButton = {
        let image = UIImage(systemName: "xmark.circle")
        let view = UIButton(type: .system)
        view.setImage(image, for: .normal)
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.addTarget(self, action: #selector(removeAnnotation), for: .touchUpInside)
        return view
    }()
    
    private let zoomIn: UIButton = {
        let image = UIImage(systemName: "plus.magnifyingglass")
        let view = UIButton(type: .system)
        view.setImage(image, for: .normal)
        view.backgroundColor = .white
        view.layer.borderWidth = 1
//        view.layer.cornerRadius = 5
        view.addTarget(self, action: #selector(zoomInAction), for: .touchUpInside)
        return view
    }()
    
    private let zoomOut: UIButton = {
        let image = UIImage(systemName: "minus.magnifyingglass")
        let view = UIButton(type: .system)
        view.setImage(image, for: .normal)
        view.backgroundColor = .white
        view.addTarget(self, action: #selector(zoomOutAction), for: .touchUpInside)
        return view
    }()
    
    lazy var stackZoom: UIStackView = {
        let stackLogPas = UIStackView(arrangedSubviews: [zoomIn, zoomOut])
        stackLogPas.alignment = .fill
        stackLogPas.distribution = .fillEqually
        stackLogPas.axis = .vertical
        stackLogPas.spacing = 0
        stackLogPas.layer.cornerRadius = 3
        stackLogPas.layer.borderWidth = 1
        stackLogPas.layer.masksToBounds = true
        stackLogPas.backgroundColor = .white
        return stackLogPas
    }()
    
    private var pointsCounter = 0
    
    private var locations = [CLLocationCoordinate2D]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(mapView, searchBar, myLocationBtn, searchRoute, removePins, stackZoom)
        requestAccessToGeo()
        setupConstraints()
        title = "Карты"
    }
    
    // MARK: Constraints
    private func setupConstraints() {
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
        
        searchRoute.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.equalTo(myLocationBtn.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(30)
        }
        
        removePins.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.equalTo(searchRoute.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(30)
        }
        
        stackZoom.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(60)
            make.top.equalTo(removePins.snp.bottom).offset(30)
            make.centerX.equalTo(removePins.snp.centerX)
        }
    }
    
    
    // MARK: Functions
    @objc func calculateRoute() {
        guard locations.count == 2 else { return }
        showRouteOnMap(pickupCoordinate: locations.first!, destinationCoordinate: locations.last!)
    }
    
    @objc func zoomInAction() {
        var region: MKCoordinateRegion = self.mapView.region
        var span: MKCoordinateSpan = mapView.region.span
          span.latitudeDelta /= 2
          span.longitudeDelta /= 2
          region.span = span
          mapView.setRegion(region, animated: true)
    }
    
    @objc func zoomOutAction() {
        var region: MKCoordinateRegion = self.mapView.region
        var span: MKCoordinateSpan = mapView.region.span
          span.latitudeDelta *= 2
          span.longitudeDelta *= 2
          region.span = span
          mapView.setRegion(region, animated: true)
    }
    
    @objc func removeAnnotation() {
        let annotations = mapView.annotations.filter({ !($0 is MKUserLocation) })
        mapView.removeAnnotations(annotations)
        mapView.removeOverlays(mapView.overlays)
        locations = []
    }
    
    @objc func pinLocation(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            
            let touchPoint = gestureRecognizer.location(in: mapView)
            let touchCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinates
            annotation.title = "Точка № \(pointsCounter += 1)"
            annotation.subtitle = "Новая точка на карте"
            
            self.mapView.addAnnotation(annotation)
            locations.append(touchCoordinates)
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
    
    private func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            //for getting just one route
            if let route = unwrappedResponse.routes.first {
                //show on map
                self.mapView.addOverlay(route.polyline)
                //set the map area to show the route
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
            }
            
            //if you want to show multiple routes then you can get all routes in a loop in the following statement
            //for route in unwrappedResponse.routes {}
        }
    }
    
    private func setCurrentLocationAction() {
        
        guard let currentLocation = locationManager.location
        else { return }
        
        currentLocation.lookUpLocationName { (name) in
            self.updateLocationOnMap(to: currentLocation, with: name)
        }
        locations.append(currentLocation.coordinate)
    }
    
    private func updateLocationOnMap(to location: CLLocation, with title: String?) {
        
        let point = MKPointAnnotation()
        point.title = title
        point.coordinate = location.coordinate
        mapView.removeAnnotations(self.mapView.annotations)
        mapView.addAnnotation(point)
        
        let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(viewRegion, animated: true)
    }
    
    private func updatePlaceMark(to address: String) {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemark = placemarks?.first,
                let location = placemark.location
            else { return }
            
            self.updateLocationOnMap(to: location, with: address)
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
                let firstLocation = placemarks?.first
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = UIColor.red
        render.lineWidth = 10
        render.fillColor = UIColor(red: 0, green: 0.7, blue: 0.9, alpha: 0.5)
        render.lineCap = .round
        
        return render
    }
    
    
}



