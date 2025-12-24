# Mappls Location Capture SDK (iOS)

## Getting Started

A lightweight, on-demand location capture SDK for **iOS** that enables applications to fetch a user’s current location efficiently with **accuracy limits**, **timeout control**, and **minimal battery usage**.

The SDK supports **single-shot** and **subscribed** location fetching without continuous tracking.

---

## Key Capabilities

- One-time location capture with accuracy threshold  
- Subscribed mode until accuracy or timeout is reached  
- Automatic termination (no background tracking)  
- Accuracy, timeout, and retry limits  
- Mock location detection  
- Lightweight footprint suitable for KYC, attendance, onboarding, check-ins  

---

## [Version History](#Version-History)

| Version | Dated | Description |
| `1.0.0`| 24 Dec 2025 | - Initial Release |


## Installation

### Add Mappls SDK (iOS)

Mappls iOS SDK is distributed via **Swift Package Manager (SPM)**.

---

### Using Swift Package Manager (SPM)

Open Xcode → File → Add Packages → Enter:

```
https://github.com/mappls-api/mappls-location-capture-sdk-ios-distribution.git
```

Select `MapplsLocationCapture` and add it to your target.

---

### Permissions (Required)

Add the following key to your `Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location is required to capture your current position.</string>
```

---

### Initialization (Required)

Initialization must be completed before invoking any location fetch method. During initialization, the SDK:

- Validates location permissions  
- Fetches server-driven configuration (accuracy, timeout, retry mode)  
- Performs SDK readiness check  
- Optionally enables logging  

```swift
LocationServiceProviderManager.shared.initialize(loggingEnabled: true) { result in
    switch result {
    case .success:
        print("SDK Initialized successfully")
    case .failure(let error):
        print("Initialization failed:", error.localizedDescription)
    }
}
```

---

### SDK Configuration (Optional)

After initialization, configuration can be customized if allowed by server policy:

```swift
try LocationServiceProviderManager.shared.configure(
    retryMode: .single,       // .single or .subscribe
    timeout: 60,              // seconds
    accuracy: 15,             // meters
    distance: 0,              // meters
    maxPacketSize: 5          // applicable for subscribe mode
)
```

---

### Location Fetch Methods

#### 1. Single-Shot Location Fetch

Fetches **one valid location snapshot** and terminates automatically.

```swift
LocationServiceProviderManager.shared.getOneTimeLocation { result in
    switch result {
    case .success(let event):
        print("""
        Location:
        lat=\(event.latitude),
        lng=\(event.longitude),
        accuracy=\(event.horizontalAccuracy),
        acceptable=\(event.isAccpectable),
        mock=\(event.isMockLocation)
        """)
    case .failure(let error):
        print("Error:", error.localizedDescription)
    }
}
```

#### 2. Subscribed Location Fetch (Limited)

Continuously receives location updates until accuracy, timeout, or packet limit is reached. Then auto-unsubscribes.

```swift
try LocationServiceProviderManager.shared.configure(
    retryMode: .subscribe,
    maxPacketSize: 5
)

LocationServiceProviderManager.shared.startFetchingLocation { result in
    switch result {
    case .success(let event):
        print("Location update:", event)
    case .failure(let error):
        print("Stopped:", error.localizedDescription)
    }
}
```

---

### Configuration Parameters

#### LocationCaptureConfig

| Parameter          | Description                              | Default       |
| ------------------ | ---------------------------------------- | ------------- |
| Interval           | Preferred location update interval       | 5 seconds     |
| Accuracy           | Minimum acceptable accuracy (meters)     | 15m           |
| Timeout            | Maximum time SDK attempts location fetch | 60 seconds    |
| NumberofAttempts | Maximum location packets                 | 5             |


#### MapplsLocationEngineRequest

| Parameter          | Description                              | Default       |
| ------------------ | ---------------------------------------- | ------------- |
| Priority           | Location priority mode                   | HIGH_ACCURACY |
| Displacement       | Minimum movement required                | 0 meters      |
<br>

> The SDK automatically stops once **accuracy OR timeout/attempt limit** is reached.


### Stop Location Updates

```swift
LocationServiceProviderManager.shared.stopLocation()
```

### Unsubscribe & Reset State

```swift
LocationServiceProviderManager.shared.unsubscribe()
```

---

### Output Details

Each successful callback provides:

- Latitude & Longitude  
- Accuracy (meters)  
- Altitude, speed, heading (if available)  
- Timestamps (generated & received)  
- Acceptable accuracy flag  
- Mock location flag  

---

### Error Handling

| Error | Description |
|-------|-------------|
| permissionDenied | Location permission denied |
| sdkNotInitialized | SDK not initialized |
| retryModeNotAllowed | Mode not allowed by server |
| maxTimeExceeded | Maximum timeout reached |
| maxPacketLimitReached | Packet limit exceeded |
| mockLocationDetected | Mock / fake location detected |
| network | Network failure |
| decoding | API response decoding error |

---

### Notes

- No background tracking  
- Location updates stop automatically  
- Server controls retry mode & overrides  
- Mock locations are rejected




