//
//  GeoanalyticsSwitchCasesViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 30/01/25.
//

import UIKit
import MapplsGeoanalytics

protocol GeoanalyticsSwitchChangeDelegate: Sendable, AnyObject {
    func switchChangedValue(isOn: Bool, request: (GeoanalyticsListingAPIRequest, MapplsGeoanalyticsLayerRequest)) async
}

class SwitchCase: Hashable {
    
    let id: UUID
    var title: String
    var isOn: Bool
    
    init(title: String, isOn: Bool = false) {
        self.id = UUID()
        self.title = title
        self.isOn = isOn
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: SwitchCase, rhs: SwitchCase) -> Bool {
        return lhs.id == rhs.id
    }
}

class GeoanalyticsSwitchCasesViewController: UIViewController {
    
    weak var delegate: GeoanalyticsSwitchChangeDelegate?
    var switchCasesTableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<Int, SwitchCase>!
    var switchData: [SwitchCase] = []
    var requestList: [(GeoanalyticsListingAPIRequest, MapplsGeoanalyticsLayerRequest)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        switchCasesTableView = UITableView()
        switchCasesTableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        switchCasesTableView.separatorStyle = .none
        switchCasesTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(switchCasesTableView)
        
        NSLayoutConstraint.activate([
            switchCasesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            switchCasesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            switchCasesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            switchCasesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
        
        self.dataSource = makeDataSource()
        setData()
        applyInitialSnapshot()
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setData() {
        let requeststate = GeoanalyticsListingAPIRequest.init(geoboundType: "stt_nme", geobound: ["HARYANA","UTTAR PRADESH","ANDHRA PRADESH","KERALA"], attribute: "b_box", api: .state)
        
        let apperenceState = GeoanalyticsLayerAppearance()
        apperenceState.fillColor = "42a5f4"
        apperenceState.fillOpacity = "0.5"
        apperenceState.labelColor = "000000"
        apperenceState.labelSize = "10"
        apperenceState.strokeColor = "000000"
        apperenceState.strokeWidth = "0"
        
        let geoboundArray1 = [MapplsGeoanalyticsGeobound(geobound: "HARYANA", appearance: apperenceState), MapplsGeoanalyticsGeobound(geobound: "UTTAR PRADESH", appearance: apperenceState),MapplsGeoanalyticsGeobound(geobound: "KERALA", appearance: apperenceState)]
        
        let layerRequestState = MapplsGeoanalyticsLayerRequest(geoboundType: "stt_nme", geobound: geoboundArray1, propertyName: ["stt_nme","stt_id","t_p"], layerType: .state)
        layerRequestState.attribute = "t_p"
        layerRequestState.query = ">0"
        layerRequestState.transparent = true
        
        requestList.append((requeststate, layerRequestState))
        switchData.append(.init(title: layerRequestState.layerType.rawValue))
        
        let requestdistrict = GeoanalyticsListingAPIRequest(geoboundType: "stt_nme", geobound: ["BIHAR","UTTARAKHAND"], attribute: "b_box", api: .district)
        
        let apperenceDistrict = GeoanalyticsLayerAppearance()
        apperenceDistrict.fillColor = "8bc34a"
        apperenceDistrict.fillOpacity = "0.5"
        apperenceDistrict.labelColor = "000000"
        apperenceDistrict.labelSize = "10"
        apperenceDistrict.strokeColor = "000000"
        apperenceDistrict.strokeWidth = "0"
        
         let geoboundArray2 = [MapplsGeoanalyticsGeobound(geobound: "BIHAR", appearance: apperenceDistrict), MapplsGeoanalyticsGeobound(geobound: "UTTARAKHAND",appearance: apperenceDistrict),MapplsGeoanalyticsGeobound(geobound: "KERALA",appearance: apperenceDistrict)]
        
        let layerRequestDistrict = MapplsGeoanalyticsLayerRequest(geoboundType: "stt_nme", geobound: geoboundArray2, propertyName: ["dst_nme","dst_id","t_p"], layerType: .district)
        
        layerRequestDistrict.attribute = "t_p";
        layerRequestDistrict.query = ">0";
        layerRequestDistrict.transparent = true;
        
        requestList.append((requestdistrict, layerRequestDistrict))
        switchData.append(.init(title: layerRequestDistrict.layerType.rawValue))
        
        let requestsubDistrict = GeoanalyticsListingAPIRequest.init(geoboundType: "stt_nme", geobound: ["HIMACHAL PRADESH","TRIPURA"], attribute: "b_box", api: .subDistrict)

        let apperenceSubDistrict = GeoanalyticsLayerAppearance()
        apperenceSubDistrict.fillColor = "ffa000"
        apperenceSubDistrict.fillOpacity = "0.5"
        apperenceSubDistrict.labelColor = "000000"
        apperenceSubDistrict.labelSize = "10"
        apperenceSubDistrict.strokeColor = "000000"
        apperenceSubDistrict.strokeWidth = "0"
        
        let geoboundArray3 = [MapplsGeoanalyticsGeobound(geobound: "HIMACHAL PRADESH", appearance: apperenceSubDistrict), MapplsGeoanalyticsGeobound(geobound: "TRIPURA",appearance:apperenceSubDistrict )]
        
        let layerRequestSubDistrict = MapplsGeoanalyticsLayerRequest(geoboundType: "stt_nme", geobound: geoboundArray3, propertyName: ["sdb_nme","sdb_id","t_p"], layerType: .subDistrict)
        
        layerRequestSubDistrict.attribute = "t_p";
        layerRequestSubDistrict.query = ">0";
        layerRequestSubDistrict.transparent = true;
        
        requestList.append((requestsubDistrict, layerRequestSubDistrict))
        switchData.append(.init(title: layerRequestSubDistrict.layerType.rawValue))
        
        let requestward = GeoanalyticsListingAPIRequest.init(geoboundType: "ward_no", geobound: ["0001"], attribute: "b_box", api: .ward)
        
        let apperenceWard = GeoanalyticsLayerAppearance()
        apperenceWard.fillColor = "ff5722"
        apperenceWard.fillOpacity = "0.5"
        apperenceWard.labelColor = "000000"
        apperenceWard.labelSize = "10"
        apperenceWard.strokeColor = "000000"
        apperenceWard.strokeWidth = "0"
        
        let geoboundArray4 = [MapplsGeoanalyticsGeobound(geobound: "0001", appearance: apperenceWard)]
        
        let layerRequestWard = MapplsGeoanalyticsLayerRequest(geoboundType: "ward_no", geobound: geoboundArray4,  propertyName: ["ward_no","t_p"], layerType: .ward)
        
        layerRequestWard.attribute = "t_p";
        layerRequestWard.query = ">0";
        layerRequestWard.transparent = true;
        
        requestList.append((requestward, layerRequestWard))
        switchData.append(.init(title: layerRequestWard.layerType.rawValue))
        
        let requestlocality = GeoanalyticsListingAPIRequest.init(geoboundType: "stt_nme", geobound: ["DELHI"], attribute: "b_box", api: .locality)
        
        let apperenceLocality = GeoanalyticsLayerAppearance()
        apperenceLocality.fillColor = "00695c"
        apperenceLocality.fillOpacity = "0.5"
        apperenceLocality.labelColor = "000000"
        apperenceLocality.labelSize = "10"
        apperenceLocality.strokeColor = "000000"
        apperenceLocality.strokeWidth = "0"
        
        let geoboundArray5 = [MapplsGeoanalyticsGeobound(geobound: "DELHI", appearance: apperenceWard)]
        let layerRequestLocality = MapplsGeoanalyticsLayerRequest(geoboundType: "stt_nme", geobound: geoboundArray5, propertyName: ["loc_nme","loc_id","t_p"], layerType: .locality)
        
        layerRequestLocality.attribute = "t_p";
        layerRequestLocality.query = ">0";
        layerRequestLocality.transparent = true;
        
        requestList.append((requestlocality, layerRequestLocality))
        switchData.append(.init(title: layerRequestLocality.layerType.rawValue))
        
        let requestpanchayat = GeoanalyticsListingAPIRequest.init(geoboundType: "stt_nme", geobound: ["ASSAM"], attribute: "b_box", api: .panchayat)
        
        let apperencePanchayat = GeoanalyticsLayerAppearance()
        apperencePanchayat.fillColor = "b71c1c"
        apperencePanchayat.fillOpacity = "0.5"
        apperencePanchayat.labelColor = "000000"
        apperencePanchayat.labelSize = "10"
        apperencePanchayat.strokeColor = "000000"
        apperencePanchayat.strokeWidth = "0"
        
        let geoboundArray12 = [MapplsGeoanalyticsGeobound(geobound: "ASSAM", appearance: apperencePanchayat)]
        
        let layerRequestPanchayat = MapplsGeoanalyticsLayerRequest(geoboundType: "stt_nme", geobound: geoboundArray12,  propertyName: ["pnc_nme","pnc_id","t_p"], layerType: .panchayat)
        
        layerRequestPanchayat.attribute = "t_p";
        layerRequestPanchayat.query = ">0";
        layerRequestPanchayat.transparent = true;
        
        requestList.append((requestpanchayat, layerRequestPanchayat))
        switchData.append(.init(title: layerRequestPanchayat.layerType.rawValue))
        
        let requestblock = GeoanalyticsListingAPIRequest.init(geoboundType: "stt_nme", geobound: ["DELHI"], attribute: "b_box", api: .block)
        
        let apperenceBlock = GeoanalyticsLayerAppearance()
        apperenceBlock.fillColor = "3f51b5"
        apperenceBlock.fillOpacity = "0.5"
        apperenceBlock.labelColor = "000000"
        apperenceBlock.labelSize = "10"
        apperenceBlock.strokeColor = "000000"
        apperenceBlock.strokeWidth = "0"
        
        let geoboundArray11 = [MapplsGeoanalyticsGeobound(geobound: "DELHI", appearance: apperenceWard)]
        let layerRequestBlock = MapplsGeoanalyticsLayerRequest(geoboundType: "stt_nme", geobound: geoboundArray11, propertyName: ["blk_nme","blk_id","t_p"], layerType: .block)
        
        layerRequestBlock.attribute = "t_p";
        layerRequestBlock.query = ">0";
        layerRequestBlock.transparent = true;
        
        requestList.append((requestblock, layerRequestBlock))
        switchData.append(.init(title: layerRequestBlock.layerType.rawValue))
        
        let requestpincode = GeoanalyticsListingAPIRequest.init(geoboundType: "stt_nme", geobound: ["KARNATAKA"], attribute: "b_box", api: .pincode)
        
        let apperencePincode = GeoanalyticsLayerAppearance()
        apperencePincode.fillColor = "00bcd4"
        apperencePincode.fillOpacity = "0.5"
        apperencePincode.labelColor = "000000"
        apperencePincode.labelSize = "10"
        apperencePincode.strokeColor = "000000"
        apperencePincode.strokeWidth = "0"
        
        let geoboundArray13 = [MapplsGeoanalyticsGeobound(geobound: "KARNATAKA", appearance: apperencePincode)]
        let layerRequestPincode = MapplsGeoanalyticsLayerRequest(geoboundType: "stt_nme", geobound: geoboundArray13, propertyName: ["pincode"], layerType: .pincode)
        layerRequestPincode.attribute = "t_p";
        layerRequestPincode.query = ">0";
        layerRequestPincode.transparent = true
        
        requestList.append((requestpincode, layerRequestPincode))
        switchData.append(.init(title: layerRequestPincode.layerType.rawValue))
        
        let requesttown = GeoanalyticsListingAPIRequest.init(geoboundType: "stt_nme", geobound: ["PUNJAB"], attribute: "b_box", api: .town)
        
        let apperenceTown = GeoanalyticsLayerAppearance()
        apperenceTown.fillColor = "9ccc65"
        apperenceTown.fillOpacity = "0.5"
        apperenceTown.labelColor = "000000"
        apperenceTown.labelSize = "10"
        apperenceWard.strokeColor = "000000"
        apperenceWard.strokeWidth = "0"
        
        let geoboundArray6 = [MapplsGeoanalyticsGeobound(geobound: "PUNJAB", appearance: apperenceWard)]
        
        let layerRequestTown = MapplsGeoanalyticsLayerRequest(geoboundType: "stt_nme", geobound: geoboundArray6,  propertyName: ["twn_nme","twn_id","t_p"], layerType: .town)
        
        layerRequestTown.attribute = "t_p";
        layerRequestTown.query = ">0";
        layerRequestTown.transparent = true
        
        requestList.append((requesttown, layerRequestTown))
        switchData.append(.init(title: layerRequestTown.layerType.rawValue))
        
        let requestcity = GeoanalyticsListingAPIRequest.init(geoboundType: "stt_nme", geobound: ["TAMIL NADU"], attribute: "b_box", api: .city)
        
        let apperenceCity = GeoanalyticsLayerAppearance()
        apperenceCity.fillColor = "78909c"
        apperenceCity.fillOpacity = "0.5"
        apperenceCity.labelColor = "000000"
        apperenceCity.labelSize = "10"
        apperenceCity.strokeColor = "000000"
        apperenceCity.strokeWidth = "0"
        
        let geoboundArray7 = [MapplsGeoanalyticsGeobound(geobound: "TAMIL NADU'", appearance: apperenceCity)]
        
        let layerRequestCity = MapplsGeoanalyticsLayerRequest(geoboundType: "stt_nme", geobound: geoboundArray7, propertyName: ["city_nme","city_id","t_p"], layerType: .city)
        
        layerRequestCity.attribute = "t_p";
        layerRequestCity.query = ">0";
        layerRequestCity.transparent = true
        
        requestList.append((requestcity, layerRequestCity))
        switchData.append(.init(title: layerRequestCity.layerType.rawValue))
        
        let requestvillage = GeoanalyticsListingAPIRequest.init(geoboundType: "stt_nme", geobound: ["GOA"], attribute: "b_box", api: .village)
        
        let apperencevillage = GeoanalyticsLayerAppearance()
        apperencevillage.fillColor = "f06292"
        apperencevillage.fillOpacity = "0.5"
        apperencevillage.labelColor = "000000"
        apperencevillage.labelSize = "10"
        apperencevillage.strokeColor = "000000"
        apperencevillage.strokeWidth = "0"
        
        let geoboundArray8 = [MapplsGeoanalyticsGeobound(geobound: "GOA", appearance: apperencevillage)]
        
        let layerRequestVillage = MapplsGeoanalyticsLayerRequest(geoboundType: "stt_nme", geobound: geoboundArray8,  propertyName: ["vil_nme","id","t_p"], layerType: .village)
        
        layerRequestVillage.attribute = "t_p";
        layerRequestVillage.query = ">0";
        layerRequestVillage.transparent = true
        
        requestList.append((requestvillage, layerRequestVillage))
        switchData.append(.init(title: layerRequestVillage.layerType.rawValue))
        
        let requestsubLocality = GeoanalyticsListingAPIRequest.init(geoboundType: "stt_nme", geobound: ["UTTAR PRADESH","BIHAR"], attribute: "b_box", api: .subLocality)
        
        let apperenceSubLocality = GeoanalyticsLayerAppearance()
        apperenceSubLocality.fillColor = "f06292"
        apperenceSubLocality.fillOpacity = "0.5"
        apperenceSubLocality.labelColor = "000000"
        apperenceSubLocality.labelSize = "10"
        apperenceSubLocality.strokeColor = "000000"
        apperenceSubLocality.strokeWidth = "0"
        
        let geoboundArray9 = [MapplsGeoanalyticsGeobound(geobound: "UTTAR PRADESH", appearance: apperenceSubLocality), MapplsGeoanalyticsGeobound(geobound: "BIHAR",appearance: apperenceSubLocality)]
        
        let layerRequestSubLocality = MapplsGeoanalyticsLayerRequest(geoboundType: "stt_nme", geobound: geoboundArray9, propertyName: ["subl_nme","subl_id"], layerType: .subLocality)
        
        layerRequestSubLocality.attribute = "t_p";
        layerRequestSubLocality.query = ">0";
        layerRequestSubLocality.transparent = true
        
        requestList.append((requestsubLocality, layerRequestSubLocality))
        switchData.append(.init(title: layerRequestSubLocality.layerType.rawValue))
        
        let requestsubSubLocality = GeoanalyticsListingAPIRequest.init(geoboundType: "stt_nme", geobound: ["UTTAR PRADESH","BIHAR"], attribute: "b_box", api: .subSubLocality)
        
        let apperenceSubSubLocality = GeoanalyticsLayerAppearance()
        apperenceSubSubLocality.fillColor = "f06292"
        apperenceSubSubLocality.fillOpacity = "0.5"
        apperenceSubSubLocality.labelColor = "000000"
        apperenceSubSubLocality.labelSize = "10"
        apperenceSubSubLocality.strokeColor = "000000"
        apperenceSubSubLocality.strokeWidth = "0"
        
        let geoboundArray10 = [MapplsGeoanalyticsGeobound(geobound: "UTTAR PRADESH", appearance: apperenceSubSubLocality), MapplsGeoanalyticsGeobound(geobound: "BIHAR",appearance: apperenceSubSubLocality)]
        
        let layerRequestsubSubLocality = MapplsGeoanalyticsLayerRequest(geoboundType: "stt_nme", geobound: geoboundArray10, propertyName: ["subl_nme","subl_id"], layerType: .subSubLocality)
        
        layerRequestsubSubLocality.attribute = "t_p";
        layerRequestsubSubLocality.query = ">0";
        layerRequestsubSubLocality.transparent = true
        
        requestList.append((requestsubSubLocality, layerRequestsubSubLocality))
        switchData.append(.init(title: layerRequestsubSubLocality.layerType.rawValue))
    }
    
    func makeDataSource() -> UITableViewDiffableDataSource<Int, SwitchCase> {
        return UITableViewDiffableDataSource<Int, SwitchCase>(tableView: switchCasesTableView) { tableView, indexPath, itemIdentifier in
            let data = self.switchData[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier) as? SwitchTableViewCell else {return UITableViewCell()}
            cell.setData(item: data)
            cell.delegate = self
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            return cell
        }
    }
    
    func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SwitchCase>()
        snapshot.appendSections([0])
        snapshot.appendItems(switchData)
        dataSource.apply(snapshot)
    }
}

extension GeoanalyticsSwitchCasesViewController: SwitchTableViewCellDelegate {
    func switchValueChanged(isOn: Bool, tag: Int) async {
        let request = requestList[tag]
        Task {
            await delegate?.switchChangedValue(isOn: isOn, request: request)
        }
    }
}

extension GeoanalyticsSwitchCasesViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = .clear
            self.switchCasesTableView.backgroundColor = .clear
        }
    }
}
