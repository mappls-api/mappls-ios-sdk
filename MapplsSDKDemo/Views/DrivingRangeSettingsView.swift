//
//  DrivingRangeSettingsView.swift
//  MapplsSDKDemo
//
//  Created by rento on 28/01/25.
//

import UIKit
import MapplsMap

protocol DrivingSettingsDelegate: Sendable, AnyObject {
    func didSetAsCurrentLocation(withValue: Bool) async
    func locationDidSet(withValue: CLLocation) async
    func rangeTypeDidChange(withValue: MapplsDrivingRangeRangeType) async
    func contourDidSet(withValue: MapplsDrivingRangeContour) async
    func colorDidSet(withValue: UIColor) async
    func drivingProfileDidSet(withValue: MapplsDirectionsProfileIdentifier) async
    func showLocation(isEnabled: Bool) async
    func showPolygon(isEnabled: Bool) async
    func denoiseDidSet(withValue: NSNumber) async
    func generalizeDidSet(withValue: NSNumber) async
    func speedTypeDidSet(withValue: MapplsDrivingRangeSpeed) async
    func searchLocationButtonPressed() async
}

enum DrivingRangeSettingsHashable: Hashable {
    case switchCell(DrivingRangeSwitchSetting)
    case keyboardInputCell(DrivingRangeKeyboardInput)
    case radioButtonCell(DrivingRangeRadioButton)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .switchCell(let setting):
            hasher.combine(0)
            hasher.combine(setting)
        case .keyboardInputCell(let input):
            hasher.combine(1)
            hasher.combine(input)
        case .radioButtonCell(let radioButton):
            hasher.combine(2)
            hasher.combine(radioButton)
        }
    }
    
    static func == (lhs: DrivingRangeSettingsHashable, rhs: DrivingRangeSettingsHashable) -> Bool {
        switch (lhs, rhs) {
        case (.switchCell(let lhsSetting), .switchCell(let rhsSetting)):
            return lhsSetting == rhsSetting
        case (.keyboardInputCell(let lhsInput), .keyboardInputCell(let rhsInput)):
            return lhsInput == rhsInput
        case (.radioButtonCell(let lhsRadio), .radioButtonCell(let rhsRadio)):
            return lhsRadio == rhsRadio
        default:
            return false
        }
    }
}

class DrivingRangeSwitchSetting: Hashable {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(title)
    }
    
    static func == (lhs: DrivingRangeSwitchSetting, rhs: DrivingRangeSwitchSetting) -> Bool {
        return lhs.title == rhs.title
    }
}

class DrivingRangeKeyboardInput: Hashable {
    var title: String
    var saveBtnTitle: String
    var isLatLonInput: Bool
    var inputs: [String] = ["", "", ""]
    
    init(title: String, saveBtnTitle: String, isLatLonInput: Bool = false) {
        self.title = title
        self.saveBtnTitle = saveBtnTitle
        self.isLatLonInput = isLatLonInput
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(title)
    }
    
    static func == (lhs: DrivingRangeKeyboardInput, rhs: DrivingRangeKeyboardInput) -> Bool {
        return lhs.title == rhs.title
    }
}

class DrivingRangeRadioButton: Hashable {
    var title: String
    var radioItems: [String]
    var selectedItem: String
    
    init(title: String, radioItems: [String], selectedItem: String) {
        self.title = title
        self.radioItems = radioItems
        self.selectedItem = selectedItem
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(title)
    }
    
    static func == (lhs: DrivingRangeRadioButton, rhs: DrivingRangeRadioButton) -> Bool {
        return lhs.title == rhs.title
    }
}

class DrivingRangeSettingsView: UIView {
    
