// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Groups",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Groups",
            targets: ["Groups"]),
    ],
    dependencies: [
        .package(path: "../../Packages/DesignSystem")
    ],
    targets: [
        .target(
            name: "Groups",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem")
            ]
        ),
        .testTarget(
            name: "GroupsTests",
            dependencies: ["Groups"]
        ),
    ]
)
