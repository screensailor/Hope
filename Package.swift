// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Hope",
    platforms: [
        .macOS(.v11),
        .iOS(.v13)
    ],
    products: [
        .library(name: "Hope", targets: ["Hope"]),
    ],
    targets: [
        .target(name: "Hope"),
    ]
)
