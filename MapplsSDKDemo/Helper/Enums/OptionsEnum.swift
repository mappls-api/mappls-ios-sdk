//
//  OptionsEnum.swift
//  MapplsSDKDemo
//
//  Created by rento on 08/01/25.
//

import UIKit

enum OptionsEnum: String {
    case mapEvents = "Map Events"
    case camera = "Camera"
    case marker = "Marker"
    case location = "Location"
    case polyline = "Polyline"
    case restAPICall = "Rest API Call"
    case customWidgets = "Custom Widgets"
    case geoJSON = "GeoJSON"
    case mapLayers = "Map Layers"
    case utility = "Utility"
    
    var subOption: [SubOptionsEnum] {
        switch self {
        case .mapEvents:
            return [.mapFragment, .mapTap, .mapLongTap, .mapGesture, .mapStyle, .mapTraffic, .placeTap]
        case .camera:
            return [.cameraFeature, .locationCameraOptions, .cameraFeaturesInMapplsPin]
        case .location:
            return [.showUserLocation, .customUserLocationIcon, .showUserHeading, .showUserCourseTracking]
        case .restAPICall:
            return [.autosuggestAPI, .reverseGeocodeAPI, .nearbyAPI, .placeDetails, .geocodeAPI, .routingAPI, .predictiveDirection, .drivingDistanceTimeMatrixAPI, .predictiveDistance, .poiAlongRouteAPI, .nearbyReportAPI, .weatherConditionAPI, .tripPlanAPI, .hateosNearbyAPI].reversed()
        case .marker:
            return [.addAnnotationMarker, .removeMarker, .addAnnotationMarkerUsingMapplsPin, .addCustomMarkerUsingMapplsPin, .customAnnotationImage, .customAnnotationView, .calloutOnAnnotationClick, .customCalloutOnAnnotationClick, .actionOnAnnotationCalloutClick, .annotationUsingStyleLayer, .clustering, .advancedClustering, .tapGestureOnLayer, .multipleAnnotationsUsingStyleLayer, .titleInAnnotation, .annotationAnchorAndOffset, .annotationOverlapPriority, .draggableAnnoatation, .animatedMarker, .iconScale, .categoriesMarker, .multipleAnnotationMarkerWithBounds, .multipleLayerMarkerWithBounds, .dynamicClustering].reversed()
        case .polyline:
            return [.annotationPolyline, .stylePolyline, .polylineClick, .dashedPolyline, .dottedPolyline, .polylineBorder, .polylineWithDifferentColors, .congestionRoutePolyline, .polylineAnimatedLengthChange, .polygon, .circle, .interiorPolygon, .geodesicPolyline, .semicirclePolyline, .snakeMotionPolyline]
        case .customWidgets:
            return [.directionUI, .nearbyUI, .feedbackUI, .autocompleteUI, .placePickerView, .mapplsRasterCatalogue, .geofenceUI, .customGeofenceUI].reversed()
        case .geoJSON:
            return [.plotMarker, .plotPolyline, .plotPolygon]
        case .mapLayers:
            return [.heatMap, .indoorMap, .scalebar, .geoanalytics, .drivingRangePlugin]
        case .utility:
            return [.digiPin]
        }
    }
}

enum SubOptionsEnum: String {
    //MARK: Map Styles Sub Options
    case scalebar = "ScaleBar"
    case geoanalytics = "GeoAnalytics Plugin"
    case indoorMap = "Indoor Map"
    case heatMap = "Heat Map"
    case drivingRangePlugin = "Driving Range Plugin"
    
    //MARK: Map Events Sub Options
    case mapFragment = "Map View Controller"
    case mapTap = "Map Tap"
    case mapLongTap = "Map Long Tap"
    case mapGesture = "Map Gesture"
    case mapStyle = "Map Style"
    case mapTraffic = "Map Traffic"
    case placeTap = "Place Tap"
    
    //MARK: Camera Sub Options
    case cameraFeature = "Camera Feature"
    case locationCameraOptions = "Location Camera Options"
    case cameraFeaturesInMapplsPin = "Camera Features in Mappls Pin"
    
