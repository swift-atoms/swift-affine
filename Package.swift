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

        // MARK: - Sub-namespace targets
        .library(
            name: "Affine Discrete Primitives",
            targets: ["Affine Discrete Primitives"]
        ),
        .library(
            name: "Affine Arithmetic Primitives",
            targets: ["Affine Arithmetic Primitives"]
        ),
        .library(
            name: "Affine Composition Primitives",
            targets: ["Affine Composition Primitives"]
        ),
        .library(
            name: "Affine Quotient Primitives",
            targets: ["Affine Quotient Primitives"]
        ),
        .library(
            name: "Affine Carrier Primitives",
            targets: ["Affine Carrier Primitives"]
        ),
        .library(
            name: "Affine Equation Primitives",
            targets: ["Affine Equation Primitives"]
        ),
        .library(
            name: "Affine Hash Primitives",
            targets: ["Affine Hash Primitives"]
        ),
        .library(
            name: "Affine Comparison Primitives",
            targets: ["Affine Comparison Primitives"]
        ),
        .library(
            name: "Affine Ordinal Primitives",
            targets: ["Affine Ordinal Primitives"]
        ),
        .library(
            name: "Affine Tagged Primitives",
            targets: ["Affine Tagged Primitives"]
        ),

        // MARK: - StdLib Integration
        .library(
            name: "Affine Primitives Standard Library Integration",
            targets: ["Affine Primitives Standard Library Integration"]
        ),

        // MARK: - Umbrella
        .library(
            name: "Affine Primitives",
            targets: ["Affine Primitives"]
        ),

        // MARK: - Test Support
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
        .package(url: "https://github.com/swift-primitives/swift-tagged-primitives.git", branch: "main"),
    ],
    targets: [

        // MARK: - Namespace
        .target(
            name: "Affine Namespace",
            dependencies: []
        ),

        // MARK: - Sub-namespace targets (per [MOD-031])
        .target(
            name: "Affine Discrete Primitives",
            dependencies: [
                "Affine Namespace",
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
            ]
        ),
        .target(
            name: "Affine Arithmetic Primitives",
            dependencies: [
                "Affine Namespace",
                "Affine Discrete Primitives",
                "Affine Carrier Primitives",
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Carrier Primitives", package: "swift-carrier-primitives"),
                .product(name: "Ordinal Primitives", package: "swift-ordinal-primitives"),
            ]
        ),
        .target(
            name: "Affine Composition Primitives",
            dependencies: [
                "Affine Namespace",
                "Affine Discrete Primitives",
            ]
        ),
        .target(
            name: "Affine Quotient Primitives",
            dependencies: [
                "Affine Namespace",
                "Affine Discrete Primitives",
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Ordinal Primitives", package: "swift-ordinal-primitives"),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
            ]
        ),
        .target(
            name: "Affine Carrier Primitives",
            dependencies: [
                "Affine Namespace",
                "Affine Discrete Primitives",
                .product(name: "Carrier Primitives", package: "swift-carrier-primitives"),
            ]
        ),
        .target(
            name: "Affine Equation Primitives",
            dependencies: [
                "Affine Namespace",
                "Affine Discrete Primitives",
                .product(name: "Equation Primitives", package: "swift-equation-primitives"),
            ]
        ),
        .target(
            name: "Affine Hash Primitives",
            dependencies: [
                "Affine Namespace",
                "Affine Discrete Primitives",
                .product(name: "Hash Primitives", package: "swift-hash-primitives"),
            ]
        ),
        .target(
            name: "Affine Comparison Primitives",
            dependencies: [
                "Affine Namespace",
                "Affine Discrete Primitives",
                .product(name: "Comparison Primitives", package: "swift-comparison-primitives"),
            ]
        ),
        .target(
            name: "Affine Ordinal Primitives",
            dependencies: [
                "Affine Namespace",
                "Affine Discrete Primitives",
                .product(name: "Ordinal Primitives", package: "swift-ordinal-primitives"),
            ]
        ),
        .target(
            name: "Affine Tagged Primitives",
            dependencies: [
                "Affine Namespace",
                "Affine Discrete Primitives",
                "Affine Arithmetic Primitives",
                "Affine Carrier Primitives",
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Carrier Primitives", package: "swift-carrier-primitives"),
                .product(name: "Ordinal Primitives", package: "swift-ordinal-primitives"),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
            ]
        ),

        // MARK: - StdLib Integration
        .target(
            name: "Affine Primitives Standard Library Integration",
            dependencies: [
                "Affine Namespace",
                "Affine Discrete Primitives",
                "Affine Carrier Primitives",
                "Affine Tagged Primitives",
                .product(name: "Carrier Primitives", package: "swift-carrier-primitives"),
                .product(name: "Ordinal Primitives", package: "swift-ordinal-primitives"),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Tagged Primitives Standard Library Integration", package: "swift-tagged-primitives"),
            ]
        ),

        // MARK: - Umbrella
        .target(
            name: "Affine Primitives",
            dependencies: [
                "Affine Namespace",
                "Affine Discrete Primitives",
                "Affine Arithmetic Primitives",
                "Affine Composition Primitives",
                "Affine Quotient Primitives",
                "Affine Carrier Primitives",
                "Affine Equation Primitives",
                "Affine Hash Primitives",
                "Affine Comparison Primitives",
                "Affine Ordinal Primitives",
                "Affine Tagged Primitives",
                "Affine Primitives Standard Library Integration",
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
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
