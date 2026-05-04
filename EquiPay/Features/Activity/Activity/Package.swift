// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Activity",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Activity",
            targets: ["Activity"]),
    ],
    dependencies: [
        .package(path: "../../Packages/DesignSystem")
    ],
    targets: [
        .target(
            name: "Activity",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem")
            ]
        ),
        .testTarget(
            name: "ActivityTests",
            dependencies: ["Activity"]
        ),
    ]
)
