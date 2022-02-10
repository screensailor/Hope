// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Hope",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Hope", targets: ["Hope"]),
    ],
    targets: [
        .target(name: "Hope"),
    ]
)