    //MARK: Location Sub Options
    case showUserLocation = "Show User Location"
    case customUserLocationIcon = "Customize Current Location Icon"
    case showUserHeading = "Show User Heading"
    case showUserCourseTracking = "Show User Course Tracking"
    
    //MARK: Rest API Sub Options
    case autosuggestAPI = "Autosuggest"
    case reverseGeocodeAPI = "Reverse Geocode"
    case nearbyAPI = "NearBy"
    case placeDetails = "Place Detail"
    case geocodeAPI = "Geocode"
    case routingAPI = "Get Direction"
    case drivingDistanceTimeMatrixAPI = "Get Distance"
    case hateosNearbyAPI = "Hateos NearBy API"
    case predictiveDirection = "Get Predictive Direction"
    case predictiveDistance = "Get Predictive Distance"
    case poiAlongRouteAPI = "POI Along the Route"
    case nearbyReportAPI = "NearBy Report"
    case weatherConditionAPI = "Current Weather Condition API"
    case tripPlanAPI = "Trip Planning API"
    
    //MARK: Marker Sub Options
    case addAnnotationMarker = "Add a Marker"
    case addAnnotationMarkerUsingMapplsPin = "Add Marker Using Mappls Pin"
    case addCustomMarkerUsingMapplsPin = "Add Custom Marker Using Mappls Pin"
    case customAnnotationImage = "Add Custom Marker"
    case customAnnotationView = "Add Custom Marker View"
    case calloutOnAnnotationClick = "Callout On Annotation Click"
    case customCalloutOnAnnotationClick = "Add Custom Info Window"
    case actionOnAnnotationCalloutClick = "Action On Annotation Callout Click"
    case annotationUsingStyleLayer = "Style Annotation"
    case clustering = "Cluster Marker"
    case advancedClustering = "Advanced Clustering"
    case tapGestureOnLayer = "Tap Gesture On Layer"
    case multipleAnnotationsUsingStyleLayer = "Multiple Annotations Using Style Layer"
    case titleInAnnotation = "Title In Annotations"
    case annotationAnchorAndOffset = "Annotation Anchor And Offset"
    case annotationOverlapPriority = "Annotation Overlap Priority"
    case draggableAnnoatation = "Marker Dragging"
    case animatedMarker = "Animate Marker Location"
    case removeMarker = "Remove Marker"
    case iconScale = "Icon Scale"
    case categoriesMarker = "Categories Marker"
    case multipleAnnotationMarkerWithBounds = "Multiple Annotation Marker With Bounds"
    case multipleLayerMarkerWithBounds = "Multiple Layer Marker With Bounds"
    case dynamicClustering = "Dynamic Clustering"
    
    //MARK: Polyline Sub Options
    case annotationPolyline = "Draw Polyline"
    case polylineClick = "Polyline Click"
    case stylePolyline = "Style Polyline"
    case dashedPolyline = "Dashed Polyline"
    case polylineBorder = "Polyline Width Border"
    case polylineWithDifferentColors = "Polyline With Gradient Color"
    case dottedPolyline = "Dotted Polyline"
    case congestionRoutePolyline = "Congestion Route Polyline"
    case polylineAnimatedLengthChange = "Polyline Animated Length Change"
    case polygon = "Draw Polygon"
    case circle = "Circle Annotation"
    case interiorPolygon = "Interior Polygon"
    case geodesicPolyline = "Geodesic Polyline"
    case semicirclePolyline = "Semicircle Polyline"
    case snakeMotionPolyline = "SnakeMotion Polyline"
    
    //MARK: Custom Widgets Sub Options
    case directionUI = "Direction UI"
    case nearbyUI = "Nearby UI"
    case feedbackUI = "Feedback UI"
    case autocompleteUI = "Autocomplete UI"
    case placePickerView = "Place Picker View"
    case mapplsRasterCatalogue = "Mappls Raster Catelogue"
    case geofenceUI = "GeofenceUI"
    case customGeofenceUI = "Custom GeofenceUI"
    
    //MARK: GeoJSON Sub Options
    case plotMarker = "Plot Marker"
    case plotPolyline = "Plot Polyline"
    case plotPolygon = "Plot Polygon"
    
