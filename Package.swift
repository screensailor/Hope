// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Hope",
    products: [
        .library(name: "Hope", targets: ["Hope"]),
    ],
    dependencies: [
        .package(url: "https://github.com/screensailor/Peek.git", .branch("master")),
    ],
    targets: [
        .target(name: "Hope", dependencies: ["Peek"]),
    ]
)
