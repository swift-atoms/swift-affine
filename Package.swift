// swift-tools-version: 6.2

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
        .library(
            name: "Affine Primitives",
            targets: ["Affine Primitives"]
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
        .package(path: "../swift-ordinal-primitives"),
        .package(path: "../swift-cardinal-primitives"),
        .package(path: "../swift-equation-primitives"),
        .package(path: "../swift-comparison-primitives"),
        .package(path: "../swift-property-primitives"),
    ],
    targets: [
        .target(
            name: "Affine Primitives Core",
            dependencies: [
                .product(name: "Ordinal Primitives", package: "swift-ordinal-primitives"),
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Equation Primitives", package: "swift-equation-primitives"),
                .product(name: "Comparison Primitives", package: "swift-comparison-primitives"),
                .product(name: "Property Primitives", package: "swift-property-primitives"),
            ]
        ),
        .target(
            name: "Affine Primitives Standard Library Integration",
            dependencies: [
                "Affine Primitives Core",
            ]
        ),
        .target(
            name: "Affine Primitives",
            dependencies: [
                "Affine Primitives Core",
                "Affine Primitives Standard Library Integration",
            ]
        ),
        .target(
            name: "Affine Primitives Test Support",
            dependencies: [
                "Affine Primitives",
                .product(name: "Ordinal Primitives Test Support", package: "swift-ordinal-primitives"),
                .product(name: "Cardinal Primitives Test Support", package: "swift-cardinal-primitives"),
            ],
            path: "Tests/Support"
        ),
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
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableExperimentalFeature("SuppressedAssociatedTypesWithDefaults"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
