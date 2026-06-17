
---
title: Precision Drop SDK for iOS
---

[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="60"/> </p>](https://about.mappls.com/api)

# Precision Drop SDK for iOS

**High-Accuracy Location Picking with Building & Venue Highlights**

Powered with India's most comprehensive and robust mapping functionalities. Now Available for [200+ nations and territories](https://github.com/MapmyIndia/mapmyindia-rest-api/blob/master/docs/countryISO.md) across the world.

## Introduction

Precision Drop is an advanced capability within the Mappls UI Widgets that enhances the standard Place Picker with high-precision features. It allows users to not only pick a location but also see the exact building boundaries and snap to authorized entry points for superior accuracy.

### Key Features:
1. **Building Footprint Highlight**: Automatically highlights the boundary of the selected building or house.
2. **Venue Highlight**: Support for highlighting complex venues like malls, airports, and IT parks.
3. **Entry Point Snapping**: Automatically snaps the picked location to the nearest authorized entry point of a building.
4. **Customizable Highlights**: Control the appearance (color, opacity, stroke) of building and entry point markers.

## Implementation

Precision Drop features are built directly into the `PlacePickerView`. You can enable and configure them using the properties below.

### 1. Enabling Building Highlights

To enable building and venue highlights, set the `isBuildingFootprintEnabled` property to `true`.

```swift
placePickerView.isBuildingFootprintEnabled = true
```

### 2. Properties & Customization

#### High-Precision Settings
- `isBuildingFootprintEnabled`: `Bool` - Enable or disable automatic building/venue boundary highlights. Default is `true`.
- `entryCoordinateSnapRadius`: `Double` - The radius (in meters) within which the picker will automatically snap to a building's entry point. Default is `50.0`.
- `isInitializeWithCustomLocation`: `Bool` - If set to `true`, the picker can be initialized at a specific coordinate to show the precision highlight immediately.

#### Building Appearance (`MapplsBuildingAppearance`)
You can customize how the building highlight looks on the map:

- `buildingAppearance`: `MapplsBuildingAppearance?` - Set custom style for residential/commercial buildings.
- `venueAppearance`: `MapplsBuildingAppearance?` - Set custom style for complex venues.

**Appearance Attributes:**
- `fillColor`: `String` - Hex color code for the building fill (e.g., "7782E3").
- `fillOpacity`: `String` - Opacity of the fill (0 to 1).
- `strokeColor`: `String` - Hex color code for the boundary line.
- `strokeWidth`: `String` - Width of the boundary line.
- `strokeOpacity`: `String` - Opacity of the boundary line.

### 3. Understanding MapplsBuildingAppearance

`MapplsBuildingAppearance` is a configuration class used to define the visual styling of building footprints and venue boundaries on the map. 

#### How it Works:
When a user selects a location that corresponds to a known building (Rooftop) or a Venue, the SDK fetches the boundary geometry. The `MapplsBuildingAppearance` object provides the styling parameters (like fill color, stroke width, and opacity) which are then applied to the map's raster layer to render the highlight.

- **`buildingAppearance`**: Applies styling specifically to residential or standalone commercial building rooftops.
- **`venueAppearance`**: Applies styling to the boundaries of large venues like shopping malls or airports.

By modifying this object, you can ensure that the precision highlights align with your application's theme and brand colors.

### 4. Customizing the Entry Point Layer

You can customize the appearance of the entry point markers by implementing the delegate method:

```swift
func didConfigureEntryLayer(source: MGLShapeSource, layerIdentifier: String) -> MGLCircleStyleLayer? {
    let layer = MGLCircleStyleLayer(identifier: layerIdentifier, source: source)
    layer.circleRadius = NSExpression(forConstantValue: 8)
    layer.circleColor = NSExpression(forConstantValue: UIColor.blue)
    return layer
}
```

## Usage Example

```swift
import MapplsUIWidgets

// Initialize PlacePickerView
let placePickerView = PlacePickerView(frame: self.view.bounds, parentViewController: self)

// Enable Precision Drop features
placePickerView.isBuildingFootprintEnabled = true
placePickerView.entryCoordinateSnapRadius = 100 // Increase snapping radius to 100m

// Customize Building Appearance
let appearance = MapplsBuildingAppearance()
appearance.fillColor = "FF0000" // Red fill
appearance.fillOpacity = "0.5"
appearance.strokeColor = "000000" // Black border
appearance.strokeWidth = "2"

placePickerView.buildingAppearance = appearance

self.view.addSubview(placePickerView)
```

## Response Structure (`MapplsGeocodedPlacemark`)

When a precision location is picked, the response includes details that indicate if a building or venue was identified:

| Property | Description |
| --- | --- |
| `isRoofTop` | Boolean indicating if the location is identified as a rooftop. |
| `isVenue` | Boolean indicating if the location is part of a complex venue. |
| `mapplsPin` | The unique Mappls Pin for the identified building. |
| `entryCoordinates` | An array of coordinates representing authorized entry points. |

---

For any queries and support, please contact:

[<img src="https://about.mappls.com/images/mappls-logo.svg" height="40"/> </p>](https://about.mappls.com/api/)
Email us at [apisupport@mappls.com](mailto:apisupport@mappls.com)

![](https://about.mappls.com/api/img/icons/support.png)
[Support](https://about.mappls.com/contact/)
Need support? contact us!

<div align="center">@ Copyright 2024 CE Info Systems Ltd. All Rights Reserved.</div>
