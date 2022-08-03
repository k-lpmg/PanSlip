// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PanSlip",
    products: [
        .library(
            name: "PanSlip",
            targets: ["PanSlip"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "PanSlip",
            dependencies: [])
    ]
)
