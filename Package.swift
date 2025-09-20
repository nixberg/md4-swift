// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "md4-swift",
    products: [
        .library(
            name: "MD4",
            targets: ["MD4"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/nixberg/blobby-swift.git",
            .upToNextMinor(from: "0.2.0")),
        .package(
            url: "https://github.com/nixberg/crypto-swift.git",
            branch: "main"),
    ],
    targets: [
        .target(
            name: "MD4",
            dependencies: [
                .product(name: "CryptoExtras", package: "crypto-swift"),
                .product(name: "CryptoProtocols", package: "crypto-swift"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("Lifetimes"),
                .strictMemorySafety(),
            ]),
        .testTarget(
            name: "MD4Tests",
            dependencies: [
                .product(name: "Blobby", package: "blobby-swift"),
                "MD4",
            ],
            resources: [
                .embedInCode("md4.blb")
            ]),
    ]
)
