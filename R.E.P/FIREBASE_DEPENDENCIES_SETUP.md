# Firebase Dependencies Setup Guide

## Problem
The error "No such module 'FirebaseFirestoreSwift'" occurs because Firebase dependencies are not properly added to the Xcode project.

## Solution: Add Firebase Dependencies via Xcode Package Manager

### Step 1: Add Firebase iOS SDK Package
1. Open your Xcode project
2. Go to **File** → **Add Package Dependencies...**
3. In the search bar, paste: `https://github.com/firebase/firebase-ios-sdk.git`
4. Click **Add Package**
5. Select the following products:
   - ✅ **FirebaseAuth**
   - ✅ **FirebaseFirestore** (includes FirebaseFirestoreSwift)
   - ✅ **FirebaseAnalytics** (optional)
   - ✅ **FirebaseStorage** (optional)

### Step 2: Verify Dependencies
1. In Xcode, go to your project navigator
2. Select your project (R.E.P)
3. Go to **Targets** → **R.E.P** → **General** tab
4. Scroll down to **Frameworks, Libraries, and Embedded Content**
5. You should see the Firebase packages listed

### Step 3: Clean and Build
1. **Product** → **Clean Build Folder** (Cmd+Shift+K)
2. **Product** → **Build** (Cmd+B)

## Alternative: Manual Package.swift (if needed)

If you prefer to use a Package.swift file, create it in the project root:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "R.E.P",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "R.E.P", targets: ["R.E.P"])
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0")
    ],
    targets: [
        .target(
            name: "R.E.P",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk")
            ]
        )
    ]
)
```

## Troubleshooting

### If dependencies still don't work:
1. **Close Xcode completely**
2. **Delete derived data**: 
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. **Reopen Xcode**
4. **Clean and build again**

### If you see "Package not found":
1. Make sure you're using the correct URL: `https://github.com/firebase/firebase-ios-sdk.git`
2. Check your internet connection
3. Try restarting Xcode

### If you see "Module not found" after adding dependencies:
1. Make sure you selected all required Firebase products
2. Clean build folder and rebuild
3. Check that the Firebase packages appear in your project's dependencies

## Required Firebase Products for R.E.P

- **FirebaseAuth**: User authentication
- **FirebaseFirestore**: Database operations (includes FirebaseFirestoreSwift for Codable support)
- **FirebaseAnalytics**: App analytics (optional)
- **FirebaseStorage**: File storage (optional)

## Verification

After adding dependencies, you should be able to import these modules:

```swift
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
```

And use Firestore features like:

```swift
// This should work after adding FirebaseFirestoreSwift
try await db.collection("users").document(userId).setData(from: user)
``` 