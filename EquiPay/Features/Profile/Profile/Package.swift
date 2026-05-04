// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Profile",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Profile",
            targets: ["Profile"]),
    ],
    dependencies: [
        .package(path: "../../Packages/DesignSystem")
    ],
    targets: [
        .target(
            name: "Profile",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem")
            ]
        ),
        .testTarget(
            name: "ProfileTests",
            dependencies: ["Profile"]
        ),
    ]
)
