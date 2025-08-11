//
//  KeyValueTableViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 17/01/25.
//

import UIKit

class KeyValueTableViewController: UIViewController {
    
    var tableView: UITableView!
    var data: [KeyValueHashable] = []
    var dataSource: UITableViewDiffableDataSource<Int, KeyValueHashable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        tableView = UITableView()
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.identifer)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        dataSource = makeDataSource()
        applyInitialSnapshot()
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, KeyValueHashable>()
        snapshot.appendSections([0])
        snapshot.appendItems(data, toSection: 0)
        dataSource.apply(snapshot)
    }
    
    func makeDataSource() -> UITableViewDiffableDataSource<Int, KeyValueHashable> {
        return UITableViewDiffableDataSource<Int, KeyValueHashable>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard self.data.indices.contains(indexPath.row), let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifer) as? InfoTableViewCell else {return UITableViewCell()}
            let dataItem = self.data[indexPath.row]
            cell.setData(data: dataItem)
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension KeyValueTableViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
            self.tableView.backgroundColor = theme.backgroundPrimary
        }
    }
}
