# AccessoSDKiOS Package

The AccessoSDKiOS package provides access to the Accesso XCFrameworks, allowing you to easily integrate various functionalities into your iOS applications.

## Libraries Included

This package consists of the following libraries:

- **AccessoCore**: Provides core functionality for the Accesso SDK.
- **AccessoExperiencePromoter**: Enables integration with the Experience Promoter feature.
- **AccessoEntitlements**: Manages entitlements and permissions within your application.

## Installation

To integrate the AccessoSDKiOS package into your Xcode project using Swift Package Manager, follow these steps:

1. Open your project in Xcode.
2. Select your project's target.
3. Go to the Swift Packages tab.
4. Click the "+" button to add a new package dependency.
5. Enter the URL of this repository: `https://github.com/accesso/accesso-sdk-ios-public`
6. Choose the package version and frameworks you'd like to use.
7. Make sure to add the framework to your app's main target.
8. Click Next and complete the installation.

**NOTE: AccessoCore is a required package and must be add for any framework to function.**


<img width="1102" alt="Screenshot 2023-08-30 at 9 57 49 AM" src="https://github.com/accesso/accesso-sdk-ios-public/assets/1459355/00faa27e-f264-4335-8a83-f088d03dbdd3">


Alternatively, you can add the package dependency manually to your Package.swift file:

dependencies: [
    .package(url: "https://github.com/accesso/accesso-sdk-ios-public", from: "1.0.0"),
],


## Usage

After adding the package dependency, you can import the libraries you need into your Swift code:

