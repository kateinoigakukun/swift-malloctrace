// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "MallocTrace",
    products: [
        .library(name: "MallocTrace", targets: ["MallocTrace"]),
    ],
    targets: [
        .target(name: "MallocTrace", dependencies: ["_CMallocTrace"]),
        .target(name: "_CMallocTrace", exclude: ["dlmalloc.c"]),
        .testTarget(
            name: "MallocTraceTests",
            dependencies: ["MallocTrace"]),
    ]
)
