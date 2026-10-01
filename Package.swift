// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-affine",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [
        .library(name: "Affine", targets: ["Affine"]),
    ],
    traits: [
        .trait(name: "Tagged", description: "Tagged point representations"),
        .trait(name: "Vector", description: "Componentwise vector representations"),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-vector.git", branch: "main"),
    ],
    targets: [
        .target(name: "Affine", dependencies: [
            .product(name: "Tagged", package: "swift-tagged"),
            .product(name: "Vector", package: "swift-vector"),
        ]),
        .testTarget(name: "Affine Tests", dependencies: ["Affine"]),
        .testTarget(name: "Affine Representations Tests", dependencies: [
            .target(name: "Affine"),
            .product(name: "Tagged", package: "swift-tagged"),
            .product(name: "Vector", package: "swift-vector"),
        ]),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("Lifetimes"),
        .treatAllWarnings(as: .error),
    ]
}
