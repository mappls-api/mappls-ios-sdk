//
//  HomeViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 07/01/25.
//

import UIKit
import CoreLocation

class OptionsViewController: UIViewController {
    
    var titleBarView: TitleBarView!
    var optionsView: UICollectionView!
    var options: [OptionsHashable] = []
    var optionsDataSource: UICollectionViewDiffableDataSource<Int, OptionsHashable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        titleBarView = TitleBarView()
        titleBarView.addBottomShadow()
        titleBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleBarView)
        
        NSLayoutConstraint.activate([
            titleBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleBarView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        setOptionsView()

        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setOptionsData() {
        options.append(.init(icon: UIImage(named: "map-events"), title: OptionsEnum.mapEvents.rawValue))
        options.append(.init(icon: UIImage(named: "layers"), title: OptionsEnum.mapLayers.rawValue))
        options.append(.init(icon: UIImage(named: "map-camera"), title: OptionsEnum.camera.rawValue))
        options.append(.init(icon: UIImage(named: "marker"), title: OptionsEnum.marker.rawValue))
        options.append(.init(icon: UIImage(named: "location"), title: OptionsEnum.location.rawValue))
        options.append(.init(icon: UIImage(named: "polyline"), title: OptionsEnum.polyline.rawValue))
        options.append(.init(icon: UIImage(named: "rest-api"), title: OptionsEnum.restAPICall.rawValue))
        options.append(.init(icon: UIImage(named: "custom-widgets"), title: OptionsEnum.customWidgets.rawValue))
        options.append(.init(icon: UIImage(named: "marker"), title: OptionsEnum.geoJSON.rawValue))
        options.append(.init(icon: UIImage(named: "marker"), title: OptionsEnum.utility.rawValue))
    }
    
    func setOptionsView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(107), heightDimension: .absolute(110))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(110))
        
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in
            var group: NSCollectionLayoutGroup!
            if layoutEnvironment.traitCollection.verticalSizeClass == .regular {
                if #available(iOS 16.0, *) {
                    group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
                    group.interItemSpacing = .fixed((layoutEnvironment.container.contentSize.width-351)/2)
                } else {
                    group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
                    group.interItemSpacing = .fixed((layoutEnvironment.container.contentSize.width-351)/2)
                }
            }else {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 6)
            }
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 25, leading: 15, bottom: 0, trailing: 15)
            section.interGroupSpacing = 18
            return section
        }
        
        optionsView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        optionsView.delegate = self
        optionsView.register(OptionsViewCell.self, forCellWithReuseIdentifier: OptionsViewCell.identifier)
        optionsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(optionsView)
        
        NSLayoutConstraint.activate([
            optionsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            optionsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            optionsView.topAnchor.constraint(equalTo: titleBarView.bottomAnchor, constant: 10),
            optionsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        setOptionsData()
        optionsDataSource = makeDataSource()
        applyInitialSnapshot()
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Int, OptionsHashable> {
        let dataSource = UICollectionViewDiffableDataSource<Int, OptionsHashable>(collectionView: optionsView) { collectionView, indexPath, itemIdentifier in
            guard self.options.indices.contains(indexPath.row), let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionsViewCell.identifier, for: indexPath) as? OptionsViewCell else {return UICollectionViewCell()}
            cell.setData(data: self.options[indexPath.row])
            return cell
        }
        return dataSource
    }
    
    func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, OptionsHashable>()
        snapshot.appendSections([0])
        snapshot.appendItems(options, toSection: 0)
        optionsDataSource.apply(snapshot)
    }
}

extension OptionsViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
            self.optionsView.backgroundColor = theme.backgroundPrimary
        }
    }
}

extension OptionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if options.indices.contains(indexPath.row) {
            let data = options[indexPath.row]
            switch data.title {
            case OptionsEnum.mapEvents.rawValue:
                let vc = SubOptionsViewController()
                vc.optionSelected = .mapEvents
                navigationController?.pushViewController(vc, animated: true)
            case OptionsEnum.mapLayers.rawValue:
                let vc = MapLayersOptionsViewController()
                vc.optionSelected = .mapLayers
                navigationController?.pushViewController(vc, animated: true)
            case OptionsEnum.camera.rawValue:
                let vc = CameraSubOptionsViewController()
                vc.optionSelected = .camera
                navigationController?.pushViewController(vc, animated: true)
            case OptionsEnum.marker.rawValue:
                let vc = MarkerOptionViewController()
                vc.optionSelected = .marker
                navigationController?.pushViewController(vc, animated: true)
            case OptionsEnum.location.rawValue:
                let vc = LocationOptionViewController()
                vc.optionSelected = .location
                navigationController?.pushViewController(vc, animated: true)
            case OptionsEnum.polyline.rawValue:
                let vc = PolylineOptionViewController()
                vc.optionSelected = .polyline
                navigationController?.pushViewController(vc, animated: true)
            case OptionsEnum.restAPICall.rawValue:
                let vc = RestAPIOptionViewController()
                vc.optionSelected = .restAPICall
                navigationController?.pushViewController(vc, animated: true)
            case OptionsEnum.customWidgets.rawValue:
                let vc = CustomWidgetsOptionsViewController()
                vc.optionSelected = .customWidgets
                navigationController?.pushViewController(vc, animated: true)
            case OptionsEnum.geoJSON.rawValue:
                let vc = GeoJSONOptionViewController()
                vc.optionSelected = .geoJSON
                navigationController?.pushViewController(vc, animated: true)
            case OptionsEnum.utility.rawValue:
                let vc = UtilitySubOptionViewController()
                vc.optionSelected = .utility
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
    }
}
