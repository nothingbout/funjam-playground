// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "funjam-playground",
    platforms: [.macOS(.v15)],
    products: [],
    dependencies: [
        .package(url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.37.0"),
        .package(url: "https://github.com/GoodNotes/swift-icudata-slim.git", from: "0.2.0"),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
                .product(name: "ICUDataSlim_Minimal", package: "swift-icudata-slim"),
            ]
        ),
    ]
)
