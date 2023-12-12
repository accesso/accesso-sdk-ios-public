// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "AccessoSDK",
    products: [
        .library(name: "AccessoCore", targets: ["AccessoCore"]),
        .library(name: "AccessoQueueing", targets: ["AccessoQueueing"])
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "AccessoCore",
            path: "./AccessoSDK/XCFrameworks/AccessoCore.xcframework"
        ),
        .binaryTarget(
            name: "AccessoQueueing",
            path: "./AccessoSDK/XCFrameworks/AccessoQueueing.xcframework"
        ),
    ]
)
