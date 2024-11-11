// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HookahTobaccoUICore",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "HookahTobaccoResources",
            targets: ["HookahTobaccoResources"]),
        .library(
            name: "HookahTobaccoUIKitCore",
            targets: ["HookahTobaccoUIKitCore"]),
        .library(
            name: "HookahTobaccoSwiftUICore",
            targets: ["HookahTobaccoSwiftUICore"])
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "HookahTobaccoResources"),
        .target(
            name: "HookahTobaccoUIKitCore",
            dependencies: ["SnapKit", "HookahTobaccoResources"]),
        .target(
            name: "HookahTobaccoSwiftUICore",
            dependencies: ["HookahTobaccoResources"])
    ]
)
