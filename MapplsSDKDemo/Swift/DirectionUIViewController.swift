import UIKit
import MapplsMap
import MapplsAPIKit
import MapplsUIWidgets
import MapplsDirectionUI

class DirectionUIViewController: UIViewController {
    
    

    var mapView: MapplsDirectionMapView!
    var placeBottomSheet: UIView!
    var placeNameLabel: UILabel!
    var placeAddressLabel: UILabel!
    var mapplsPinIcon: UIButton!
    var mapplsPinLabel: UILabel!
    var destinationDistaceLabel: UILabel!
    var destinationIcon: UIImageView!
    var timeRequiredLabel: UILabel!
    var timeRequiredIcon: UIImageView!
    var directionButton: UIButton!
    let directions: Directions! = nil
    var searchView: UIView!
    var searchTextView: UILabel!
    var crossButton: UIButton!
    var searchButton: UIButton!
    var sideLine: UIButton!
    var  currentLocationButton: UIButton!
    var tableView: UITableView!
    var tableViewheight = 100
    var noLocationButton: UIButton!
    var locationModel = [MapplsDirectionLocation]()
    var bottomBannerView: MapplsDirectionBottomBannerView!
    var navigationView: UIView!
    var dirAttributions : MapplsAttributeOptions = []
    
    var waypoints: [Waypoint] = [] {
        didSet {
            waypoints.forEach {
                $0.coordinateAccuracy = -1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settingsBarButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButtonTapped))
        self.navigationItem.rightBarButtonItems = [settingsBarButton]
        
        mapView = MapplsDirectionMapView(frame: self.view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.coronaNovalButton.isHidden = true
        mapView.coronaNovalButtonMargins.y = 200
        mapView.delegate = self
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        setUpSearchViewLayout()
        searchTextView.isUserInteractionEnabled = true
        let gestureRecoognizor = UITapGestureRecognizer(target: self, action: #selector(onSearchViewTaped))
        searchTextView.addGestureRecognizer(gestureRecoognizor)
        
        setUpButtonSheetLayout()
        setUpCurrentLocationLayout()
        setupTestButtonsLayout()
        directionButton.addTarget(self, action: #selector(directionButtonClicked), for: .touchUpInside)
    }
    @objc func settingsButtonTapped(sender: UIBarButtonItem) {
        let vc = LocationChooserTableViewDirectionUIPlugin()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        directionButton.setGradientBackground(firstColor: UIColor(rgb: 0xE52629), secondColor: UIColor(rgb: 0xEC672C))
        currentLocationButton.layer.cornerRadius = currentLocationButton.bounds.width / 2
        currentLocationButton.tintColor = .black
    }
    
    func removeAllAnnotations() {
        guard let annotations = mapView.annotations else { return print("Annotations Error") }
        
        if annotations.count != 0 {
            for annotation in annotations {
                mapView.removeAnnotation(annotation)
            }
        } else {
            return
        }
    }
    
    
    func setUpSearchViewLayout(){
        
        searchView = UIView()
        mapView.addSubview(searchView)
        
        noLocationButton = UIButton()
        noLocationButton.setImage(UIImage(named: "ic_home_directions_accent_28"), for: .normal)
        noLocationButton.addTarget(self, action: #selector(noLocationButtonClicked), for: .touchUpInside)
        searchView.addSubview(noLocationButton)
        
        searchTextView = UILabel()
        searchView.addSubview(searchTextView)
        
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchView.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        searchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        searchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        if #available(iOS 11.0, *) {
            searchView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        } else {
            searchView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        }
        searchView.backgroundColor = UIColor.white
        searchView.layer.cornerRadius = 4

        noLocationButton.translatesAutoresizingMaskIntoConstraints = false
        noLocationButton.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -7).isActive = true
        noLocationButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        noLocationButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
       
        searchTextView.translatesAutoresizingMaskIntoConstraints = false
        searchTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchTextView.trailingAnchor.constraint(equalTo: noLocationButton.leadingAnchor).isActive = true
        searchTextView.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 7).isActive = true
        searchTextView.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchTextView.text = "Search for place & Mappls Pins"
        searchTextView.textColor = UIColor.gray
    }
    
    @objc func onSearchViewTaped() {
        let autocompleteViewController = getAutocompleteViewControllerInstance()
        self.navigationController?.navigationBar.isHidden = false
        
        autocompleteViewController.delegate = self
        if let navigation = self.navigationController {
            navigation.pushViewController(autocompleteViewController, animated: true)
        }
        else {
            self.present(autocompleteViewController, animated: false, completion: nil)
        }
    }
    
    @objc func directionButtonClicked() {
        let sy = DefaultStyle.init()
        let directionVC = MapplsDirectionViewController(for: locationModel, style: .auto)
        directionVC.delegate = self
        makeAttributionArray()
        directionVC.attributationOptions = dirAttributions
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(directionVC, animated: false)
    }
    @objc func noLocationButtonClicked() {
        locationModel.removeAll()
        let sy = DefaultStyle.init()
        let directionVC = MapplsDirectionViewController(for: locationModel, style: .auto)
        makeAttributionArray()
        directionVC.attributationOptions = dirAttributions
        directionVC.delegate = self
        self.navigationController?.pushViewController(directionVC, animated: false)
        self.navigationController?.navigationBar.isHidden = true
    }
    private func getAutocompleteViewControllerInstance() -> MapplsAutocompleteViewController {
        let autocompleteViewController = MapplsAutocompleteViewController()
        autocompleteViewController.delegate = self
        return autocompleteViewController
    }
    
    func setUpButtonSheetLayout() {
        placeBottomSheet = UIView()
        directionButton = UIButton()
        mapplsPinIcon = UIButton()
        mapplsPinLabel = UILabel()
        timeRequiredLabel = UILabel()
        timeRequiredIcon = UIImageView(image: UIImage(named: "timeRemening_icon"))
        destinationDistaceLabel = UILabel()
        destinationIcon = UIImageView(image: UIImage(named: "timeRemening_icon"))
        placeAddressLabel = UILabel()
        placeNameLabel = UILabel()
        
        mapView.addSubview(placeBottomSheet)
        placeBottomSheet.addSubview(directionButton)
        placeBottomSheet.addSubview(mapplsPinIcon)
        placeBottomSheet.addSubview(mapplsPinLabel)
        placeBottomSheet.addSubview(timeRequiredLabel)
        placeBottomSheet.addSubview(timeRequiredIcon)
        placeBottomSheet.addSubview(destinationDistaceLabel)
        placeBottomSheet.addSubview(destinationIcon)
        placeBottomSheet.addSubview(placeAddressLabel)
        placeBottomSheet.addSubview(placeNameLabel)
        
        placeBottomSheet.translatesAutoresizingMaskIntoConstraints = false
        placeBottomSheet.heightAnchor.constraint(equalToConstant: 190).isActive = true
        placeBottomSheet.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        placeBottomSheet.topAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        placeBottomSheet.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        placeBottomSheet.backgroundColor = UIColor.white
        
        directionButton.translatesAutoresizingMaskIntoConstraints = false
        directionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        directionButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        directionButton.bottomAnchor.constraint(equalTo: placeBottomSheet.bottomAnchor, constant: -7).isActive = true
        directionButton.leadingAnchor.constraint(equalTo: placeBottomSheet.leadingAnchor, constant: 30).isActive = true
        directionButton.trailingAnchor.constraint(equalTo: placeBottomSheet.trailingAnchor, constant: -30).isActive = true
        directionButton.setTitle("Directions", for: .normal)
        
        directionButton.layer.cornerRadius = 7
        directionButton.setImage(UIImage(named: "ic_directions_24px"), for: .normal)
        directionButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.view.bounds.width -  90  , bottom: 0, right: 0)
        
        mapplsPinIcon.translatesAutoresizingMaskIntoConstraints = false
        mapplsPinIcon.leadingAnchor.constraint(equalTo: placeBottomSheet.leadingAnchor,constant: 10).isActive = true
        mapplsPinIcon.bottomAnchor.constraint(equalTo: directionButton.topAnchor,constant: -20).isActive = true
        mapplsPinIcon.tintColor = .black
        mapplsPinIcon.backgroundColor = .white
        mapplsPinIcon.setImage(UIImage(named: "eloc_icon"), for: .normal)
                
        mapplsPinLabel.translatesAutoresizingMaskIntoConstraints = false
        mapplsPinLabel.attributedText = NSAttributedString(string: "mappls.com/9082EO", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        mapplsPinLabel.leadingAnchor.constraint(equalTo: mapplsPinIcon.trailingAnchor,constant: 0).isActive = true
        mapplsPinLabel.centerYAnchor.constraint(equalTo: mapplsPinIcon.centerYAnchor).isActive = true
        mapplsPinLabel.textColor = .systemBlue
        mapplsPinLabel.font = UIFont.init(name: "SFProText-Medium", size: 11)
        
        timeRequiredLabel.translatesAutoresizingMaskIntoConstraints = false
        timeRequiredLabel.trailingAnchor.constraint(equalTo: placeBottomSheet.trailingAnchor, constant: -10).isActive = true
        timeRequiredLabel.centerYAnchor.constraint(equalTo: mapplsPinLabel.centerYAnchor).isActive = true
        timeRequiredLabel.textColor = .black
        timeRequiredLabel.text = "9 mins(s)"
        timeRequiredLabel.font = UIFont.init(name: "SFProText-Medium", size: 13)
        
        timeRequiredIcon.translatesAutoresizingMaskIntoConstraints = false
        timeRequiredIcon.trailingAnchor.constraint(equalTo: timeRequiredLabel.leadingAnchor, constant: -3).isActive = true
        timeRequiredIcon.centerYAnchor.constraint(equalTo: mapplsPinLabel.centerYAnchor).isActive = true
        
        destinationDistaceLabel.translatesAutoresizingMaskIntoConstraints = false
        destinationDistaceLabel.trailingAnchor.constraint(equalTo: placeBottomSheet.trailingAnchor, constant: -10).isActive = true
        destinationDistaceLabel.bottomAnchor.constraint(equalTo: mapplsPinLabel.topAnchor, constant: -7).isActive = true
        destinationDistaceLabel.textColor = .black
        destinationDistaceLabel.text = "3.0 Kms"
        destinationDistaceLabel.font = UIFont.init(name: "SFProText-Medium", size: 16)
        
        destinationIcon.translatesAutoresizingMaskIntoConstraints = false
        destinationIcon.trailingAnchor.constraint(equalTo: destinationDistaceLabel.leadingAnchor, constant: -3).isActive = true
        destinationIcon.centerYAnchor.constraint(equalTo: destinationDistaceLabel.centerYAnchor).isActive = true
        
        placeAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        placeAddressLabel.leadingAnchor.constraint(equalTo: placeBottomSheet.leadingAnchor,constant: 10).isActive = true
        placeAddressLabel.bottomAnchor.constraint(equalTo: destinationIcon.topAnchor, constant: -10).isActive = true
        placeAddressLabel.text = "Sector 13, Hisar, Haryana, 125001"
        placeAddressLabel.textColor = .black
        placeAddressLabel.font = UIFont.init(name: "SFProText-Medium", size: 16)
        
        placeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        placeNameLabel.leadingAnchor.constraint(equalTo: placeBottomSheet.leadingAnchor,constant: 10).isActive = true
        placeNameLabel.bottomAnchor.constraint(equalTo: placeAddressLabel.topAnchor, constant: -7).isActive = true
        placeNameLabel.text = "Dabar Chowk Park"
        placeNameLabel.textColor = .black
        placeNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func setupTestButtonsLayout() {
     /*   let testButton1 = UIButton()
        testButton1.setTitle("Test with source & destination", for: .normal)
        testButton1.backgroundColor = .brown
        testButton1.addTarget(self, action: #selector(testButton1Clicked), for: .touchUpInside)
        self.view.addSubview(testButton1)
        
        let testButton2 = UIButton()
        testButton2.setTitle("Test with one waypoint", for: .normal)
        testButton2.backgroundColor = .darkGray
        testButton2.addTarget(self, action: #selector(testButton2Clicked), for: .touchUpInside)
        self.view.addSubview(testButton2)

        testButton1.translatesAutoresizingMaskIntoConstraints = false
        testButton1.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        testButton1.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 60).isActive = true
        testButton1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        testButton2.translatesAutoresizingMaskIntoConstraints = false
        testButton2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        testButton2.topAnchor.constraint(equalTo: testButton1.bottomAnchor, constant: 10).isActive = true
        testButton2.heightAnchor.constraint(equalToConstant: 30).isActive = true */
      
//        let customThemeWithTwoWayPoint = UIButton()
//        customThemeWithTwoWayPoint.setTitle("Custom Theme With Waypoints", for: .normal)
//        customThemeWithTwoWayPoint.backgroundColor = .gray
//        self.view.addSubview(customThemeWithTwoWayPoint)
//
//        customThemeWithTwoWayPoint.translatesAutoresizingMaskIntoConstraints = false
//        customThemeWithTwoWayPoint.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
//        customThemeWithTwoWayPoint.topAnchor.constraint(equalTo: self.searchView.bottomAnchor, constant: 10).isActive = true
//        customThemeWithTwoWayPoint.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        customThemeWithTwoWayPoint.addTarget(self, action: #selector(customThemeTest), for: .touchUpInside)
 
    }
     
   /* @objc func customThemeTest() {
        locationModel.removeAll()
        let locationModel = MapplsDirectionLocation(location: "77.2639,28.5354", displayName: "Govindpuri", displayAddress: "", locationType: .suggestion)
        let locationModel1 = MapplsDirectionLocation(location: "85.5013,26.5887", displayName: "Sitamarhi", displayAddress: "", locationType: .suggestion)
        self.locationModel.append(locationModel)
        self.locationModel.append(locationModel1)
        
        let directionVC = MapplsDirectionViewController(for: self.locationModel, style: NightStyle.init())
        MapplsDirectionBottomBannerView.appearance().backgroundColor = .gray
        MapplsDirectionTopBannerView.appearance().backgroundColor = .blue
        directionVC.resourceIdentifier = MapplsDirectionsResourceIdentifier(UserDefaultsManager.resourceIdentifier)
        directionVC.profileIdentifier = MapplsDirectionsProfileIdentifier(UserDefaultsManager.profileIdentifier)
        directionVC.delegate = self
        
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(directionVC, animated: false)
    } */
    
    func setUpCurrentLocationLayout() {
        currentLocationButton = UIButton()
        
        mapView.addSubview(currentLocationButton)
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        currentLocationButton.bottomAnchor.constraint(equalTo: placeBottomSheet.topAnchor, constant: -70).isActive = true
        currentLocationButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        currentLocationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        currentLocationButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentLocationButton.tintColor = .black
        currentLocationButton.setImage(UIImage(named: "FocusCurrentLocation"), for: .normal)
        currentLocationButton.backgroundColor = .white
        
        currentLocationButton.addTarget(self, action: #selector(currentLocationTapHandler(sender:)), for: .allEvents)
    }
    
    func bottomViewAnimateUp() {
        UIView.animate(withDuration: 0.2 , animations: {
            self.placeBottomSheet.transform = CGAffineTransform(translationX: 0, y: -190)
            self.mapView.logoView.transform = CGAffineTransform(translationX: 0, y: -160)
            self.currentLocationButton.transform = CGAffineTransform(translationX: 0, y: -160)
        })
    }
    
    @objc func makeAttributionArray() {
        dirAttributions = []
        print(UserDefaultsManager.isSpeed)
        print(UserDefaultsManager.isDistance)
        print(UserDefaultsManager.isCongestionLevel)
        print(UserDefaultsManager.isExpectedTravelTime)
        if UserDefaultsManager.isSpeed {
            dirAttributions.insert(.speed)
        }
        if UserDefaultsManager.isDistance {
            dirAttributions.insert(.distance)
        }
        if UserDefaultsManager.isCongestionLevel {
            dirAttributions.insert(.congestionLevel)
        }
        if UserDefaultsManager.isExpectedTravelTime {
            dirAttributions.insert(.expectedTravelTime)
        }
    }
    
    @objc func currentLocationTapHandler(sender: UIGestureRecognizer) {
        let userLocation = mapView.userLocation?.location?.coordinate
        print("userlocation \(String(describing: userLocation))")
        if mapView.userLocation?.location != nil {
            let coor = mapView.userLocation?.coordinate
            let initialCorr = CLLocationCoordinate2D(latitude: CLLocationDegrees(coor?.latitude ?? 00) , longitude: CLLocationDegrees(coor?.longitude ?? 00))
            
            mapView.setCenter(initialCorr, zoomLevel: 7, animated: false)
            let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, altitude: 4500, pitch: 15, heading: 180)
            mapView.setCamera(camera, withDuration: 2, animationTimingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        }
        else{
            guard URL(string: UIApplication.openSettingsURLString) != nil else {
                return
            }
            
            let alertController = UIAlertController (title: "Turn on location", message: "Go to Settings? turn on location", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction (title: "Settings", style: .default) { (_) -> Void in
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            self.navigationController?.present(alertController, animated: true, completion: nil)
        }
    }
}

extension DirectionUIViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        print(userLocation ?? 00)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "pisa")
        if annotationImage == nil {
        }
        
        return annotationImage
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}

extension DirectionUIViewController: MapplsAutocompleteViewControllerDelegate {
    func didAutocomplete(viewController: MapplsUIWidgets.MapplsAutocompleteViewController, withFavouritePlace place: MapplsUIWidgets.MapplsUIWidgetAutosuggestFavouritePlace) {
        
    }
    
    func didAutocomplete(viewController: MapplsAutocompleteViewController, withPlace place: MapplsAtlasSuggestion, resultType type: MapplsAutosuggestResultType) {
        navigationController?.navigationBar.isHidden = true
        navigationController?.popViewController(animated: false)
        searchTextView.text = place.placeAddress
        placeAddressLabel.text = place.placeAddress
        placeNameLabel.text = place.placeName
        mapplsPinLabel.text = "mappls.com/\(String(describing: place.mapplsPin ?? "create mapplsPin"))"
        
        
        removeAllAnnotations()
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: place.latitude!), longitude: CLLocationDegrees(truncating: place.longitude!))
        mapView.addAnnotation(point)
        bottomViewAnimateUp()
        
        let userLocationObject = CLLocation(latitude: CLLocationDegrees(truncating: place.latitude!), longitude: CLLocationDegrees(truncating: place.longitude!))
        let wayPoints = Waypoint(location: userLocationObject, name: "\(place.placeName ?? "not found")")
        self.locationModel.removeAll()
        var location: String = ""
        if let lon = place.longitude , let lat = place.latitude {
            location = "\(lon),\(lat)"
            mapView.setCenter(CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: place.latitude!), longitude: CLLocationDegrees(truncating: place.longitude!)), zoomLevel: 13, animated: false)
        } else {
            if let mapplsPin = place.mapplsPin {
                location = "\(mapplsPin)"
                mapView.setMapCenterAtMapplsPin(mapplsPin, zoomLevel: 13, animated: false, completionHandler: nil)
            }
        }

