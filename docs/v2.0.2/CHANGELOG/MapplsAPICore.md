# Changes to the MapplsAPICore SDK for iOS

## 2.1.2 - 31 Mar, 2026

### Added
- A class `MapplsAPICoreManager` has been added to initialise Mappls Core SDKs.  This can be done using the `initialiseSDK` function which accepts a config and an olf file path.  Function parameters are optional. If you don’t provide anything, the .olf and .config files found in the bundle will be considered.