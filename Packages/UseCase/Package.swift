// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UseCase",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "UseCase",
            targets: ["UseCase"]),
    ],
    dependencies: [
        .package(path: "../Repository"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "UseCase",
            dependencies: ["Repository"],
            path: "Sources"),
        .testTarget(
            name: "UseCaseTests",
            dependencies: ["UseCase"]),
    ]
)
