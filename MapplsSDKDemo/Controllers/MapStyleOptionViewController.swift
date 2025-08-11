//
//  MapStyleOptionViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 09/01/25.
//

import UIKit
import MapplsMap

class StylesHashable: Hashable {
    let id: UUID
    var name: String
    var description: String
    var iconUrl: String?
    
    init(name: String, description: String, iconUrl: String?) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.iconUrl = iconUrl
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: StylesHashable, rhs: StylesHashable) -> Bool {
        return lhs.id == rhs.id
    }
}

class MapStyleOptionViewController: UIViewController {
    
    var navBarView: NavigationBarView!
    var mapView: MapplsMapView!
    var styleCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, StylesHashable>!
    var setStyleBtn: UIButton!
    var mapStyles: [MapplsMapStyle] = [] {
        didSet {
            if dataSource == nil {return}
            applyInitialSnapshot()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        navBarView = NavigationBarView(title: "Map Style")
        navBarView.addBottomShadow()
        navBarView.layer.zPosition = 3
        navBarView.delegate = self
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBarView)
        
        NSLayoutConstraint.activate([
            navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBarView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        setStyleBtn = UIButton()
        setStyleBtn.setTitle("Set Style", for: .normal)
        setStyleBtn.layer.borderWidth = 1
        setStyleBtn.layer.cornerRadius = 10
        setStyleBtn.addTarget(self, action: #selector(self.setStyleBtnClicked), for: .touchUpInside)
        setStyleBtn.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(setStyleBtn)
        
        NSLayoutConstraint.activate([
            setStyleBtn.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            setStyleBtn.trailingAnchor.constraint(equalTo: navBarView.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            setStyleBtn.heightAnchor.constraint(equalToConstant: 40),
            setStyleBtn.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        mapView = MapplsMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.topAnchor.constraint(equalTo: navBarView.bottomAnchor)
        ])
        
        setStylesCollectionView()
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    @objc func setStyleBtnClicked() {
        if let cell = styleCollectionView.visibleCells.first, let indexPath = styleCollectionView.indexPath(for: cell) {
            if mapStyles.indices.contains(indexPath.row) {
                let style = mapStyles[indexPath.row]
                mapView.setMapplsMapStyle(style.name ?? "")
            }
        }
    }
    
    func setStylesCollectionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        styleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        styleCollectionView.alwaysBounceVertical = false
        styleCollectionView.backgroundColor = .clear
        styleCollectionView.register(MapStylesCollectionViewCell.self, forCellWithReuseIdentifier: MapStylesCollectionViewCell.identifier)
        styleCollectionView.delegate = self
        styleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(styleCollectionView)
    
        NSLayoutConstraint.activate([
            styleCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            styleCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            styleCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            styleCollectionView.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        dataSource = makeDataSource()
        applyInitialSnapshot()
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Int, StylesHashable> {
        let dataSource = UICollectionViewDiffableDataSource<Int, StylesHashable>(collectionView: styleCollectionView) { collectionView, indexPath, itemIdentifier in
            guard self.mapStyles.indices.contains(indexPath.row), let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapStylesCollectionViewCell.identifier, for: indexPath) as? MapStylesCollectionViewCell else {return UICollectionViewCell()}
            let data = self.mapStyles[indexPath.row]
            cell.setData(data: .init(name: data.displayName!, description: data.name ?? "", iconUrl: data.imageUrl))
            return cell
        }
        return dataSource
    }
    
    func applyInitialSnapshot() {
        var snashot = NSDiffableDataSourceSnapshot<Int, StylesHashable>()
        snashot.appendSections([0])
        
        mapStyles.forEach { style in
            snashot.appendItems([.init(name: style.displayName!, description: style.name ?? "", iconUrl: style.imageUrl)], toSection: 0)
        }
        dataSource.apply(snashot)
    }
}

extension MapStyleOptionViewController: NavigationProtocol {
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension MapStyleOptionViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
            self.setStyleBtn.setTitleColor(theme.textPrimary, for: .normal)
            self.setStyleBtn.layer.borderColor = theme.strokeBorder.cgColor
            self.setStyleBtn.backgroundColor = theme.backgroundSecondary
        }
    }
}

extension MapStyleOptionViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        if let userLocation = mapView.userLocation {
            mapView.setCamera(.init(lookingAtCenter: userLocation.coordinate, altitude: 1000, pitch: 0, heading: 0), animated: true)
        }
    }
    
    func didLoadedMapplsMapStyles(_ mapView: MapplsMapView, styles: [MapplsMapStyle], withError error: Error?) {
        self.mapStyles = styles
    }
}

extension MapStyleOptionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}
