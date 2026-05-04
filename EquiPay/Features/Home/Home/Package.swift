// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Home",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Home",
            targets: ["Home"]),
    ],
    dependencies: [
        .package(path: "../../Packages/DesignSystem"),
        .package(path: "../Groups")
    ],
    targets: [
        .target(
            name: "Home",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "Groups",       package: "Groups")
            ]
        ),
        .testTarget(
            name: "HomeTests",
            dependencies: ["Home"]
        ),
    ]
)
