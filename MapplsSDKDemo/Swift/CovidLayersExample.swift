//
//  CovidLayersExample.swift

//
//  Created by apple on 04/06/20.
//  Copyright © 2022 Mappls. All rights reserved.
//

import UIKit
import MapplsMap

@objc(CovidLayersExample_Swift)
class CovidLayersExample_Swift: UIViewController {

    @IBOutlet weak var mapView: MapplsMapView!
    @IBOutlet weak var covidInfoLabel: UILabel!
    
    @IBOutlet weak var covidMarkerToggleButton: UIButton!
    @IBOutlet weak var covid19Button: UIButton!
    
    
    @IBAction func covid19ButtonPressed(_ sender: UIButton) {
        let vc = CovidLayersTableVC(nibName: nil, bundle: nil)
        vc.interactiveLayers = self.mapView.interactiveLayers ?? [MapplsInteractiveLayer]()
        vc.selectedInteractiveLayers = self.mapView.visibleInteractiveLayers ?? [MapplsInteractiveLayer]()
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func covidMarkerToggleButtonPressed(_ sender: UIButton) {
        let newState = !sender.isSelected;
        covidMarkerToggleButton.isSelected = newState
        self.mapView.shouldShowPopupForInteractiveLayer = newState
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        covidInfoLabel.text = ""
        covidInfoLabel.backgroundColor = .white
        covidInfoLabel.textAlignment = .center
        
        mapView.delegate = self
        covid19Button.isHidden = true
    }
}

extension CovidLayersExample_Swift: CovidLayersTableVCDelegate {
    func layersSelected(selectedInteractiveLayers: [MapplsInteractiveLayer]) {
        if let allLayers = self.mapView.interactiveLayers {
            for layer in allLayers {
                var isSelected = false
                if let layerId = layer.layerId {
                    for selectedLayer in selectedInteractiveLayers {
                        if let selectedLayerId = selectedLayer.layerId {
                            if selectedLayerId == layerId {
                                isSelected = true
                            }
                        }
                    }
                                
                    if isSelected {
                        self.mapView.showInteractiveLayerOnMap(forLayerId: layerId)
                    } else {
                        self.mapView.hideInteractiveLayerFromMap(forLayerId: layerId)
                    }
                }
            }
        }
    }
}

extension CovidLayersExample_Swift: MapplsMapViewDelegate {
    func mapView(_ mapView: MapplsMapView, authorizationCompleted isSuccess: Bool) {
        if isSuccess {
            self.mapView.getCovidLayers()
        }
    }
    
    func mapViewInteractiveLayersReady(_ mapView: MapplsMapView) {
        if self.mapView.interactiveLayers?.count ?? 0 > 0 {
            covid19Button.isHidden = false
        }
    }
    
    func didDetect(_ covidInfo: MapplsCovidInfo?) {
        if let covidInfo = covidInfo {
            var covidInfoText = [String]()
            
            if let total = covidInfo.total {
                covidInfoText.append("Total: \(total)")
            }
            if let cured = covidInfo.cured {
                covidInfoText.append("Cured: \(cured)")
            }
            if let death = covidInfo.death {
                covidInfoText.append("Death: \(death)")
            }
            if let confInd = covidInfo.confInd {
                covidInfoText.append("ConfInd: \(confInd)")
            }
            if let areaZone = covidInfo.areaZone {
                covidInfoText.append("Zone: \(areaZone)")
            }
            if let districtName = covidInfo.districtName {
                covidInfoText.append("District: \(districtName)")
            }
            if let stateName = covidInfo.stateName {
                covidInfoText.append("State: \(stateName)")
            }
            
            
            covidInfoLabel.text = covidInfoText.joined(separator: "\n")
        } else {
            covidInfoLabel.text = ""
        }
    }
}
