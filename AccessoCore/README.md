# AccessoCore
The AccessoCore is the foundational module of our SDK that plays a crucial role in providing a unified and reusable infrastructure across all modules.

## Features

- **Configuration**: Centralizes SDK-wide configurations, such as API keys, base URLs, or default behavior settings, maintaining a single source of truth for configurations.
- **Networking**: Ensures consistency in communication with Accesso endpoints, streamlining the process and adhering to API standards.
- **Identity**: Manages user identity and authentication tokens for a seamless experience.
- **Logging**: Easily monitor and manage SDK behavior to identify and debug issues efficiently.
  
## Requirements
- iOS 15.0+
- Swift 5.3+
- Xcode 12.0+

## Library Dependencies
N/A

## Installation
Here's how you can add the library to your project using different methods.

### Swift Package Manager
To integrate the AccessoSDKiOS package into your Xcode project using Swift Package Manager, follow these steps:

1. Open your project in Xcode.
2. Select your project's target.
3. Navigate to the `Package Dependencies` tab.
4. Click the `+` button to add a new package dependency.
5. Enter the URL of this repository: [https://github.com/accesso/accesso-sdk-ios](https://github.com/accesso/accesso-sdk-ios)
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
1. To get started, import the library:
```swift
import AccessoCore 
```

2. Obtain the `Accesso-Info.plist` file and replace its placeholder values with your actual project details. Import this configured file into your project. The `Accesso-Info.plist` contains essential configuration values required for setting up AccessoCore.

3. Initialize the SDK in your application, typically at the entry point of your choice. 
```swift
init() {
    CoreProvider.configure()
}
```

## Contributing
We welcome contributions! If you'd like to contribute to the library, please follow the guidelines outlined in the [CONTRIBUTING.md](https://github.com/accesso/accesso-sdk-ios/blob/dev/CONTRIBUTING.md) file of the AccessoSDK repository.

## License
This library is licensed under the terms of the [LICENSE](https://github.com/accesso/accesso-sdk-ios/blob/dev/LICENSE) file of the AccessoSDK. Please review the license for details on how you can use and distribute this library.

## Contact
If you have any questions about this library, or if you want to contact accesso Technology Group, plc for any reason, please direct all correspondence to our Contact Us form: [https://www.accesso.com/contact-us](https://www.accesso.com/contact-us)