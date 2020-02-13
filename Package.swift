// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "MD4",
    products: [
        .library(
            name: "MD4",
            targets: ["MD4"]),
    ],
    targets: [
        .target(
            name: "MD4"),
        .testTarget(
            name: "MD4Tests",
            dependencies: ["MD4"]),
    ]
)
