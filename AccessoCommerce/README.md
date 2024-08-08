# AccessoCommerce

The Accesso Commerce is a powerful library within our accesso SDK designed to deliver fast access to commerce related entities.

## Features

## Requirements
- iOS 15.0+
- Swift 5.3+
- Xcode 12.0+

## Library Dependencies

- **AccessoCommerce**: Requires [AccessoCore](https://github.com/accesso/accesso-sdk-ios-public/tree/main/iOS-AccessoCore) for full functionality.

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
    .package(url: "https://github.com/accesso/accesso-sdk-ios-public", from: "1.0.0")
]
```

## Usage
To get started, import the necessary libraries:
```swift
import AccessoCore
import AccessoCommerce
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
    let commerce = try await CommerceProvicer.shared.get()
} catch {
    // Handle errors
}
```

For more comprehensive examples, check out the [sample app](https://github.com/accesso/accesso-sdk-ios-public/tree/main/iOS-AccessoCommerce/Samples).

## Contributing
We welcome contributions! If you'd like to contribute to the library, please follow the guidelines outlined in the [CONTRIBUTING.md](https://github.com/accesso/accesso-sdk-ios-public/tree/main/CONTRIBUTING.md) file of the AccessoSDK repository.

## License
This library is licensed under the terms of the [LICENSE](https://github.com/accesso/accesso-sdk-ios-public/tree/main/LICENSE) file of the AccessoSDK. Please review the license for details on how you can use and distribute this library.

## Contact
If you have any questions about this library, or if you want to contact accesso Technology Group, plc for any reason, please direct all correspondence to our Contact Us form: [https://www.accesso.com/contact-us](https://www.accesso.com/contact-us)

