// swift-tools-version: 5.9
import PackageDescription

// DO NOT MODIFY THIS FILE - managed by Capacitor CLI commands
let package = Package(
    name: "CapApp-SPM",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "CapApp-SPM",
            targets: ["CapApp-SPM"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", exact: "8.0.0"),
        .package(name: "CapacitorApp", path: "../../../../node_modules/.pnpm/@capacitor+app@8.0.0_@capacitor+core@8.0.0/node_modules/@capacitor/app"),
        .package(name: "CapacitorDevice", path: "../../../../node_modules/.pnpm/@capacitor+device@8.0.0_@capacitor+core@8.0.0/node_modules/@capacitor/device"),
        .package(name: "CapacitorFilesystem", path: "../../../../node_modules/.pnpm/@capacitor+filesystem@8.0.0_@capacitor+core@8.0.0/node_modules/@capacitor/filesystem"),
        .package(name: "CapacitorHaptics", path: "../../../../node_modules/.pnpm/@capacitor+haptics@8.0.0_@capacitor+core@8.0.0/node_modules/@capacitor/haptics"),
        .package(name: "CapacitorLocalNotifications", path: "../../../../node_modules/.pnpm/@capacitor+local-notifications@8.0.0_@capacitor+core@8.0.0/node_modules/@capacitor/local-notifications"),
        .package(name: "CapacitorPreferences", path: "../../../../node_modules/.pnpm/@capacitor+preferences@8.0.0_@capacitor+core@8.0.0/node_modules/@capacitor/preferences"),
        .package(name: "CapacitorPrivacyScreen", path: "../../../../node_modules/.pnpm/@capacitor+privacy-screen@2.0.0_@capacitor+core@8.0.0/node_modules/@capacitor/privacy-screen"),
        .package(name: "CapacitorScreenOrientation", path: "../../../../node_modules/.pnpm/@capacitor+screen-orientation@8.0.0_@capacitor+core@8.0.0/node_modules/@capacitor/screen-orientation"),
        .package(name: "CapacitorStatusBar", path: "../../../../node_modules/.pnpm/@capacitor+status-bar@8.0.0_@capacitor+core@8.0.0/node_modules/@capacitor/status-bar"),
        .package(name: "CapgoCapacitorHealth", path: "../../../../node_modules/.pnpm/@capgo+capacitor-health@8.2.5_@capacitor+core@8.0.0/node_modules/@capgo/capacitor-health"),
        .package(name: "CapgoCapacitorNativeBiometric", path: "../../../../node_modules/.pnpm/@capgo+capacitor-native-biometric@8.0.3_@capacitor+core@8.0.0/node_modules/@capgo/capacitor-native-biometric"),
        .package(name: "CapgoCapacitorShake", path: "../../../../node_modules/.pnpm/@capgo+capacitor-shake@8.0.11_@capacitor+core@8.0.0/node_modules/@capgo/capacitor-shake"),
        .package(name: "CapacitorSecureStoragePlugin", path: "../../../../node_modules/.pnpm/capacitor-secure-storage-plugin@0.12.0_@capacitor+core@8.0.0/node_modules/capacitor-secure-storage-plugin")
    ],
    targets: [
        .target(
            name: "CapApp-SPM",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "CapacitorApp", package: "CapacitorApp"),
                .product(name: "CapacitorDevice", package: "CapacitorDevice"),
                .product(name: "CapacitorFilesystem", package: "CapacitorFilesystem"),
                .product(name: "CapacitorHaptics", package: "CapacitorHaptics"),
                .product(name: "CapacitorLocalNotifications", package: "CapacitorLocalNotifications"),
                .product(name: "CapacitorPreferences", package: "CapacitorPreferences"),
                .product(name: "CapacitorPrivacyScreen", package: "CapacitorPrivacyScreen"),
                .product(name: "CapacitorScreenOrientation", package: "CapacitorScreenOrientation"),
                .product(name: "CapacitorStatusBar", package: "CapacitorStatusBar"),
                .product(name: "CapgoCapacitorHealth", package: "CapgoCapacitorHealth"),
                .product(name: "CapgoCapacitorNativeBiometric", package: "CapgoCapacitorNativeBiometric"),
                .product(name: "CapgoCapacitorShake", package: "CapgoCapacitorShake"),
                .product(name: "CapacitorSecureStoragePlugin", package: "CapacitorSecureStoragePlugin")
            ]
        )
    ]
)
