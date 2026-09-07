// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-affine",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [
        .library(name: "Affine", targets: ["Affine"]),
        .library(name: "Affine Test Support", targets: ["Affine Test Support"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-magnitude.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-polarity.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-rational.git", branch: "main"),
        .package(
            url: "https://github.com/swift-atoms/swift-addition.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-subtraction.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-cardinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-ordinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-difference.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-ratio.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-interval.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        ),
//        .package(
//            url: "https://github.com/swift-molecules/swift-difference-ratio.git",
//            branch: "main"
//        ),
//        .package(
//            url: "https://github.com/swift-molecules/swift-ordinal-ratio.git",
//            branch: "main"
//        ),
    ],
    targets: [
        .target(name: "Affine", dependencies: [
            .product(name: "Magnitude", package: "swift-magnitude"),
            .product(name: "Polarity", package: "swift-polarity"),
            .product(name: "Addition", package: "swift-addition"),
            .product(name: "Subtraction", package: "swift-subtraction"),
            .product(name: "Cardinal", package: "swift-cardinal"),
            .product(name: "Difference", package: "swift-difference"),
            .product(name: "Tagged", package: "swift-tagged"),
        ]),
        .target(name: "Affine Test Support", dependencies: [
            "Affine",
            .product(name: "Magnitude", package: "swift-magnitude"),
            .product(name: "Polarity", package: "swift-polarity"),
            .product(name: "Rational", package: "swift-rational"),
            .product(name: "Interval", package: "swift-interval"),
            .product(name: "Cardinal", package: "swift-cardinal"),
            .product(name: "Cardinal Standard Library Integration", package: "swift-cardinal"),
            .product(name: "Ordinal", package: "swift-ordinal"),
            .product(name: "Ordinal Standard Library Integration", package: "swift-ordinal"),
            .product(name: "Difference", package: "swift-difference"),
            .product(name: "Difference Standard Library Integration", package: "swift-difference"),
            .product(name: "Ratio", package: "swift-ratio"),
//            .product(name: "Difference Ratio", package: "swift-difference-ratio"),
//            .product(name: "Ordinal Ratio", package: "swift-ordinal-ratio"),
            .product(name: "Tagged", package: "swift-tagged"),
            .product(name: "Tagged Standard Library Integration", package: "swift-tagged"),
        ], path: "Tests/Support"),
        .testTarget(name: "Affine Tests", dependencies: ["Affine Test Support"]),
        .testTarget(name: "Arithmetic Integration Tests", dependencies: [
            "Affine",
            .product(name: "Interval", package: "swift-interval"),
            .product(name: "Difference Standard Library Integration", package: "swift-difference"),
            .product(name: "Cardinal", package: "swift-cardinal"),
            .product(name: "Ordinal", package: "swift-ordinal"),
        ]),
    ],
    swiftLanguageModes: [.v6]
)
for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .define("SYNCHRONIZATION_AVAILABLE", .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS, .linux, .windows])),
    ]
}
