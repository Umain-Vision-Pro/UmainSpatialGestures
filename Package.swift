// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UmainSpatialGestures",
    platforms: [.iOS("16.0"), .visionOS("1.0")],
    products: [
        .library(
            name: "UmainSpatialGestures",
            targets: ["UmainSpatialGestures"]),
    ],
    targets: [
        .target(
            name: "UmainSpatialGestures"),
    ]
)
