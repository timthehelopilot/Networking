// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "Networking",
                      platforms: [.macOS(.v11), .iOS(.v14), .watchOS(.v7), .tvOS(.v14)],
                      products: [
                        .library(name: "Networking",
                                 targets: ["Networking"])
                      ],
                      targets: [
                        .target(name: "Networking",
                                dependencies: []),
                        .testTarget(name: "NetworkingTests",
                                    dependencies: ["Networking"])
                      ]
)
