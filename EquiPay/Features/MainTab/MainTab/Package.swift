// swift-tools-version: 6.1
// The Swift Programming Language
// https://docs.swift.org/swift-book

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
        .package(path: "../Groups"),
        .package(path: "../CreateGroup"),
        .package(path: "../Activity"),
        .package(path: "../Profile")
    ],
    targets: [
        .target(
            name: "MainTab",
            dependencies: [
                .product(name: "DesignSystem",  package: "DesignSystem"),
                .product(name: "Home",          package: "Home"),
                .product(name: "Groups",        package: "Groups"),
                .product(name: "CreateGroup",   package: "CreateGroup"),
                .product(name: "Activity",      package: "Activity"),
                .product(name: "Profile",       package: "Profile")
            ]
        ),
        .testTarget(
            name: "MainTabTests",
            dependencies: ["MainTab"]
        ),
    ]
)
