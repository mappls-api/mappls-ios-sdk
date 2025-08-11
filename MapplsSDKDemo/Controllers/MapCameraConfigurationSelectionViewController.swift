//
//  MapCameraConfigurationSelectionViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 31/01/25.
//

import UIKit

protocol MapCameraModeConfigurationSelectionViewControllerDelegate: Sendable, AnyObject {
    func didDismiss() async
    func didSelectCameraMode(mode: CameraMode) async
}

class MapCameraModeConfigurationSelectionViewController: UIViewController {
    var tableView: UITableView!
    var closeButton: UIButton!
    var headerView: UIView!
    var headerLbl: UILabel!
    var currentSelectedMode: CameraMode = .normal
    weak var delegate: MapCameraModeConfigurationSelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        closeButton = UIButton()
        closeButton.setImage(UIImage(named: "x-circle"), for: .normal)
        closeButton.addTarget(self, action: #selector(self.closeButtonPressed), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        headerView = UIView()
        headerView.layer.cornerRadius = 12
        headerView.layer.masksToBounds = true
        headerView.backgroundColor = ThemeColors.default.backgroundSecondary
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 15),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        headerLbl = UILabel()
        headerLbl.text = CameraMode.title
        headerLbl.textColor = ThemeColors.default.textSecondary
        headerLbl.font = UIFont(name: "Roboto-Regular", size: 15)
        headerLbl.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerLbl)
        
        NSLayoutConstraint.activate([
            headerLbl.leadingAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            headerLbl.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerLbl.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
        ])
        
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCellIdentifier")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommonItemSelectionWithTickTableViewCell.self, forCellReuseIdentifier: CommonItemSelectionWithTickTableViewCell.identifier)
        tableView.estimatedRowHeight = 60
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    @objc func closeButtonPressed() {
        if let sheetViewController = sheetViewController {
            sheetViewController.attemptDismiss(animated: true)
        }else if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }else {
            dismiss(animated: true)
        }
    }
}

extension MapCameraModeConfigurationSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommonItemSelectionWithTickTableViewCell.identifier) as? CommonItemSelectionWithTickTableViewCell else {return UITableViewCell()}
        let data = CameraMode.allItems[indexPath.row]
        cell.setTitle(title: data.rawValue)
        if data.rawValue == currentSelectedMode.rawValue {
            cell.select()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = CameraMode.allItems[indexPath.row]
        
        for (index, mode) in CameraMode.allItems.enumerated() {
            if let cell = tableView.cellForRow(at: .init(row: index, section: 0)) as? CommonItemSelectionWithTickTableViewCell {
                if mode == data {
                    cell.select()
                    Task {
                        await delegate?.didSelectCameraMode(mode: mode)
                    }
                }else {
                    cell.deSelect()
                }
            }
        }
    }
}

extension MapCameraModeConfigurationSelectionViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.sheetViewController?.contentViewController.contentBackgroundColor = .clear
            self.view.backgroundColor = .clear
            self.tableView.backgroundColor = theme.backgroundPrimary
            self.tableView.separatorColor = theme.strokeBorder
        }
    }
}