    //MARK: Utility Sub Options
    case digiPin = "DIGIPIN"
    
    var subTitle: String {
        switch self {
        case .mapFragment:
            return "Add Map in View Controller"
        case .mapTap:
            return "Single tap event on map"
        case .mapLongTap:
            return "Long Press event on map"
        case .mapGesture:
            return "Map events and Map panning"
        case .mapStyle:
            return "Check out the diverse map style Mappls Offer"
        case .mapTraffic:
            return "Visualize Traffic services on Map"
        case .placeTap:
            return "Get POI Click Event with the details of the Place"
        case .showUserLocation:
            return "Display the user's current location on the map with a default marker"
        case .customUserLocationIcon:
            return "Functionality to change default current location"
        case .showUserHeading:
            return "Highlight the user's heading direction on the map for better orientation"
        case .showUserCourseTracking:
            return "Track and display the user's course as they move on the map"
        case .autosuggestAPI:
            return "API Call request for Autosuggest, displaying results of the searched place"
        case .reverseGeocodeAPI:
            return "API Call request for Rev-Geocode, displaying results of the results"
        case .nearbyAPI:
            return "API Call request for NearBy API, displaying its results"
        case .placeDetails:
            return "API Call request for Place detail, displaying its results"
        case .geocodeAPI:
            return "API Call request for Geocode, displaying results of the results"
        case .routingAPI:
            return "API Call request for get direction, displaying its results"
        case .drivingDistanceTimeMatrixAPI:
            return "API Call request for get distance, displaying its results"
        case .poiAlongRouteAPI:
            return "API Call request for POI Along the Route, displaying its results"
        case .nearbyReportAPI:
            return "API Call request for NearBy Report, displaying its results"
        case .weatherConditionAPI:
            return "Get real-time weather conditions for a specific location"
        case .predictiveDirection:
            return "API Call request for get predictive direction, displaying its results"
        case .hateosNearbyAPI:
            return "API Call request for Hateos NearBy API, displaying its results"
        case .predictiveDistance:
            return "API Call request for get distance, displaying its results"
        case .drivingRangePlugin:
            return "A driving range or isochrone of Mappls represents the area that can be reached within a specific time or distance from a starting point, often visualized as a polygon on a map."
        case .addAnnotationMarker:
            return "Add a marker and visualize it on map"
        case .customAnnotationImage:
            return "Add a custom marker and visualize it on map"
        case .customAnnotationView:
            return "Create and display a custom view for annotation markers"
        case .calloutOnAnnotationClick:
            return "Show a default callout with information when an annotation marker is clicked"
        case .addCustomMarkerUsingMapplsPin:
            return "Add a custom marker using mappls pin functionality"
        case .customCalloutOnAnnotationClick:
            return "Add a custom information window"
        case .actionOnAnnotationCalloutClick:
            return "Trigger specific actions or navigation when a callout on an annotation is clicked"
        case .annotationUsingStyleLayer:
            return "Add annotations using the style layer of the map"
        case .clustering:
            return "Add cluster markers on a map"
        case .annotationPolyline:
            return "Draw a polyline with the given list of location coordinates (Lat/Long)"
        case .dashedPolyline:
            return "Create a dashed polyline to represent routes or paths with a patterned design"
        case .polylineBorder:
            return "Add a border to the polyline for enhanced visibility and styling"
        case .polylineWithDifferentColors:
            return "Draw a Polyline with the given list of location coordinates (Lat/Long) with color gradient"
        case .dottedPolyline:
            return "Draw a dotted polyline to represent paths with a unique, lightweight style"
        case .polylineClick:
            return "Enable actions or events when the polyline is clicked"
        case .stylePolyline:
            return "Create a polyline using a style layer for advanced customization and rendering"
        case .directionUI:
            return "Display an interactive user interface for route selection"
        case .nearbyUI:
            return "Provide a user interface to explore and select nearby points of interest"
        case .feedbackUI:
            return "Enable users to provide feedback or report issues through a dedicated interface"
        case .autocompleteUI:
            return "Show a user-friendly interface for location suggestions as the user types"
        case .placePickerView:
            return "Integrate a place picker interface to allow users to select a location easily"
        case .tapGestureOnLayer:
            return "Get tap gesture on layer"
        case .multipleAnnotationsUsingStyleLayer:
            return "Add multiple annotations using style layer on the map"
        case .titleInAnnotation:
            return "Add title in annotations"
        case .annotationAnchorAndOffset:
            return "Set offset and anchor of annotations using style layer"
        case .annotationOverlapPriority:
            return "Set priority of annotations overlapping each other"
        case .draggableAnnoatation:
            return "Marker dragging functionality"
        case .congestionRoutePolyline:
            return "Show congestion on route using different colors"
        case .polylineAnimatedLengthChange:
            return "Animate the change in length of the polyline"
        case .animatedMarker:
            return "Animate the location of marker from one coordinate to the other"
        case .addAnnotationMarkerUsingMapplsPin:
            return "Add a marker using mappls pin funtionality"
        case .polygon:
            return "Funtionality to draw and plot a polygon on the map"
        case .circle:
            return "Add circle shape annotation to the map"
        case .plotMarker:
            return "Plot marker using geoJSON"
        case .plotPolyline:
            return "Plot polyline using geoJSON"
        case .plotPolygon:
            return "Plot polygon using geoJSON"
        case .advancedClustering:
            return "Advanced clustering using attributes of features"
        case .mapplsRasterCatalogue:
            return "Show geoanalytics layer on map"
        case .removeMarker:
            return "Remove an annotation marker"
        case .geofenceUI:
            return "Geofence UI for drawing areas on map"
        case .customGeofenceUI:
            return "Custom geofence UI"
        case .geoanalytics:
            return "Visualize Administrative Layers on Map as WMS Layers Available with Mappls Database."
        case .interiorPolygon:
            return "Draw interior polygon on the map"
        case .geodesicPolyline:
            return "Curve path drawn between two location on the map"
        case .iconScale:
            return "Icon scale factor scales the icon based on zoom level or any other value"
        case .categoriesMarker:
            return "Show different markers for different categories"
        case .multipleAnnotationMarkerWithBounds:
            return "Show multiple annotation markers with bounds"
        case .multipleLayerMarkerWithBounds:
            return "Show multiple layer markers with bounds"
        case .heatMap:
            return "Mappls Indoor Widget to focus on multi-storey buildings structure and floor wise data on map."
        case .scalebar:
            return "Visual tool that represents the relationship between map distances and real-world distances, helping users interpret spatial data accurately."
        case .indoorMap:
            return "Mappls Indoor Widget to focus on multi-storey buildings structure and floor wise data on map."
        case .cameraFeature:
            return "Explore camera features like Move Camera, Ease Camera & Animate Camera"
        case .locationCameraOptions:
            return "Functionality of long press on map to get location coordinates (Lat/Long)"
        case .cameraFeaturesInMapplsPin:
            return "Animate, Move or ease camera using mappls pin"
        case .digiPin:
            return "DIGIPIN simplifies address management by providing precise location-based identification"
        case .tripPlanAPI:
            return "Trip Planning API"
        case .semicirclePolyline:
            return "Funtionality to draw a Semi circle polyline on map"
        case .snakeMotionPolyline:
            return "Funtionality to draw snake motion polyline on map"
        case .dynamicClustering:
            return "Dynamic clustering on the map"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .mapFragment:
            return UIImage(named: "icon-map")!
        case .mapTap:
            return UIImage(named: "tap")!
        case .mapLongTap:
            return UIImage(named: "tap-&-hold")!
        case .mapGesture:
            return UIImage(named: "drag")!
        case .mapStyle:
            return UIImage(named: "style")!
        case .mapTraffic:
            return UIImage(named: "traffic")!
        case .placeTap:
            return UIImage(named: "click")!
        case .showUserLocation:
            return UIImage(named: "icon-map")!
        case .customUserLocationIcon:
            return UIImage(named: "icon-map")!
        case .showUserHeading:
            return UIImage(named: "icon-map")!
        case .showUserCourseTracking:
            return UIImage(named: "icon-map")!
        case .autosuggestAPI:
            return UIImage(named: "icon-map")!
        case .reverseGeocodeAPI:
            return UIImage(named: "icon-map")!
        case .nearbyAPI:
            return UIImage(named: "icon-map")!
        case .placeDetails:
            return UIImage(named: "icon-map")!
        case .geocodeAPI:
            return UIImage(named: "icon-map")!
        case .routingAPI:
            return UIImage(named: "icon-map")!
        case .drivingDistanceTimeMatrixAPI:
            return UIImage(named: "icon-map")!
        case .poiAlongRouteAPI:
            return UIImage(named: "icon-map")!
        case .nearbyReportAPI:
            return UIImage(named: "icon-map")!
        case .weatherConditionAPI:
            return UIImage(named: "icon-map")!
        case .addAnnotationMarker:
            return UIImage(named: "icon-map")!
        case .customAnnotationImage:
            return UIImage(named: "icon-map")!
        case .customAnnotationView:
            return UIImage(named: "icon-map")!
        case .calloutOnAnnotationClick:
            return UIImage(named: "icon-map")!
        case .customCalloutOnAnnotationClick:
            return UIImage(named: "icon-map")!
        case .actionOnAnnotationCalloutClick:
            return UIImage(named: "icon-map")!
        case .annotationUsingStyleLayer:
            return UIImage(named: "icon-map")!
        case .clustering:
            return UIImage(named: "icon-map")!
        case .annotationPolyline:
            return UIImage(named: "icon-map")!
        case .polylineClick:
            return UIImage(named: "icon-map")!
        case .stylePolyline:
            return UIImage(named: "icon-map")!
        case .dashedPolyline:
            return UIImage(named: "icon-map")!
        case .polylineBorder:
            return UIImage(named: "icon-map")!
        case .polylineWithDifferentColors:
            return UIImage(named: "icon-map")!
        case .dottedPolyline:
            return UIImage(named: "icon-map")!
        case .directionUI:
            return UIImage(named: "icon-map")!
        case .nearbyUI:
            return UIImage(named: "icon-map")!
        case .feedbackUI:
            return UIImage(named: "icon-map")!
        case .autocompleteUI:
            return UIImage(named: "icon-map")!
        case .placePickerView:
            return UIImage(named: "icon-map")!
        case .tapGestureOnLayer:
            return UIImage(named: "icon-map")!
        case .multipleAnnotationsUsingStyleLayer:
            return UIImage(named: "icon-map")!
        case .titleInAnnotation:
            return UIImage(named: "icon-map")!
        case .annotationAnchorAndOffset:
            return UIImage(named: "icon-map")!
        case .annotationOverlapPriority:
            return UIImage(named: "icon-map")!
        case .draggableAnnoatation:
            return UIImage(named: "icon-map")!
        case .congestionRoutePolyline:
            return UIImage(named: "icon-map")!
        case .polylineAnimatedLengthChange:
            return UIImage(named: "icon-map")!
        case .animatedMarker:
            return UIImage(named: "icon-map")!
        case .circle:
            return UIImage(named: "icon-map")!
        case .polygon:
            return UIImage(named: "icon-map")!
        case .plotMarker:
            return UIImage(named: "icon-map")!
        case .plotPolyline:
            return UIImage(named: "icon-map")!
        case .plotPolygon:
            return UIImage(named: "icon-map")!
        case .advancedClustering:
            return UIImage(named: "icon-map")!
        case .mapplsRasterCatalogue:
            return UIImage(named: "icon-map")!
        case .removeMarker:
            return UIImage(named: "icon-map")!
        case .geofenceUI:
            return UIImage(named: "icon-map")!
        case .customGeofenceUI:
            return UIImage(named: "icon-map")!
        case .interiorPolygon:
            return UIImage(named: "icon-map")!
        case .geodesicPolyline:
            return UIImage(named: "icon-map")!
        case .iconScale:
            return UIImage(named: "icon-map")!
        case .categoriesMarker:
            return UIImage(named: "icon-map")!
        case .multipleLayerMarkerWithBounds:
            return UIImage(named: "icon-map")!
        case .multipleAnnotationMarkerWithBounds:
            return UIImage(named: "icon-map")!
        default:
            return nil
        }
    }
}
