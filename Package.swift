// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "AccessoSDK",
    products: [
        .library(name: "AccessoExperiencePromoter", targets: ["AccessoExperiencePromoter"]),
        .library(name: "AccessoCore", targets: ["AccessoCore"]),
        .library(name: "AccessoCommerce", targets: ["AccessoCommerce"]),
        .library(name: "AccessoEntitlements", targets: ["AccessoEntitlements"]),
        .library(name: "AccessoQueueing", targets: ["AccessoQueueing"]),
        .library(name: "AccessoWallet", targets: ["AccessoWallet"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(name: "AccessoExperiencePromoter", path: "./AccessoExperiencePromoter/AccessoExperiencePromoter.xcframework"),
        .binaryTarget(name: "AccessoCore", path: "./AccessoCore/AccessoCore.xcframework"),
        .binaryTarget(name: "AccessoCommerce", path: "./AccessoCommerce/AccessoCommerce.xcframework"),
        .binaryTarget(name: "AccessoEntitlements", path: "./AccessoEntitlements/AccessoEntitlements.xcframework"),
        .binaryTarget(name: "AccessoQueueing", path: "./AccessoQueueing/AccessoQueueing.xcframework"),
        .binaryTarget(name: "AccessoWallet", path: "./AccessoWallet/AccessoWallet.xcframework"),
    ]
)