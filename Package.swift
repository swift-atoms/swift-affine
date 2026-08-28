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
            url: "https://github.com/swift-atoms/swift-ordinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-cardinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-carrier.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-equation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-hash.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-comparison.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Affine",
            dependencies: []
        ),

        .target(
            name: "Affine Discrete",
            dependencies: [
                .target(name: "Affine"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),
        .target(
            name: "Affine Arithmetic",
            dependencies: [
                .target(name: "Affine"),
                .target(name: "Affine Discrete"),
                .target(name: "Affine Carrier"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Carrier", package: "swift-carrier"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),
        .target(
            name: "Affine Composition",
            dependencies: [
                .target(name: "Affine"),
                .target(name: "Affine Discrete"),
            ]
        ),
        .target(
            name: "Affine Quotient",
            dependencies: [
                .target(name: "Affine"),
                .target(name: "Affine Discrete"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .target(
            name: "Affine Carrier",
            dependencies: [
                .target(name: "Affine"),
                .target(name: "Affine Discrete"),
                .product(name: "Carrier", package: "swift-carrier"),
            ]
        ),
        .target(
            name: "Affine Equation",
            dependencies: [
                .target(name: "Affine"),
                .target(name: "Affine Discrete"),
                .product(name: "Equation", package: "swift-equation"),
            ]
        ),
        .target(
            name: "Affine Hash",
            dependencies: [
                .target(name: "Affine"),
                .target(name: "Affine Discrete"),
                .product(name: "Hash", package: "swift-hash"),
            ]
        ),
        .target(
            name: "Affine Comparison",
            dependencies: [
                .target(name: "Affine"),
                .target(name: "Affine Discrete"),
                .product(name: "Comparison", package: "swift-comparison"),
            ]
        ),
        .target(
            name: "Affine Ordinal",
            dependencies: [
                .target(name: "Affine"),
                .target(name: "Affine Discrete"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),
        .target(
            name: "Affine Tagged",
            dependencies: [
                .target(name: "Affine"),
                .target(name: "Affine Discrete"),
                .target(name: "Affine Arithmetic"),
                .target(name: "Affine Carrier"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Carrier", package: "swift-carrier"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),

        .target(
            name: "Affine Standard Library Integration",
            dependencies: [
                .target(name: "Affine"),
                .target(name: "Affine Discrete"),
                .target(name: "Affine Carrier"),
                .target(name: "Affine Tagged"),
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
            name: "Affine Test Support",
            dependencies: [
                .target(name: "Affine"),
                .product(
                    name: "Ordinal Test Support",
                    package: "swift-ordinal"
                ),
                .product(
                    name: "Cardinal Standard Library Integration",
                    package: "swift-cardinal"
                ),
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Affine Tests",
            dependencies: [
                .target(name: "Affine"),
                .target(name: "Affine Test Support"),
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
