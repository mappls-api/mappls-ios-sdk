[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="80"/> </p>](https://www.mapmyindia.com/api)

# Mappls iOS SDK
Explore the largest directory of APIs & SDKs for maps, routes and search.

`MAPPLS` will be there in every step of the way, building new tools that help you navigate, explore and get things done, wherever you are and users can touch or interact with map features clearly overlaid on your view of the world.

Our APIs, SDKs, and live updating map data available for [200+ nations and territories](https://github.com/MapmyIndia/mapmyindia-rest-api/blob/master/docs/countryISO.md) give developer-friendly, easy-to-integrate plugins to add capabilities like intelligent
search and routes on map, to your web or mobile applications.

You can get your api key to be used in this document here: [https://apis.mappls.com/console/](https://apis.mappls.com/console/)

## [Documentation History](#Documentation-History)

| Version | Supported SDK Version |
| ------- | --------------------- |
| [v1.0.2](README.md) | - [MapplsAPICore - 1.0.3](MapplsAPICore.md) <br/> - [MapplsAPIKit - 2.0.7](MapplsAPIKit.md) <br/> - [MappplsMap - 5.13.4](MapplsMap.md#Vector-iOS-Map) <br/> - [MapplsUIWidget - 1.0.1](MapplsUIWidgets.md) <br/> - [MapplsNearbyUI - 1.0.0](MapplsNearbyUI.md) <br/> - [MapplsDirectionUI - 1.0.1](MapplsDirectionUI.md) <br/> - [MapplsGeoanalytics - 1.0.0](MapplsGeoanalytics.md) <br/> - [MapplsFeedbackKit - 1.0.0](MapplsFeedbackKit.md) <br/> - [MapplsFeedbackUIKit - 1.0.0](MapplsFeedbackUIKit.md) <br/> - [MapplsDrivingRangePlugin - 1.0.1](MapplsDrivingRangePlugin.md) <br/> - [MapplsAnnotationExtension - 1.0.0](MapplsAnnotationExtension.md) <br/> - [MapplsGeofenceUI - 1.0.0](MapplsGeofenceUI.md) <br/> - [MapplsRasterCatalogue - 0.1.0](RasterCatalouge.md)|
| [v1.0.1](../v1.0.1/README.md) | - [MapplsAPICore - 1.0.3](../v1.0.1/MapplsAPICore.md) <br/> - [MapplsAPIKit - 2.0.6](../v1.0.1/MapplsAPIKit.md) <br/> - [MappplsMap - 5.13.4](../v1.0.1/MapplsMap.md#Vector-iOS-Map) <br/> - [MapplsUIWidget - 1.0.1](../v1.0.1/MapplsUIWidgets.md) <br/> - [MapplsNearbyUI - 1.0.0](../v1.0.1/MapplsNearbyUI.md) <br/> - [MapplsDirectionUI - 1.0.1](../v1.0.1/MapplsDirectionUI.md) <br/> - [MapplsGeoanalytics - 1.0.0](../v1.0.1/MapplsGeoanalytics.md) <br/> - [MapplsFeedbackKit - 1.0.0](../v1.0.1/MapplsFeedbackKit.md) <br/> - [MapplsFeedbackUIKit - 1.0.0](../v1.0.1/MapplsFeedbackUIKit.md) <br/> - [MapplsDrivingRangePlugin - 1.0.1](../v1.0.1/MapplsDrivingRangePlugin.md) <br/> - [MapplsAnnotationExtension - 1.0.0](../v1.0.1/MapplsAnnotationExtension.md) <br/> - [MapplsGeofenceUI - 1.0.0](../v1.0.1/MapplsGeofenceUI.md) <br/> - [MapplsRasterCatalogue - 0.1.0](../v1.0.1/RasterCatalouge.md)|

For More History Go Here: [Version History](../../Version-History.md)

Reference to the documentation of Previous SDK versions [here](https://github.com/mappls-api/mapmyindia-maps-vectorSDK-iOS)

## [Table Of Content](#Table-Of-Content)
- [Mappls API Core](MapplsAPICore.md)

- [Mappls API Kit](MapplsAPIKit.md)
    * [Autosuggest API](MapplsAPIKit.md#Autosuggest-API)
    * [Reverse Geocode API](MapplsAPIKit.md#Reverse-Geocoding-API)
    * [Nearby API](MapplsAPIKit.md#Nearby-API)
    * [Place Detail](MapplsAPIKit.md#Place-Detail)
    * [Geocode API](MapplsAPIKit.md#Geocoding-API)
    * [Routing API](MapplsAPIKit.md#Routing-API)
    * [Driving Distance - Time Matrix API](MapplsAPIKit.md#Driving-Distance-Time-Matrix-API)
    * [POI Along The Route](MapplsAPIKit.md#POI-Along-The-Route-API)
    * [Nearby Reports API](MapplsAPIKit.md#Nearby-Reports-API)

- [Set Country Regions](Regions.md)
    - [Country List](https://github.com/mappls-api/mapmyindia-rest-api/blob/master/docs/countryISO.md)

- [Mappls Map](MapplsMap.md#Vector-iOS-Map)
    * [Getting Started](MapplsMap.md#Getting-Started)
    * [Setup your Project](MapplsMap.md#Setup-your-Project)
    * [Usage](MapplsMap.md#Usage)    
    * [Add a Mappls Map View](MapplsMap.md#Add-a-Mappls-Map-View)
        * [SwiftUI](MapplsMap.md#SwiftUI)
    * [Map Interactions](MapplsMap.md#Map-Interactions)
    * [Map Features](MapplsMap.md#Map-Features)
    * [Map Events](MapplsMap.md#Map-Events)
    * [Map Overlays](MapplsMap.md#Map-Overlays)
    * [Polylines](MapplsMap.md#Polylines)
    * [Polygons](MapplsMap.md#Polygons)
    * [Map Camera](MapplsMap.md#Map-Camera)
    * [Miscellaneous](MapplsMap.md#Miscellaneous)
    * [Cluster Based Authentication](MapplsMap.md#Cluster-Based-Authentication)

- [Mappls Pin Strategy - Mappls Map](MapplsPinStrategy.md)

- [Mappls Map Styles - Mappls Map](MapplsMapStyle.md)

- [Interactive Layers - Mappls Map](InteractiveLayers.md)

- [Traffic Vector Tiles Overlay - Mappls Map](MapplsTrafficVectorTileOverlay.md)

- [Mappls UI Widgets](MapplsUIWidgets.md)
    - [Introduction](MapplsUIWidgets.md#Introduction)
    - [Installation](MapplsUIWidgets.md#Installation)
        - [Version History](MapplsUIWidgets.md#Version-History)
    - [Autocomplete](MapplsUIWidgets.md#Autocomplete)
        - [SwiftUI](MapplsUIWidgets.md#SwiftUI-Full-Screen-Control)
    - [Place Picker View](MapplsUIWidgets.md#Place-Picker-View)
    - [Autocomplete Attribution Appearance](MapplsUIWidgets.md#Autocomplete-Attribution-Appearance)

- [Mappls Nearby UI](MapplsNearbyUI.md)
    - [Introduction](MapplsNearbyUI.md#Introduction)
    - [Installation](MapplsNearbyUI.md#Installation)
        - [Version History](MapplsNearbyUI.md#Version-History)
    - [Launching with default configuration](MapplsNearbyUI.md#Launching-with-default-configuration)
    - [MapplsNearbyCategoriesViewControllerDelegate](MapplsNearbyUI.md#MapplsNearbyCategoriesViewControllerDelegate)

- [Mappls Direction UI Widget](MapplsDirectionUI.md)
    - [Introduction](MapplsDirectionUI.md#Introduction)
    - [Installation](MapplsDirectionUI.md#Installation)
        - [Version History](MapplsDirectionUI.md#Version-History)
    - [Usage](MapplsDirectionUI.md#Usage)
        - [MapplsDirectionsViewController](MapplsDirectionUI.md#MapplsDirectionsViewController)

- [Mappls Geoanalytics](MapplsGeoanalytics.md)

- [Mappls Feedback Kit](MapplsFeedbackKit.md)

- [Mappls Feedback UI Kit](MapplsFeedbackUIKit.md)

- [Mappls Raster Catalogue Plugin](RasterCatalouge.md)

- [Mappls Driving Range plugin](MapplsDrivingRangePlugin.md)
  - [Introduction](MapplsDrivingRangePlugin.md#Introduction)
  - [Installation](MapplsDrivingRangePlugin.md#Installation)
      - [Version History](MapplsDrivingRangePlugin.md#Version-History)

- [Mappls Annotation Extension](MapplsAnnotationExtension.md)

- [Mappls Geofence UI Plugin](MapplsGeofenceUI.md)

<br><br><br>

## Our many happy customers:

![](https://www.mapmyindia.com/api/img/logos1/PhonePe.png)![](https://www.mapmyindia.com/api/img/logos1/Arya-Omnitalk.png)![](https://www.mapmyindia.com/api/img/logos1/delhivery.png)![](https://www.mapmyindia.com/api/img/logos1/hdfc.png)![](https://www.mapmyindia.com/api/img/logos1/TVS.png)![](https://www.mapmyindia.com/api/img/logos1/Paytm.png)![](https://www.mapmyindia.com/api/img/logos1/FastTrackz.png)![](https://www.mapmyindia.com/api/img/logos1/ICICI-Pru.png)![](https://www.mapmyindia.com/api/img/logos1/LeanBox.png)![](https://www.mapmyindia.com/api/img/logos1/MFS.png)![](https://www.mapmyindia.com/api/img/logos1/TTSL.png)![](https://www.mapmyindia.com/api/img/logos1/Novire.png)![](https://www.mapmyindia.com/api/img/logos1/OLX.png)![](https://www.mapmyindia.com/api/img/logos1/sun-telematics.png)![](https://www.mapmyindia.com/api/img/logos1/Sensel.png)![](https://www.mapmyindia.com/api/img/logos1/TATA-MOTORS.png)![](https://www.mapmyindia.com/api/img/logos1/Wipro.png)![](https://www.mapmyindia.com/api/img/logos1/Xamarin.png)

<br>

For any queries and support, please contact:

[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="40"/> </p>](https://about.mappls.com/api/)

Email us at [apisupport@mappls.com](mailto:apisupport@mappls.com)

![](https://www.mapmyindia.com/api/img/icons/support.png)
[Support](https://about.mappls.com/contact/)
Need support? contact us!

<br></br>

[<p align="center"> <img src="https://www.mapmyindia.com/api/img/icons/stack-overflow.png"/> ](https://stackoverflow.com/questions/tagged/mappls-api)[![](https://www.mapmyindia.com/api/img/icons/blog.png)](https://about.mappls.com/blog/)[![](https://www.mapmyindia.com/api/img/icons/gethub.png)](https://github.com/mappls-api)[<img src="https://mmi-api-team.s3.ap-south-1.amazonaws.com/API-Team/npm-logo.one-third%5B1%5D.png" height="40"/> </p>](https://www.npmjs.com/org/mapmyindia) 

[<p align="center"> <img src="https://www.mapmyindia.com/june-newsletter/icon4.png"/> ](https://www.facebook.com/Mapplsofficial)[![](https://www.mapmyindia.com/june-newsletter/icon2.png)](https://twitter.com/mappls)[![](https://www.mapmyindia.com/newsletter/2017/aug/llinkedin.png)](https://www.linkedin.com/company/mappls/)[![](https://www.mapmyindia.com/june-newsletter/icon3.png)](https://www.youtube.com/channel/UCAWvWsh-dZLLeUU7_J9HiOA)

<div align="center">@ Copyright 2022 CE Info Systems Pvt. Ltd. All Rights Reserved.</div>

<div align="center"> <a href="https://about.mappls.com/api/terms-&-conditions">Terms & Conditions</a> | <a href="https://www.mappls.com/about/privacy-policy">Privacy Policy</a> | <a href="https://www.mappls.com/pdf/mappls-sustainability-policy-healt-labour-rules-supplir-sustainability.pdf">Supplier Sustainability Policy</a> | <a href="https://www.mappls.com/pdf/Health-Safety-Management.pdf">Health & Safety Policy</a> | <a href="https://www.mappls.com/pdf/Environment-Sustainability-Policy-CSR-Report.pdf">Environmental Policy & CSR Report</a>

<div align="center">Customer Care: +91-9999333223</div>
