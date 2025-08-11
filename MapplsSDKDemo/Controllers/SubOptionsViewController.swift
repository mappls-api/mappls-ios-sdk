//
//  MapEventsViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 08/01/25.
//

import UIKit
import MapplsMap

class SubOptionsViewController: UIViewController {
    
    var navBarView: NavigationBarView!
    var optionSelected: OptionsEnum!
    var searchView: CommonSearchBarView!
    var subOptionsView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, SubOptionsHashable>!
    var allSubOptions: [SubOptionsHashable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        navBarView = NavigationBarView(title: optionSelected.rawValue)
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
        
        searchView = CommonSearchBarView()
        searchView.delegate = self
        searchView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(searchView, belowSubview: navBarView)
        
        NSLayoutConstraint.activate([
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 60),
            searchView.topAnchor.constraint(equalTo: navBarView.bottomAnchor)
        ])
        
        setSubOptionsView()
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setSubOptionsView() {
        
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in
            var group: NSCollectionLayoutGroup!
            
            if layoutEnvironment.traitCollection.verticalSizeClass == .regular {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(250))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
            }else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(300), heightDimension: .estimated(250))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(250))
                
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                group.interItemSpacing = .fixed(20)
            }
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 15, leading: 0, bottom: 20, trailing: 0)
            section.interGroupSpacing = 20
            return section
        }
        
        subOptionsView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        subOptionsView.showsVerticalScrollIndicator = false
        subOptionsView.delegate = self
        subOptionsView.register(SubOptionsViewCell.self, forCellWithReuseIdentifier: SubOptionsViewCell.identifier)
        subOptionsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subOptionsView)
        
        NSLayoutConstraint.activate([
            subOptionsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            subOptionsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            subOptionsView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10),
            subOptionsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        dataSource = makeDataSource()
        applyInitialSnapshot()
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Int, SubOptionsHashable> {
        let dataSource = UICollectionViewDiffableDataSource<Int, SubOptionsHashable>(collectionView: subOptionsView) { collectionView, indexPath, itemIdentifier in
            guard self.optionSelected.subOption.indices.contains(indexPath.row), let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubOptionsViewCell.identifier, for: indexPath) as? SubOptionsViewCell else {return UICollectionViewCell()}
            let data = self.optionSelected.subOption[indexPath.row]
            if data == .mapTraffic {
                cell.setUpMapView()
            }else {
                cell.setMapSnapshotImage()
            }
            cell.setData(data: .init(title: data.rawValue, subTitle: data.subTitle, icon: data.icon))
            return cell
        }
        return dataSource
    }
    
    func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SubOptionsHashable>()
        snapshot.appendSections([0])
        optionSelected.subOption.forEach { subOption in
            let item = SubOptionsHashable(title: subOption.rawValue, subTitle: subOption.subTitle, icon: subOption.icon)
            allSubOptions.append(item)
            snapshot.appendItems([item], toSection: 0)
        }
        dataSource.apply(snapshot)
    }
}

extension SubOptionsViewController: CommonSearchBarDelegate {
    func searchDidChange(text: String) async {
        if let text = searchView.textField.text {
            var snapshot = NSDiffableDataSourceSnapshot<Int, SubOptionsHashable>()
            snapshot.appendSections([0])
            if text == "" {
                snapshot.appendItems(allSubOptions, toSection: 0)
                dataSource.apply(snapshot)
                return
            }
            
            var filteredItems = [SubOptionsHashable]()
            allSubOptions.forEach { item in
                if item.title.contains(text) || item.subTitle.contains(text) {
                    filteredItems.append(item)
                }
            }
            snapshot.deleteItems(snapshot.itemIdentifiers)
            snapshot.appendItems(filteredItems, toSection: 0)
            dataSource.apply(snapshot)
        }
    }
}

extension SubOptionsViewController: NavigationProtocol {
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension SubOptionsViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
            self.subOptionsView.backgroundColor = theme.backgroundPrimary
        }
    }
}

extension SubOptionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard optionSelected.subOption.indices.contains(indexPath.row) else {return}
        
        let data = optionSelected.subOption[indexPath.row]
        
        switch data {
        case .mapStyle:
            let vc = MapStyleOptionViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            let vc = OptionDetailViewController()
            vc.option = data
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

