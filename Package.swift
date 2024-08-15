// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Numerix",
    platforms: [
        .macOS(.v14),
        .iOS(.v16)
    ],
    products: [
        .library(name: "Numerix", targets: ["Numerix"])
    ],
    targets: [
        .target(
            name: "Numerix",
            cxxSettings: [
                .define("ACCELERATE_NEW_LAPACK", to: "1"),
                .define("ACCELERATE_LAPACK_ILP64", to: "1")
            ],
            linkerSettings: [.linkedFramework("Accelerate")]
        ),
        .testTarget(name: "Tests", dependencies: ["Numerix"])
    ]
)
