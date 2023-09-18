// swift-tools-version:5.7
// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "md4-swift",
    products: [
        .library(
            name: "MD4",
            targets: ["MD4"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nixberg/blobby-swift", branch: "main"),
    ],
    targets: [
        .target(
            name: "MD4"),
        .testTarget(
            name: "MD4Tests",
            dependencies: [
                .product(name: "Blobby", package: "blobby-swift"),
                "MD4",
            ],
            resources: [
                .copy("md4.blb"),
            ]),
    ]
)
