// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Hope",
    products: [
        .library(name: "Hope", targets: ["Hope"]),
    ],
    targets: [
        .target(name: "Hope"),
    ]
)
