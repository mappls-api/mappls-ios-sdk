//
//  DefaultIndoorViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 27/01/25.
//

import UIKit
import MapplsMap
import MapplsAPIKit

class DefaultIndoorViewController: UIViewController {
    
    var mapView: MapplsMapView!
    var navBarView: NavigationBarView!
    var indoorBtn: UIButton!
    var vasantKunjBtn: UIButton!
    var bangloreExhibitionBtn: UIButton!
    
    let vasantKunjLocation = CLLocationCoordinate2DMake(28.542568, 77.155914)
    let bangaloreExpoLocation = CLLocationCoordinate2DMake(13.062946, 77.474959)
    var indoorPlugin:MapplsMapViewIndoorPlugin?
    var indoorSelecorView: MapplsIndoorSelectorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        navBarView = NavigationBarView(title: SubOptionsEnum.indoorMap.rawValue)
        navBarView.addBottomShadow()
        navBarView.delegate = self
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBarView)
        
        NSLayoutConstraint.activate([
            navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBarView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        mapView = MapplsMapView()
        mapView.delegate = self
        mapView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mapView.zoomLevel = 5
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        indoorBtn = UIButton()
        indoorBtn.setTitle("Indoor", for: .normal)
        indoorBtn.layer.cornerRadius = 5
        indoorBtn.layer.borderWidth = 1
        indoorBtn.addTarget(self, action: #selector(self.indoorBtnTapped), for: .touchUpInside)
        indoorBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indoorBtn)
        
        NSLayoutConstraint.activate([
            indoorBtn.topAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: 15),
            indoorBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            indoorBtn.heightAnchor.constraint(equalToConstant: 40),
            indoorBtn.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        vasantKunjBtn = UIButton()
        vasantKunjBtn.setTitle("Ambience Mall", for: .normal)
        vasantKunjBtn.layer.cornerRadius = 5
        vasantKunjBtn.layer.borderWidth = 1
        vasantKunjBtn.addTarget(self, action: #selector(self.vasantKunjBtnTapped), for: .touchUpInside)
        vasantKunjBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vasantKunjBtn)
        
        NSLayoutConstraint.activate([
            vasantKunjBtn.leadingAnchor.constraint(equalTo: indoorBtn.leadingAnchor),
            vasantKunjBtn.topAnchor.constraint(equalTo: indoorBtn.bottomAnchor, constant: 15),
            vasantKunjBtn.heightAnchor.constraint(equalToConstant: 40),
            vasantKunjBtn.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        bangloreExhibitionBtn = UIButton()
        bangloreExhibitionBtn.setTitle("Exhibition Hall", for: .normal)
        bangloreExhibitionBtn.layer.cornerRadius = 5
        bangloreExhibitionBtn.layer.borderWidth = 1
        bangloreExhibitionBtn.addTarget(self, action: #selector(self.bangloreBtnTapped), for: .touchUpInside)
        bangloreExhibitionBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bangloreExhibitionBtn)
        
        NSLayoutConstraint.activate([
            bangloreExhibitionBtn.leadingAnchor.constraint(equalTo: vasantKunjBtn.leadingAnchor),
            bangloreExhibitionBtn.topAnchor.constraint(equalTo: vasantKunjBtn.bottomAnchor, constant: 15),
            bangloreExhibitionBtn.heightAnchor.constraint(equalToConstant: 40),
            bangloreExhibitionBtn.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        indoorBtn.isSelected = MapplsAccountManager.indoorEnabled()
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    @objc func indoorBtnTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        MapplsAccountManager.setIndoorEnabled(sender.isSelected)
        indoorBtn.backgroundColor = sender.isSelected ? ThemeColors.default.accentBrandPrimary : ThemeColors.default.backgroundSecondary
    }
    
    @objc func bangloreBtnTapped() {
        mapView.setCenter(bangaloreExpoLocation, zoomLevel: 18, animated: true)
    }
    
    @objc func vasantKunjBtnTapped() {
        mapView.setCenter(vasantKunjLocation, zoomLevel: 18, animated: true)
    }
}

extension DefaultIndoorViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
            self.indoorBtn.backgroundColor = theme.backgroundSecondary
            self.indoorBtn.layer.borderColor = theme.strokeBorder.cgColor
            self.indoorBtn.setTitleColor(theme.textPrimary, for: .normal)
            self.vasantKunjBtn.backgroundColor = theme.backgroundSecondary
            self.vasantKunjBtn.layer.borderColor = theme.strokeBorder.cgColor
            self.vasantKunjBtn.setTitleColor(theme.textPrimary, for: .normal)
            self.bangloreExhibitionBtn.backgroundColor = theme.backgroundSecondary
            self.bangloreExhibitionBtn.layer.borderColor = theme.strokeBorder.cgColor
            self.bangloreExhibitionBtn.setTitleColor(theme.textPrimary, for: .normal)
        }
    }
}

extension DefaultIndoorViewController: NavigationProtocol {
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension DefaultIndoorViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        mapView.setCenter(vasantKunjLocation, zoomLevel: 18, animated: true)
    }
}
