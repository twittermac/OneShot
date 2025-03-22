// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "OneShot",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "OneShot",
            targets: ["OneShot"]),
    ],
    dependencies: [
        .package(url: "https://github.com/AgoraIO/AgoraRtcKit_iOS.git", from: "4.2.2")
    ],
    targets: [
        .target(
            name: "OneShot",
            dependencies: [
                .product(name: "AgoraRtcKit", package: "AgoraRtcKit_iOS")
            ]),
        .testTarget(
            name: "OneShotTests",
            dependencies: ["OneShot"]),
    ]
) 