    weak var delegate: DrivingSettingsDelegate?
    var tableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<Int, DrivingRangeSettingsHashable>!
    var data: [DrivingRangeSettingsHashable] = [] {
        didSet {
            applySnapshot()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        tableView = UITableView()
        tableView.register(CommonSwitchTableViewCell.self, forCellReuseIdentifier: CommonSwitchTableViewCell.identifier)
        tableView.register(ConfigurationEntryCell.self, forCellReuseIdentifier: ConfigurationEntryCell.identifier)
        tableView.register(CommonRadioButtonTableViewCell.self, forCellReuseIdentifier: CommonRadioButtonTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        dataSource = makeDataSource()
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func applySnapshot() {
        var snaphot: NSDiffableDataSourceSnapshot<Int, DrivingRangeSettingsHashable> = .init()
        snaphot.appendSections([0])
        snaphot.appendItems(data)
        dataSource.apply(snaphot)
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Int, DrivingRangeSettingsHashable> {
        let dataSource: UITableViewDiffableDataSource<Int, DrivingRangeSettingsHashable> = .init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let data = self.data[indexPath.row]
            
            switch data {
            case .switchCell(let setting):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CommonSwitchTableViewCell.identifier, for: indexPath) as? CommonSwitchTableViewCell else {return UITableViewCell()}
                cell.setTitle(title: setting.title)
                cell.delegate = self
                cell.tag = indexPath.row
                return cell
            case .keyboardInputCell(let input):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ConfigurationEntryCell.identifier, for: indexPath) as? ConfigurationEntryCell else {return UITableViewCell()}
                cell.setUpData(input: input)
                cell.delegate = self
                cell.tag = indexPath.row
                return cell
            case .radioButtonCell(let radioButtonItems):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CommonRadioButtonTableViewCell.identifier, for: indexPath) as? CommonRadioButtonTableViewCell else {return UITableViewCell()}
                cell.setData(item: radioButtonItems)
                cell.delegate = self
                cell.tag = indexPath.row
                return cell
            }
        }
        return dataSource
    }
    
    func setBottomInset(to value: CGFloat) {
        let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
        tableView.contentInset = edgeInset
        tableView.scrollIndicatorInsets = edgeInset
    }
}

extension DrivingRangeSettingsView: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.tableView.backgroundColor = theme.backgroundPrimary
        }
    }
}

extension DrivingRangeSettingsView: ConfigurationEntryCellDelegate {
    func saveBtnPressed(forTitle: String, values: [String]) async {
        Task {
            guard values.indices.count > 0 else {return}
            switch forTitle {
            case "Location":
                if values[0] != "" && values[1] != "" {
                    if let lat = Double(values[0]), let long = Double(values[1]) {
                        let location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                        await delegate?.locationDidSet(withValue: location)
                    }
                }
            case "Contour":
                if let value = Int(values[0]) {
                    await delegate?.contourDidSet(withValue: MapplsDrivingRangeContour(value: value))
                }
            case "Driving Profile":
                let profile = MapplsDirectionsProfileIdentifier(rawValue: values[0])
                await delegate?.drivingProfileDidSet(withValue: profile)
            case "Denoise":
                if let integer = Int(values[0]) {
                    await delegate?.denoiseDidSet(withValue: NSNumber(value: integer))
                }
            case "Generalize":
                if let integer = Int(values[0]) {
                    await delegate?.generalizeDidSet(withValue: NSNumber(value: integer))
                }
            default:
                break
            }
        }
    }
    
    func searchLocBtnPressed() async {
        Task {
            await delegate?.searchLocationButtonPressed()
        }
    }
}

extension DrivingRangeSettingsView: CommonSwitchTableViewCellDelegate {
    func switchValueChanged(withTitle: String, isOn: Bool) async {
        Task {
            switch withTitle {
            case "Set as Current Location":
                await delegate?.didSetAsCurrentLocation(withValue: isOn)
            case "Show Location":
                await delegate?.showLocation(isEnabled: isOn)
            case "Show Polygon":
                await delegate?.showPolygon(isEnabled: isOn)
            default:
                break
            }
        }
    }
}

extension DrivingRangeSettingsView: CommonRadioButtonTableViewCellDelegate {
    func didSelectRadioButton(title: String, value: String) async {
        guard value != "" else {return}
        Task {
            switch title {
            case "Range Type":
                await delegate?.rangeTypeDidChange(withValue: MapplsDrivingRangeRangeType(rawValue: value))
            case "Color":
                switch value {
                case "Red":
                    await delegate?.colorDidSet(withValue: .red)
                case "Blue":
                    await delegate?.colorDidSet(withValue: .blue)
                case "Green":
                    await delegate?.colorDidSet(withValue: .green)
                default:
                    break
                }
            case "Speed Type":
                switch value {
                case "Optimal":
                    await delegate?.speedTypeDidSet(withValue: MapplsDrivingRangeOptimalSpeed())
                case "Predictive":
                    await delegate?.speedTypeDidSet(withValue: MapplsDrivingRangePredictiveSpeedFromCurrentTime())
                default:
                    break
                }
            default:
                break
            }
        }
    }
}
