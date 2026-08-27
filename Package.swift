// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-affine",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Affine",
            targets: ["Affine"]
        ),
        .library(
            name: "Affine Standard Library Integration",
            targets: ["Affine Standard Library Integration"]
        ),
        .library(
            name: "Affine Apple Foundation Integration",
            targets: ["Affine Apple Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-ordinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-cardinal.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Affine",
            dependencies: [
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),
        .target(
            name: "Affine Standard Library Integration",
            dependencies: ["Affine"]
        ),
        .target(
            name: "Affine Apple Foundation Integration",
            dependencies: [
                "Affine",
                "Affine Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Affine Tests",
            dependencies: ["Affine"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = [
        .define(
            "SYNCHRONIZATION_AVAILABLE",
            .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS, .linux, .windows])
        )
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
