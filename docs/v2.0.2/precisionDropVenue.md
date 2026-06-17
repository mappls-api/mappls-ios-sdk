---
title: Precision Drop Venue SDK for iOS
---

[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="60"/> </p>](https://about.mappls.com/api)

# Precision Drop Venue SDK for iOS

**High-Accuracy Location Picking for Complex Venues & Indoor Maps**

Powered with India's most comprehensive and robust mapping functionalities. Now Available for [200+ nations and territories](https://github.com/MapmyIndia/mapmyindia-rest-api/blob/master/docs/countryISO.md) across the world.

## Introduction

The Precision Drop Venue Plugin enhances the standard Place Picker with the ability to identify, highlight, and snap to complex venues (like malls, airports, business parks, and residential complexes). 

When a user picks a location within a supported venue:
1. **Venue Highlighting**: The boundary of the entire venue is highlighted.
2. **Venue Entry Points**: The official entry and exit gates of the venue are plotted on the map.
3. **Data Extraction**: Detailed information about the venue, including its specific `eLoc` and entry details, is returned.

## Implementation

Venue features are built directly into the `PlacePickerView`. You can enable and configure them using the properties and delegates below.

### 1. Initializing the Place Picker

#### Method
`PlacePickerView(frame:parentViewController:mapView:searchBaseURL:reverseBaseUrl:)`

### 2. Delegate Methods (`PlacePickerViewDelegate`)

When a user picks a location, you can check if it is a venue using the returned `MapplsGeocodedPlacemark`.

```swift
func didPickedLocation(placemark: MapplsGeocodedPlacemark) {
    if placemark.isVenue {
        if let venueDetails = placemark.venueDetails {
            print("Selected Venue: \(venueDetails.venueName ?? "")")
            print("Venue eLoc: \(venueDetails.venueEloc ?? "")")
            print("Total Entries: \(venueDetails.venueEntries?.count ?? 0)")
        }
    } else {
        print("Picked Location: \(placemark.formattedAddress ?? "")")
    }
}
```

### 3. Properties & Customization

To enable Venue highlights, ensure the footprint setting is active.

#### High-Precision Settings
- `isBuildingFootprintEnabled`: `Bool` - Set to `true` to enable venue boundary and entry point highlights. Default is `true`.

#### Understanding MapplsBuildingAppearance (Venue Appearance)
`MapplsBuildingAppearance` is a configuration class used to define the visual styling of the venue boundary. When a location is identified as a venue, its geometry is fetched and stylized based on this property.

- `venueAppearance`: `MapplsBuildingAppearance?` - Set custom style for complex venue boundaries. If nil, a default styling is used.

**Appearance Attributes:**
- `fillColor`: `String` - Hex color code for the venue fill (e.g., "7782E3").
- `fillOpacity`: `String` - Opacity of the fill (0 to 1).
- `strokeColor`: `String` - Hex color code for the boundary line.
- `strokeWidth`: `String` - Width of the boundary line.
- `strokeOpacity`: `String` - Opacity of the boundary line.

*Note: Venue entry points are plotted automatically with distinct styling (e.g., amber color fill with a thicker border) when a venue is selected.*

### 4. Usage

#### Code
```swift
import MapplsUIWidgets
import MapplsMap

class YourViewController: UIViewController, PlacePickerViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MapplsMapView(frame: self.view.bounds)
        let placePickerView = PlacePickerView(frame: self.view.bounds, parentViewController: self, mapView: mapView)
        
        // 1. Enable Footprints
        placePickerView.isBuildingFootprintEnabled = true
        
        // 2. Customize Venue Appearance
        let venueAppearance = MapplsBuildingAppearance()
        venueAppearance.fillColor = "7782E3"
        venueAppearance.fillOpacity = "0.35"
        venueAppearance.strokeColor = "7782E3"
        venueAppearance.strokeWidth = "2"
        placePickerView.venueAppearance = venueAppearance
        
        placePickerView.delegate = self
        self.view.addSubview(placePickerView)
    }
    
    // MARK: - PlacePickerViewDelegate Methods
    func didPickedLocation(placemark: MapplsGeocodedPlacemark) {
        if placemark.isVenue, let venueDetails = placemark.venueDetails {
             print("Venue Name: \(venueDetails.venueName ?? "")")
        }
    }
    
    func didReverseGeocode(placemark: MapplsGeocodedPlacemark) {}
    func didFailedReverseGeocode(error: NSError?) {}
    func didCancelPlacePicker() {}
}
```

### 5. Response Structure (`MapplsGeocodedPlacemark`)

When a venue is picked, the response includes an `isVenue` flag and a `venueDetails` object containing deeper insights:

| Property | Description |
| --- | --- |
| `isVenue` | `Bool` - Indicates if the picked location is part of a complex venue. |
| `venueDetails` | `MapplsVenueDetails?` - An object containing venue-specific data. |

#### `MapplsVenueDetails` Object:
| Property | Description |
| --- | --- |
| `venueEloc` | The unique Mappls Pin / eLoc for the venue boundary. |
| `venueName` | The name of the venue (e.g., "CRC Sublimis"). |
| `venueAddress` | The full formatted address of the venue. |
| `venueEntries` | An array of `MapplsVenueEntry` objects representing the authorized gates. |

#### `MapplsVenueEntry` Object:
| Property | Description |
| --- | --- |
| `eName` | The name of the entry gate (e.g., "Gate No 1"). |
| `eType` | The type of the gate (e.g., "Gate", "Navigable"). |
| `elat` | Latitude of the entry point. |
| `elng` | Longitude of the entry point. |

---

For any queries and support, please contact:

[<img src="https://about.mappls.com/images/mappls-logo.svg" height="40"/> </p>](https://about.mappls.com/api/)
Email us at [apisupport@mappls.com](mailto:apisupport@mappls.com)

![](https://about.mappls.com/api/img/icons/support.png)
[Support](https://about.mappls.com/contact/)
Need support? contact us!

<div align="center">@ Copyright 2024 CE Info Systems Ltd. All Rights Reserved.</div>
