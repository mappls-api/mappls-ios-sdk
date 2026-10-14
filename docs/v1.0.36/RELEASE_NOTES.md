# Mappls iOS SDK 1.0.36

Documentation: [`docs/v1.0.36/README.md`](docs/v1.0.36/README.md)

## Updated SDKs since v1.0.35

- **MapplsAPICore** 1.0.16 → 1.0.18
- **MapplsAPIKit** 2.0.32 → 2.0.38
- **MapplsAnnotationExtension** 1.0.1 → 1.0.3
- **MapplsDirectionUI** 1.0.10 → 1.0.11
- **MapplsDrivingRangePlugin** 1.0.2 → 1.0.3
- **MapplsGeofenceUI** 1.0.1 → 1.0.4
- **MapplsMap** 5.13.16 → 6.0.2
- **MapplsNearbyUI** 1.0.1 → 1.0.3
- **MapplsUIWidgets** 1.0.12 → 1.0.15
- **RasterCatalouge** 1.0.1

## Changelog

### MapplsAPICore

#### 1.0.18 (23 Jul 2026)

##### Changes
- Improvements and Bug Fixes.

#### 1.0.16 (02 Feb 2025)

##### Changes
- Improvements and Bug Fixes.

#### 1.0.15 (17 Dec 2024)

##### Changes
- Improvements.

#### 1.0.14 (13 Nov 2024)

##### Changes
- Added provision to set language in account manager to speak and visualize routing instructions.

#### 1.0.13 (23 Oct 2024)

##### Changes
- Bitcode disabled to support Xcode 16.

#### 1.0.12 (10 Oct 2024)

##### Changes
- Support added for Smart Trip Planning API.

#### 1.0.11 (08 May 2024)

##### Changes
- Apple Privacy Manifest file added., - Some support issue resolved for MapplsUIWidget SDK.

#### 1.0.10 (27 Oct 2023)

##### Changes
- Security Improvements.

#### 1.0.9 (22 Sep 2023)

##### Changes
- Bug fixes & Improvements.

#### 1.0.8 (18 Aug 2023)

##### Changes
- Bug fixes & Improvements.

#### 1.0.7 (07 Jun 2023)

##### Changes
- Bug fixes & Improvements.

#### 1.0.6 (30 May 2023)

##### Changes
- Domain of APIs changed.

#### 1.0.5 (30 Jan 2023)

##### Changes
- Error code opimization for initializing Map.

#### 1.0.4 (09 Dec 2022)

##### Changes
- A custom property `modelName` of extension `UIDevice` is made public.

#### 1.0.3 (13 Oct 2022)

##### Changes
- Some performance improvements and optimization.

### MapplsAPIKit

#### 2.0.38 (25 Sep, 2026)

##### Added
- Added a `responseLanguage` option to `MapplsNearbyAtlasOptions`, `MapplsTextSearchAtlasOptions`, and `MapplsPOIAlongTheRouteOptions` to request the response in a specified language.
- Added a `lang` property to the AutoSuggest (`MapplsAutoSuggestLocationResults`) and Nearby (`NearbyResult`) responses indicating the language of the returned results.
- Added an `isKeyword` property to `MapplsPlaceExplanation`.
##### Changed
- Renamed the `searchType` request parameter to `global` in `MapplsAutoSearchAtlasOptions`, `MapplsNearbyAtlasOptions`, `MapplsAtlasGeocodeOptions`, and `MapplsReverseGeocodeOptions`.
##### Removed
- Removed the unused internal `AutoSuggestResult` struct.

#### 2.0.30 (03 Feb, 2025)

##### Added
- Added Smart trip api.
- Added a `MapplsDigiPinUtility` class to get digipin from coordinate and vice-versa. 
- Added a page info, partner flag and filters in poi along the route.
- Added `EntryCoordinates` in response of reverse geocode api.

### MapplsAnnotationExtension

#### 1.0.3 (23 Jul 2026)

##### Changes
- Updated Map SDK.

#### 1.0.2 (25 Feb 2025)

##### Changes
- 'bitcode' disabled to support Xcode 15

#### 1.0.1 (23 Jul 2024)

##### Changes
- Fixed issue of marker not adding using Mappls Pin.

#### 1.0.0 (14 Jun 2022)

##### Changes
- Initial Mappls release.

### MapplsDirectionUI

#### 1.0.11 (07 Oct, 2026)

##### Added
- Added support for latest Mappls SDKs.

### MapplsDrivingRangePlugin

#### 1.0.3 (09 Oct, 2026)

#### Changed

- Added support for installation via Swift Package Manager.
- Dependencies updated to the latest SDK versions.

### MapplsGeofenceUI

#### 1.0.4 (08 Oct, 2026)

##### Changed
- Updated to the latest dependencies.

#### 1.0.3 (24 Dec, 2026)

##### Changed
- Added a delegate method to stop dragging.

#### 1.0.2 (25 Feb, 2022)

##### Changed
- 'bitcode' disabled to support Xcode 15. |

### MapplsMap

#### 6.0.2 (23 July 2026)

##### Changes
- Bug fixes and improvementes.

#### 6.0.1 (17 July 2026)

##### Changes
- Bug fixes and improvementes

#### 6.0.0 (06 Jun 2025)

##### Changes
- Updated minimum iOS deployment target to 13.0
- Authentication and authorization mechanisms have been revised.

### MapplsNearbyUI

#### 1.0.3 (07 Oct, 2026)

##### Changed
- Updated dependencies and build configuration for the legacy auth distribution.

#### 1.0.2 (25 Feb, 2025)

##### Changed
- 'bitcode' disabled to support Xcode 15.

### MapplsUIWidgets

#### 1.0.15 (06 Oct, 2026)

##### Changed
- Updated the release pipeline and build scripts for the MapplsUIWidgets SDK.

#### 1.0.14 (06 Oct, 2026)

##### Changed
- Restructured the project by flattening the directory layout and migrating dependency management from CocoaPods/Carthage to Swift Package Manager.

#### 1.0.13 (06 Apr, 2026)

##### Added
- Added venue highlight feature along with a sample.
- Added a delegate method to modify the request of autosuggest and text search.

##### Removed
- Removed the `hyperLocal` and `zoom` parameters from the request.

#### 1.0.9 (24 Oct, 2024)

##### Added
- Bitcode disabled to support Xcode 16.

##### Changed
- Property 'attributions' of 'MapplsAutocompleteFilter' set to true by default.
- In PlacePicker on Autosuggest logic is improved to set name of place.

### RasterCatalouge

#### 1.0.1 (09 Oct, 2026)

##### Added

- Support for Mappls Authorization 2.0 (OAuth based authentication).

##### Changed

- Re-structured the project and added Swift Package Manager (SPM) support.
- Updated dependencies:
  - `MapplsAPICore` to `2.1.4`
  - `MapplsAPIKit` to `3.0.8`
  - `MapplsMap` to `6.1.5`

#### 0.1.0 (15 Jul, 2022)

##### Changed

- Initial Mappls release.