        let locationModel = MapplsDirectionLocation(location: location, displayName: place.placeName, displayAddress: place.placeAddress, locationType: .suggestion)
        self.locationModel.insert(locationModel, at: 0)
        waypoints.append(wayPoints)
    }
    
    func didFailAutocomplete(viewController: MapplsAutocompleteViewController, withError error: NSError) {
        
    }
    
    func wasCancelled(viewController: MapplsAutocompleteViewController) {
        self.navigationController?.navigationBar.isHidden = true
    }
    func didAutocomplete(tableDataSource: MapplsAutocompleteTableDataSource, withSuggestion suggestion: MapplsSearchPrediction) {
        
    }
    func didAutocomplete(viewController: MapplsAutocompleteViewController, withSuggestion suggestion: MapplsSearchPrediction) {
        
    }
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


extension DirectionUIViewController: LocationChooserTableViewDirectionUIPluginDelegate {
    func locationsPikcedForDistancesUI(sourceLocations: [String], destinationLocations: [String], resource: MapplsDistanceMatrixResourceIdentifier, profile: MapplsDirectionsProfileIdentifier) {
    }
    
    func locationsPikcedForDirectionsUI(sourceLocation: MapplsDirectionLocation, destinationLocation: MapplsDirectionLocation, viaLocations: [MapplsDirectionLocation], resource: MapplsDirectionsResourceIdentifier, profile: MapplsDirectionsProfileIdentifier, attributions: MapplsAttributeOptions) {
        
        var source = [MapplsDirectionLocation]()
        source.append(sourceLocation)
        
        var destinations = [MapplsDirectionLocation]()
        destinations.append(destinationLocation)
        
        var viaPoint = [MapplsDirectionLocation]()
        viaPoint = viaLocations
        let locations = source + viaPoint + destinations
        let directions = MapplsDirectionViewController(for: locations, style: .auto)
        directions.delegate = self
        directions.profileIdentifier = profile
        directions.resourceIdentifier = resource
        directions.attributationOptions = attributions
        self.navigationController?.pushViewController(directions, animated: false)
        self.navigationController?.navigationBar.isHidden = true
        
        
    }
}
extension DirectionUIViewController : MapplsDirectionViewControllerDelegate {
    func didRequestForStartNavigation(for routes: [MapplsAPIKit.Route], viewController: UIViewController, locations: [MapplsDirectionUI.MapplsDirectionLocation], selectedRouteIndex: Int, error: NSError) {
        
    }
    
    func didRequestForPreviewRoute(for steps: [RouteStep]?) {
        
    }
    
    func didRequestForPreviewRoute(for routes: [Route], locations: [MapplsDirectionLocation]) {
        
    }
    
    func didRequestForGoBack(for view: MapplsDirectionTopBannerView) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func didRequestForAddViapoint(_ sender: UIButton, for isEditMode: Bool) {
        
    }
    
    func didRequestDirections() {
        
    }
    
    func didRequestForStartNavigation(for index: Int) {
        
    }
    
    
}
