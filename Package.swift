// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Toot",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Toot",
            targets: ["TootiPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "TootiPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/TootiPlugin"),
        .testTarget(
            name: "TootiPluginTests",
            dependencies: ["TootiPlugin"],
            path: "ios/Tests/TootiPluginTests")
    ]
)