// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "PermissionsKit",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "PermissionsKit",
            targets: ["PermissionsKit"]
        ),
    ],
    targets: [
        .target(
            name: "PermissionsKit",
            dependencies: []
        )
    ]
)
