// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "MainTab",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "MainTab",
            targets: ["MainTab"]),
    ],
    dependencies: [
        .package(path: "../../Packages/DesignSystem"),
        .package(path: "../Home"),
        .package(path: "../Groups")
    ],
    targets: [
        .target(
            name: "MainTab",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "Home", package: "Home"),
                .product(name: "Groups", package: "Groups")
            ]
        ),
        .testTarget(
            name: "MainTabTests",
            dependencies: ["MainTab"]
        ),
    ]
)
