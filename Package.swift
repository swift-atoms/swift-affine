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
            name: "Affine Primitives Test Support",
            targets: ["Affine Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-equation-primitives"),
        .package(path: "../swift-comparison-primitives"),
        .package(path: "../swift-identity-primitives"),
    ],
    targets: [
        .target(
            name: "Affine Primitives",
            dependencies: [
                .product(name: "Equation Primitives", package: "swift-equation-primitives"),
                .product(name: "Comparison Primitives", package: "swift-comparison-primitives"),
            ]
        ),
        .target(
            name: "Affine Primitives Test Support",
            dependencies: [
                "Affine Primitives",
                .product(name: "Identity Primitives Test Support", package: "swift-identity-primitives"),
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
    let settings: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableExperimentalFeature("Lifetimes"),
        .strictMemorySafety()
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + settings
}
