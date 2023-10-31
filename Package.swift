// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "AccessoSDK",
    products: [
        .library(name: "AccessoCore", targets: ["AccessoCore"]),
        .library(name: "AccessoExperiencePromoter", targets: ["AccessoExperiencePromoter"]),
        .library(name: "AccessoEntitlements", targets: ["AccessoEntitlements"]),
        .library(name: "AccessoQueueing", targets: ["AccessoQueueing"])
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "AccessoCore",
            path: "./XCFrameworks/AccessoCore.xcframework"
        ),
        .binaryTarget(
            name: "AccessoExperiencePromoter",
            path: "./XCFrameworks/AccessoExperiencePromoter.xcframework"
        ),
        .binaryTarget(
            name: "AccessoEntitlements",
            path: "./XCFrameworks/AccessoEntitlements.xcframework"
        ),
        .binaryTarget(
            name: "AccessoQueueing",
            path: "./XCFrameworks/AccessoQueueing.xcframework"
        ),
    ]
)
