// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "CreateGroup",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "CreateGroup",
            targets: ["CreateGroup"]),
    ],
    dependencies: [
        .package(path: "../../Packages/DesignSystem")
    ],
    targets: [
        .target(
            name: "CreateGroup",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem")
            ]
        ),
        .testTarget(
            name: "CreateGroupTests",
            dependencies: ["CreateGroup"]
        ),
    ]
)
