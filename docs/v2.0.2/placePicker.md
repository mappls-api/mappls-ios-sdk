
---
title: Place Picker SDK for iOS
---

[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="60"/> </p>](https://about.mappls.com/api)

# Place Picker SDK for iOS

**Easy To Integrate Maps & Location APIs & SDKs For iOS Applications**

Powered with India's most comprehensive and robust mapping functionalities. Now Available for [200+ nations and territories](https://github.com/MapmyIndia/mapmyindia-rest-api/blob/master/docs/countryISO.md) across the world.

## Introduction

The Place Picker View is a UIView component that allows a user to pick a Place using an interactive map.
Users can select a location which from center of map after succesfully reverse geocoding that location.

PlacePickerView is class whose instance can be created and can be added to ViewController. Below is sample code to understand:

The SDK offers the following basic functionalities:
1. Ability to pick or search places directly with or without Mappls Maps visual interface.
2. A `PlacePickerView` component to initiate the plugin and pick places from Mappls Maps.
3. Callback support to receive selected location data.
4. Customizable UI components including markers, buttons, and detail views.
5. Place/building and Venue boundary highlight.

## Installation

This SDK can be installed using CocoaPods. Add the following line to your `Podfile`:

```ruby
pod 'MapplsUIWidgets'
```

## Getting Access

Before using the SDK in your solution, please ensure that the related access is enabled in the [Mappls Console](https://auth.mappls.com/console/), within your app.

## Implementation

### 1. Initializing the Place Picker

The `PlacePickerView` can be initialized programmatically and added to your view hierarchy.

#### Method
`PlacePickerView(frame:parentViewController:mapView:searchBaseURL:reverseBaseUrl:)`

### 2. Delegate Methods (`PlacePickerViewDelegate`)

To handle user interactions and data, implement the `PlacePickerViewDelegate` protocol:

```swift
/// Called when the user clicks the confirmation ("Done") button.
func didPickedLocation(placemark: MapplsGeocodedPlacemark)

/// Called whenever reverse geocoding succeeds after moving the map or selecting a search result.
func didReverseGeocode(placemark: MapplsGeocodedPlacemark)

/// Called if there is an error during reverse geocoding.
func didFailedReverseGeocode(error: NSError?)

/// Called when the picker is closed or cancelled.
func didCancelPlacePicker()
```

### 3. Properties & Customization

The `PlacePickerView` provides several properties to customize its appearance and behavior:

#### UI Visibility
- `isSearchButtonHidden`: `Bool` - Hide or show the search button. Default is `false`.
- `isBottomInfoViewHidden`: `Bool` - Hide or show the bottom info view (containing instructions and "Done" button).
- `isBottomPlaceDetailViewHidden`: `Bool` - Hide or show the bottom place details view (showing address).
- `isShowBottomPlaceDetailsView`: `Bool` - Toggle all bottom UI components together.
- `isShowCurrentLocation`: `Bool` - Show or hide the current location button on the map.
- `isMarkerShadowViewHidden`: `Bool` - Hide or show the shadow of the center marker. Default is `false`.
- `isInitializeWithCustomLocation`: `Bool` - Set to `true` if you are programmatically setting an initial map center. Default is `false`.

#### Appearance
- `markerView`: `UIView!` - Custom view to be used as the center marker.
- `searchButtonBackgroundColor`: `UIColor?` - Custom background color for the search button.
- `searchButtonImage`: `UIImage?` - Custom image for the search button icon.
- `placeNameLabelTextColor`: `UIColor?` - Text color for the primary place name label.
- `addressLabelTextColor`: `UIColor?` - Text color for the detailed address label.
- `infoBottomViewBackgroundColor`: `UIColor?` - Background color for the instruction bar.
- `placeDetailsViewBackgroundColor`: `UIColor?` - Changes the background color of the bottom info container.
- `pickerButtonTitle`: `String?` - Title for the confirmation button (e.g., "Confirm Location").
- `pickerButtonTitleColor`: `UIColor?` - Text color for the confirmation button.
- `pickerButtonBackgroundColor`: `UIColor?` - Background color for the confirmation button.
- `infoLabelTextColor`: `UIColor?` - Text color for the instruction label.

#### Search & Map Settings
- `autocompleteFilter`: `MapplsAutocompleteFilter?` - Filter to refine search results (e.g., bias by location or filter by type).
- `autocompleteAttributionSettings`: `MapplsAttributionsSettings?` - Configure how attributions are displayed in the search interface.

#### Methods
- `openDefaultSearchController()` - This function can be used to open the default search controller programmatically.

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
        placePickerView.delegate = self
        self.view.addSubview(placePickerView)
    }
    
    // MARK: - PlacePickerViewDelegate Methods
    
    func didPickedLocation(placemark: MapplsGeocodedPlacemark) {
        print("Picked Location: \(placemark.formattedAddress ?? "")")
    }
    
    func didReverseGeocode(placemark: MapplsGeocodedPlacemark) {
        print("Current Address: \(placemark.formattedAddress ?? "")")
    }
}
```

### 5. Response Structure (`MapplsGeocodedPlacemark`)

The `MapplsGeocodedPlacemark` object returned in the delegates contains comprehensive location details:

| Property | Description |
| --- | --- |
| `formattedAddress` | The full human-readable address. |
| `houseNumber` | House or building number. |
| `houseName` | Name of the house or building. |
| `poi` | Name of the Point of Interest. |
| `street` | Street name. |
| `locality` | Locality name. |
| `subLocality` | Sub-locality name. |
| `city` | City or town name. |
| `state` | State name. |
| `pincode` | Postal code / PIN code. |
| `lat` | Latitude of the location. |
| `lng` | Longitude of the location. |
| `area` | General area name. |

---

For any queries and support, please contact:

[<img src="https://about.mappls.com/images/mappls-logo.svg" height="40"/> </p>](https://about.mappls.com/api/)
Email us at [apisupport@mappls.com](mailto:apisupport@mappls.com)

![](https://about.mappls.com/api/img/icons/support.png)
[Support](https://about.mappls.com/contact/)
Need support? contact us!

<div align="center">@ Copyright 2024 CE Info Systems Ltd. All Rights Reserved.</div>

