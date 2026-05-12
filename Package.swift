// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-affine-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        // MARK: - Namespace
        .library(
            name: "Affine Namespace",
            targets: ["Affine Namespace"]
        ),
        .library(
            name: "Affine Primitives",
            targets: ["Affine Primitives"]
        ),
        .library(
            name: "Affine Primitives Core",
            targets: ["Affine Primitives Core"]
        ),
        .library(
            name: "Affine Primitives Standard Library Integration",
            targets: ["Affine Primitives Standard Library Integration"]
        ),
        .library(
            name: "Affine Primitives Test Support",
            targets: ["Affine Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-ordinal-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-cardinal-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-carrier-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-equation-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-hash-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-comparison-primitives.git", branch: "main"),
    ],
    targets: [

        // MARK: - Namespace
        .target(
            name: "Affine Namespace",
            dependencies: []
        ),

        // MARK: - Core
        .target(
            name: "Affine Primitives Core",
            dependencies: [
                "Affine Namespace",
                .product(name: "Ordinal Primitives", package: "swift-ordinal-primitives"),
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Carrier Primitives", package: "swift-carrier-primitives"),
                .product(name: "Equation Primitives", package: "swift-equation-primitives"),
                .product(name: "Hash Primitives", package: "swift-hash-primitives"),
                .product(name: "Comparison Primitives", package: "swift-comparison-primitives"),
            ]
        ),

        // MARK: - StdLib Integration
        .target(
            name: "Affine Primitives Standard Library Integration",
            dependencies: [
                "Affine Primitives Core",
            ]
        ),

        // MARK: - Umbrella
        .target(
            name: "Affine Primitives",
            dependencies: [
                "Affine Namespace",
                "Affine Primitives Core",
                "Affine Primitives Standard Library Integration",
            ]
        ),

        // MARK: - Test Support
        .target(
            name: "Affine Primitives Test Support",
            dependencies: [
                "Affine Primitives",
                .product(name: "Ordinal Primitives Test Support", package: "swift-ordinal-primitives"),
                .product(name: "Cardinal Primitives Test Support", package: "swift-cardinal-primitives"),
            ],
            path: "Tests/Support"
        ),

        // MARK: - Tests
        .testTarget(
            name: "Affine Primitives Tests",
            dependencies: [
                "Affine Primitives",
                "Affine Primitives Test Support",
            ]
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
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    // Platforms whose Swift SDK can compile the `Synchronization` module.
    // Android is excluded because the swift-android-sdk artifact bundle's
    // `SwiftOverlayShims/LibcOverlayShims.h` includes `<semaphore.h>`, which
    // Bionic libc does not ship as a standalone header (upstream gap in the
    // community Android Swift SDK). Embedded targets lack Synchronization
    // entirely. Source files that import Synchronization should guard with
    // `#if SYNCHRONIZATION_AVAILABLE`.
    let package: [SwiftSetting] = [
        .define(
            "SYNCHRONIZATION_AVAILABLE",
            .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS, .linux, .windows])
        )
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
