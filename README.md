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
| [v1.0.18](./docs/v1.0.18/README.md) | - [MapplsAPICore - 1.0.10](./docs/v1.0.18/MapplsAPICore.md) <br/> - [MapplsAPIKit - 2.0.20](./docs/v1.0.18/MapplsAPIKit.md) <br/> - [MappplsMap - 5.13.10](./docs/v1.0.18/MapplsMap.md#Vector-iOS-Map) <br/> - [MapplsUIWidget - 1.0.4](./docs/v1.0.18/MapplsUIWidgets.md) <br/> - [MapplsNearbyUI - 1.0.0](./docs/v1.0.18/MapplsNearbyUI.md) <br/> - [MapplsDirectionUI - 1.0.7](./docs/v1.0.18/MapplsDirectionUI.md) <br/> - [MapplsGeoanalytics - 1.0.0](./docs/v1.0.18/MapplsGeoanalytics.md) <br/> - [MapplsFeedbackKit - 1.0.0](./docs/v1.0.18/MapplsFeedbackKit.md) <br/> - [MapplsFeedbackUIKit - 1.0.0](./docs/v1.0.18/MapplsFeedbackUIKit.md) <br/> - [MapplsDrivingRangePlugin - 1.0.2](./docs/v1.0.18/MapplsDrivingRangePlugin.md) <br/> - [MapplsAnnotationExtension - 1.0.0](./docs/v1.0.18/MapplsAnnotationExtension.md) <br/> - [MapplsGeofenceUI - 1.0.1](./docs/v1.0.18/MapplsGeofenceUI.md) <br/> - [MapplsRasterCatalogue - 0.1.0](./docs/v1.0.18/RasterCatalouge.md) <br/> - [MapplsIntouch - 1.0.1](./docs/v1.0.18/MapplsIntouch.md)|
| [v1.0.17](./docs/v1.0.17/README.md) | - [MapplsAPICore - 1.0.9](./docs/v1.0.17/MapplsAPICore.md) <br/> - [MapplsAPIKit - 2.0.19](./docs/v1.0.17/MapplsAPIKit.md) <br/> - [MappplsMap - 5.13.10](./docs/v1.0.17/MapplsMap.md#Vector-iOS-Map) <br/> - [MapplsUIWidget - 1.0.4](./docs/v1.0.17/MapplsUIWidgets.md) <br/> - [MapplsNearbyUI - 1.0.0](./docs/v1.0.17/MapplsNearbyUI.md) <br/> - [MapplsDirectionUI - 1.0.7](./docs/v1.0.17/MapplsDirectionUI.md) <br/> - [MapplsGeoanalytics - 1.0.0](./docs/v1.0.17/MapplsGeoanalytics.md) <br/> - [MapplsFeedbackKit - 1.0.0](./docs/v1.0.17/MapplsFeedbackKit.md) <br/> - [MapplsFeedbackUIKit - 1.0.0](./docs/v1.0.17/MapplsFeedbackUIKit.md) <br/> - [MapplsDrivingRangePlugin - 1.0.2](./docs/v1.0.17/MapplsDrivingRangePlugin.md) <br/> - [MapplsAnnotationExtension - 1.0.0](./docs/v1.0.17/MapplsAnnotationExtension.md) <br/> - [MapplsGeofenceUI - 1.0.1](./docs/v1.0.17/MapplsGeofenceUI.md) <br/> - [MapplsRasterCatalogue - 0.1.0](./docs/v1.0.17/RasterCatalouge.md) <br/> - [MapplsIntouch - 1.0.1](./docs/v1.0.17/MapplsIntouch.md)|
. . . . . .

For More History Go Here: [Version History](./Version-History.md)

Reference to the documentation of Previous SDK versions [here](https://github.com/mappls-api/mapmyindia-maps-vectorSDK-iOS)

## [Table Of Content](#Table-Of-Content)
- [Mappls API Core](./docs/v1.0.18/MapplsAPICore.md)[](#Mappls-API-Core)

- [Mappls API Kit](./docs/v1.0.18/MapplsAPIKit.md)
    * [Autosuggest API](./docs/v1.0.18/MapplsAPIKit.md#Autosuggest-API)
    * [Reverse Geocode API](./docs/v1.0.18/MapplsAPIKit.md#Reverse-Geocoding-API)
    * [Nearby API](./docs/v1.0.18/MapplsAPIKit.md#Nearby-API)
    * [Place Detail](./docs/v1.0.18/MapplsAPIKit.md#Place-Detail)
    * [Geocode API](./docs/v1.0.18/MapplsAPIKit.md#Geocoding-API)
    * [Routing API](./docs/v1.0.18/MapplsAPIKit.md#Routing-API)
    * [Driving Distance - Time Matrix API](./docs/v1.0.18/MapplsAPIKit.md#Driving-Distance-Time-Matrix-API)
    * [POI Along The Route](./docs/v1.0.18/MapplsAPIKit.md#POI-Along-The-Route-API)
    * [Nearby Reports API](./docs/v1.0.18/MapplsAPIKit.md#Nearby-Reports-API)
    * [Current Weather Condition API](./docs/v1.0.18/MapplsAPIKit.md#Current-Weather-Condition-API)
    * [Trip Cost Estimation API](./docs/v1.0.18/MapplsAPIKit.md#Trip-Cost-Estimation-API)

- [Set Country Regions](./docs/v1.0.18/Regions.md)
    - [Country List](https://github.com/mappls-api/mapmyindia-rest-api/blob/master/docs/countryISO.md)

- [Mappls Map](./docs/v1.0.18/MapplsMap.md#Vector-iOS-Map)
    * [Getting Started](./docs/v1.0.18/MapplsMap.md#Getting-Started)
    * [Setup your Project](./docs/v1.0.18/MapplsMap.md#Setup-your-Project)
    * [Usage](./docs/v1.0.18/MapplsMap.md#Usage)    
    * [Add a Mappls Map View](./docs/v1.0.18/MapplsMap.md#Add-a-Mappls-Map-View)
        * [SwiftUI](./docs/v1.0.18/MapplsMap.md#SwiftUI)
    * [Map Interactions](./docs/v1.0.18/MapplsMap.md#Map-Interactions)
    * [Map Features](./docs/v1.0.18/MapplsMap.md#Map-Features)
    * [Map Events](./docs/v1.0.18/MapplsMap.md#Map-Events)
    * [Map Overlays](./docs/v1.0.18/MapplsMap.md#Map-Overlays)
    * [Polylines](./docs/v1.0.18/MapplsMap.md#Polylines)
    * [Polygons](./docs/v1.0.18/MapplsMap.md#Polygons)
    * [Map Camera](./docs/v1.0.18/MapplsMap.md#Map-Camera)
    * [Miscellaneous](./docs/v1.0.18/MapplsMap.md#Miscellaneous)
    * [Cluster Based Authentication](./docs/v1.0.18/MapplsMap.md#Cluster-Based-Authentication)

- [Mappls Pin Strategy - Mappls Map](./docs/v1.0.18/MapplsPinStrategy.md)

- [Mappls Map Styles - Mappls Map](./docs/v1.0.18/MapplsMapStyle.md)

- [Interactive Layers - Mappls Map](./docs/v1.0.18/InteractiveLayers.md)

- [Traffic Vector Tiles Overlay - Mappls Map](./docs/v1.0.18/MapplsTrafficVectorTileOverlay.md)

- [Mappls UI Widgets](./docs/v1.0.18/MapplsUIWidgets.md)
    - [Introduction](./docs/v1.0.18/MapplsUIWidgets.md#Introduction)
    - [Installation](./docs/v1.0.18/MapplsUIWidgets.md#Installation)
        - [Version History](./docs/v1.0.18/MapplsUIWidgets.md#Version-History)
    - [Autocomplete](./docs/v1.0.18/MapplsUIWidgets.md#Autocomplete)
        - [SwiftUI](./docs/v1.0.18/MapplsUIWidgets.md#SwiftUI-Full-Screen-Control)
    - [Place Picker View](./docs/v1.0.18/MapplsUIWidgets.md#Place-Picker-View)
    - [Autocomplete Attribution Appearance](./docs/v1.0.18/MapplsUIWidgets.md#Autocomplete-Attribution-Appearance)

- [Mappls Nearby UI](./docs/v1.0.18/MapplsNearbyUI.md)
    - [Introduction](./docs/v1.0.18/MapplsNearbyUI.md#Introduction)
    - [Installation](./docs/v1.0.18/MapplsNearbyUI.md#Installation)
        - [Version History](./docs/v1.0.18/MapplsNearbyUI.md#Version-History)
    - [Launching with default configuration](./docs/v1.0.18/MapplsNearbyUI.md#Launching-with-default-configuration)
    - [MapplsNearbyCategoriesViewControllerDelegate](./docs/v1.0.18/MapplsNearbyUI.md#MapplsNearbyCategoriesViewControllerDelegate)

- [Mappls Direction UI Widget](./docs/v1.0.18/MapplsDirectionUI.md)
    - [Introduction](./docs/v1.0.18/MapplsDirectionUI.md#Introduction)
    - [Installation](./docs/v1.0.18/MapplsDirectionUI.md#Installation)
        - [Version History](./docs/v1.0.18/MapplsDirectionUI.md#Version-History)
    - [Usage](./docs/v1.0.18/MapplsDirectionUI.md#Usage)
        - [MapplsDirectionsViewController](./docs/v1.0.18/MapplsDirectionUI.md#MapplsDirectionsViewController)

- [Mappls Geoanalytics](./docs/v1.0.18/MapplsGeoanalytics.md)

- [Mappls Feedback Kit](./docs/v1.0.18/MapplsFeedbackKit.md)

- [Mappls Feedback UI Kit](./docs/v1.0.18/MapplsFeedbackUIKit.md)

- [Mappls Raster Catalogue Plugin](./docs/v1.0.18/RasterCatalouge.md)

- [Mappls Driving Range plugin](./docs/v1.0.18/MapplsDrivingRangePlugin.md)
  - [Introduction](./docs/v1.0.18/MapplsDrivingRangePlugin.md#Introduction)
  - [Installation](./docs/v1.0.18/MapplsDrivingRangePlugin.md#Installation)
      - [Version History](./docs/v1.0.18/MapplsDrivingRangePlugin.md#Version-History)

- [Mappls Annotation Extension](./docs/v1.0.18/MapplsAnnotationExtension.md)

- [Mappls Geofence UI Plugin](./docs/v1.0.18/MapplsGeofenceUI.md)

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
