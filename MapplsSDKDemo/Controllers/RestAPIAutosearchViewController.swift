//
//  RestAPIAutosearchViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 10/01/25.
//

import UIKit
import MapplsAPIKit

protocol SearchProtocol: Sendable, AnyObject {
    func searchDidBegin() async
    func didSelectDestination(destination: MapplsAtlasSuggestion) async
    func searchDidEnd() async
}

class SearchResultHashable: Hashable, @unchecked Sendable {
    let id: UUID
    let suggestion: MapplsAtlasSuggestion
    
    init(suggestion: MapplsAtlasSuggestion) {
        self.id = UUID()
        self.suggestion = suggestion
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: SearchResultHashable, rhs: SearchResultHashable) -> Bool {
        return lhs.id == rhs.id
    }
}

class RestAPIAutosearchViewController: UIViewController {
    weak var delegate: SearchProtocol?
    var homeSearchBar: SearchBar!
    var suggestionsView: UICollectionView!
    var navBarView: NavigationBarView!
    
    let restAPISubOptionSelected: SubOptionsEnum = .autosuggestAPI
    let autoSuggestManager = MapplsAutoSuggestManager.shared
    var suggestions: [SearchResultHashable] = []
    var dataSource: UICollectionViewDiffableDataSource<Int, SearchResultHashable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        navBarView = NavigationBarView(title: restAPISubOptionSelected.rawValue)
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
        
        let homeSB = SearchBar(frame: .zero)
        homeSB.searchField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapSearchBar))
        homeSB.addGestureRecognizer(tapGesture)
        
        homeSB.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(homeSB)
        
        self.homeSearchBar = homeSB
        
        NSLayoutConstraint.activate([
            homeSB.topAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: 20),
            homeSB.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            homeSB.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            homeSB.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        setSuggestionView()
        dataSource = makeDataSource()
        applyInitialSnapshot()
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResultHashable>()
        snapshot.appendSections([0])
        dataSource.apply(snapshot)
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Int, SearchResultHashable> {
        return UICollectionViewDiffableDataSource<Int, SearchResultHashable>(collectionView: suggestionsView) { collectionView, indexPath, itemIdentifier in
            
            let cellData = self.suggestions[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.identifier, for: indexPath) as? SearchResultCell else {return UICollectionViewCell()}
            cell.setUpUI(with: cellData)
            return cell
        }
    }
    
    func reloadSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResultHashable>()
        snapshot.appendSections([0])
        suggestions.forEach { item in
            snapshot.appendItems([item], toSection: 0)
        }
        dataSource.apply(snapshot)
    }
    
    func setSuggestionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        group.interItemSpacing = .fixed(5)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        suggestionsView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        suggestionsView.delegate = self
        suggestionsView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.identifier)
        suggestionsView.showsHorizontalScrollIndicator = false
        suggestionsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(suggestionsView)
        
        NSLayoutConstraint.activate([
            suggestionsView.topAnchor.constraint(equalTo: homeSearchBar.bottomAnchor, constant: 10),
            suggestionsView.leadingAnchor.constraint(equalTo: homeSearchBar.leadingAnchor),
            suggestionsView.trailingAnchor.constraint(equalTo: homeSearchBar.trailingAnchor),
            suggestionsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func didTapSearchBar() {
        homeSearchBar.searchField.becomeFirstResponder()
    }
}

extension RestAPIAutosearchViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
            self.suggestionsView.backgroundColor = theme.backgroundPrimary
        }
    }
}

extension RestAPIAutosearchViewController: NavigationProtocol {
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension RestAPIAutosearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let suggestion = suggestions[indexPath.row]
        Task {
            await delegate?.didSelectDestination(destination: suggestion.suggestion)
        }
    }
}

extension RestAPIAutosearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text == "" { suggestions.removeAll(); self.reloadSnapshot(); return true}
        let autoSearchAtlasOptions = MapplsAutoSearchAtlasOptions(query: textField.text!,
                                                                  withRegion: .india)
        autoSuggestManager.getAutoSuggestionCompleteResult(autoSearchAtlasOptions) { (locationResults, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else if let locationResults = locationResults {
                if let suggestions = locationResults.suggestions {
                    self.suggestions = []
                    for suggestion in suggestions {
                        let searchHashable = SearchResultHashable(suggestion: suggestion)
                        self.suggestions.append(searchHashable)
                    }
                    self.reloadSnapshot()
                }
            } else {
                print("No Results")
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Task {
            await delegate?.searchDidEnd()
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        Task {
            await delegate?.searchDidBegin()
        }
    }
}
