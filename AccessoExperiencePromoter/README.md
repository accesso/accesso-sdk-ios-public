# AccessoExperiencePromoter

The Accesso Experience Promoter, a robust component of our Accesso SDK, is designed to deliver personalized messages, retrieve a list of points of interest, automate location-based experiences, and furnish users with a comprehensive list of events. This ensures users stay informed about all available activities, enhancing their overall experience.

## Features

- **Push Personalized Messages**: Send tailor-made messages to your users, be it informative announcements, alluring images, captivating headlines, enticing offers, or more.
- **Explore Points of Interest**: Access a curated list of points of interest, enhancing your users' in-app experiences by providing valuable information about nearby attractions or services.
- **Location-Based Automation**: The SDK provides functions to send users' GPS location data to the backend service, enabling Control Room to deliver customized experiences based on user coordinates and associated user ID.
- **Events**: Retrieve comprehensive lists of events and explore trending events of a venue.

## Requirements

- iOS 15.0+
- Swift 5.3+
- Xcode 12.0+

## Library Dependencies

- **AccessoExperiencePromoter**: Requires [AccessoCore](https://github.com/accesso/accesso-sdk-ios-public/tree/main/AccessoCore) for full functionality.

## Installation
Here's how you can add the library to your project using different methods.

### Swift Package Manager
To integrate the AccessoSDKiOS package into your Xcode project using Swift Package Manager, follow these steps:

1. Open your project in Xcode.
2. Select your project's target.
3. Navigate to the `Package Dependencies` tab.
4. Click the `+` button to add a new package dependency.
5. Enter the URL of this repository: [https://github.com/accesso/accesso-sdk-ios-public](https://github.com/accesso/accesso-sdk-ios-public)
6. Choose the package version and frameworks you want to use.
7. Ensure you add the selected framework to your app's main target.
8. Click `Add Package` and complete the installation.

### Manual Installation
Alternatively, you can manually add the package dependency to your `Package.swift` file.

```swift
dependencies: [
    .package(url: "https://github.com/accesso/accesso-sdk-ios", from: "1.0.0")
]
```

## Usage
To get started, import the necessary libraries:
```swift
import AccessoCore
import AccessoExperiencePromoter
```

After that, initialize the SDK within your application, typically at a chosen entry point. Don't forget to import the `Accesso-Info.plist` into your project to configure AccessoCore.

swift
```swift
init() {
    CoreProvider.configure()
}
```

Now, you can use the SDK in your code. Here's an example:
```swift
do {
    let messages = try await ExperiencePromoterProvider.shared.getMessages(venueId: "VENUE_ID")
} catch {
    // Handle errors
}
```

For more comprehensive examples, check out the [sample app](https://github.com/accesso/accesso-sdk-ios-public/blob/main/AccessoExperiencePromoter/Samples/ExperiencePromoter).

## Contributing
We welcome contributions! If you'd like to contribute to the library, please follow the guidelines outlined in the [CONTRIBUTING.md](https://github.com/accesso/accesso-sdk-ios-public/blob/main/CONTRIBUTING.md) file of the AccessoSDK repository.

## License
This library is licensed under the terms of the [LICENSE](https://github.com/accesso/accesso-sdk-ios-public/blob/main/LICENSE) file of the AccessoSDK. Please review the license for details on how you can use and distribute this library.

## Contact
If you have any questions about this library, or if you want to contact accesso Technology Group, plc for any reason, please direct all correspondence to our Contact Us form: [https://www.accesso.com/contact-us](https://www.accesso.com/contact-us)

