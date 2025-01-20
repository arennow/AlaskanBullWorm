// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "AlaskanBullWorm",
					  platforms: [
					  	.macOS(.v13),
					  ],
					  products: [
					  	// Products define the executables and libraries a package produces, making them visible to other packages.
					  	.library(name: "AlaskanBullWorm",
								   targets: ["AlaskanBullWorm"]),
					  ],
					  dependencies: [
					  	.package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.2.0")),
					  ],
					  targets: [
					  	// Targets are the basic building blocks of a package, defining a module or a test suite.
					  	// Targets can depend on other targets in this package and products from dependencies.
					  	.target(name: "AlaskanBullWorm",
								  dependencies: [
								  	.product(name: "Algorithms", package: "swift-algorithms"),
								  ],
								  swiftSettings: [
								  	.enableUpcomingFeature("ExistentialAny"),
								  ]),
					  	.testTarget(name: "AlaskanBullWormTests",
									  dependencies: ["AlaskanBullWorm"],
									  swiftSettings: [
									  	.enableUpcomingFeature("ExistentialAny"),
									  ]),
					  ])
