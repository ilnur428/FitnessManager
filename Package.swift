// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FitnessPackage",
    products: [
        .library(
            name: "FitnessManager",
            targets: ["FitnessManager"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FitnessManager",
            dependencies: [])
    ]
)
