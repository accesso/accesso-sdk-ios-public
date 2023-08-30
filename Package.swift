// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "YourPackageName",
    products: [
        .library(name: "AccessoCore", targets: ["AccessoCore"]),
        .library(name: "AccessoExperiencePromoter", targets: ["AccessoExperiencePromoter"]),
        .library(name: "AccessoEntitlements", targets: ["AccessoEntitlements"]),
    ],
    dependencies: [
        // No need to specify dependencies if the libraries are standalone
    ],
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
    ]
)
