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
            name: "Affine Primitive",
            targets: ["Affine Primitive"]
        ),

        .library(
            name: "Affine Discrete",
            targets: ["Affine Discrete"]
        ),
        .library(
            name: "Affine Arithmetic",
            targets: ["Affine Arithmetic"]
        ),
        .library(
            name: "Affine Composition",
            targets: ["Affine Composition"]
        ),
        .library(
            name: "Affine Quotient",
            targets: ["Affine Quotient"]
        ),
        .library(
            name: "Affine Carrier",
            targets: ["Affine Carrier"]
        ),
        .library(
            name: "Affine Equation",
            targets: ["Affine Equation"]
        ),
        .library(
            name: "Affine Hash",
            targets: ["Affine Hash"]
        ),
        .library(
            name: "Affine Comparison",
            targets: ["Affine Comparison"]
        ),
        .library(
            name: "Affine Ordinal",
            targets: ["Affine Ordinal"]
        ),
        .library(
            name: "Affine Tagged",
            targets: ["Affine Tagged"]
        ),

        .library(
            name: "Affine Standard Library Integration",
            targets: ["Affine Standard Library Integration"]
        ),

        .library(
            name: "Affine",
            targets: ["Affine"]
        ),

        .library(
            name: "Affine Test Support",
            targets: ["Affine Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-ordinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-cardinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-carrier.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-equation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-hash.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-comparison.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-tagged.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Affine Primitive",
            dependencies: []
        ),

        .target(
            name: "Affine Discrete",
            dependencies: [
                "Affine Primitive",
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),
        .target(
            name: "Affine Arithmetic",
            dependencies: [
                "Affine Primitive",
                "Affine Discrete",
                "Affine Carrier",
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Carrier", package: "swift-carrier"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),
        .target(
            name: "Affine Composition",
            dependencies: [
                "Affine Primitive",
                "Affine Discrete",
            ]
        ),
        .target(
            name: "Affine Quotient",
            dependencies: [
                "Affine Primitive",
                "Affine Discrete",
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .target(
            name: "Affine Carrier",
            dependencies: [
                "Affine Primitive",
                "Affine Discrete",
                .product(name: "Carrier", package: "swift-carrier"),
            ]
        ),
        .target(
            name: "Affine Equation",
            dependencies: [
                "Affine Primitive",
                "Affine Discrete",
                .product(name: "Equation", package: "swift-equation"),
            ]
        ),
        .target(
            name: "Affine Hash",
            dependencies: [
                "Affine Primitive",
                "Affine Discrete",
                .product(name: "Hash", package: "swift-hash"),
            ]
        ),
        .target(
            name: "Affine Comparison",
            dependencies: [
                "Affine Primitive",
                "Affine Discrete",
                .product(name: "Comparison", package: "swift-comparison"),
            ]
        ),
        .target(
            name: "Affine Ordinal",
            dependencies: [
                "Affine Primitive",
                "Affine Discrete",
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),
        .target(
            name: "Affine Tagged",
            dependencies: [
                "Affine Primitive",
                "Affine Discrete",
                "Affine Arithmetic",
                "Affine Carrier",
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Carrier", package: "swift-carrier"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),

        .target(
            name: "Affine Standard Library Integration",
            dependencies: [
                "Affine Primitive",
                "Affine Discrete",
                "Affine Carrier",
                "Affine Tagged",
                .product(name: "Carrier", package: "swift-carrier"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(
                    name: "Tagged Standard Library Integration",
                    package: "swift-tagged"
                ),
            ]
        ),

        .target(
            name: "Affine",
            dependencies: [
                "Affine Primitive",
                "Affine Discrete",
                "Affine Arithmetic",
                "Affine Composition",
                "Affine Quotient",
                "Affine Carrier",
                "Affine Equation",
                "Affine Hash",
                "Affine Comparison",
                "Affine Ordinal",
                "Affine Tagged",
                "Affine Standard Library Integration",
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),

        .target(
            name: "Affine Test Support",
            dependencies: [
                "Affine",
                .product(
                    name: "Ordinal Test Support",
                    package: "swift-ordinal"
                ),
                .product(
                    name: "Cardinal Test Support",
                    package: "swift-cardinal"
                ),
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Affine Tests",
            dependencies: [
                "Affine",
                "Affine Test Support",
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
