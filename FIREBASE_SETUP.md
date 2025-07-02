# Firebase Setup Guide for R.E.P

This guide will help you set up Firebase Authentication and other cloud services for your R.E.P app.

## Prerequisites

- Xcode 15.0 or later
- iOS 16.0 or later
- Firebase account
- Apple Developer account (for Face ID)

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: `R.E.P`
4. Choose whether to enable Google Analytics (recommended)
5. Click "Create project"

## Step 2: Add iOS App to Firebase

1. In Firebase Console, click the iOS icon (+ Add app)
2. Enter your iOS bundle ID (e.g., `com.yourcompany.R.E.P`)
3. Enter app nickname: `R.E.P`
4. Click "Register app"

## Step 3: Download Configuration File

1. Download the `GoogleService-Info.plist` file
2. Replace the placeholder file in your Xcode project:
   - Drag the downloaded `GoogleService-Info.plist` into your Xcode project
   - Make sure it's added to your main target
   - Replace the existing placeholder file

## Step 4: Enable Authentication Methods

1. In Firebase Console, go to "Authentication" → "Sign-in method"
2. Enable the following providers:
   - **Email/Password**: Enable and configure
   - **Google Sign-In**: Optional, for additional sign-in options

## Step 5: Configure Firestore Database

1. Go to "Firestore Database" in Firebase Console
2. Click "Create database"
3. Choose "Start in test mode" for development
4. Select a location close to your users
5. Click "Done"

## Step 6: Set Up Security Rules

In Firestore Database → Rules, add these security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Public data (if any)
    match /public/{document=**} {
      allow read: if true;
    }
  }
}
```

## Step 7: Configure Xcode Project

### Add Firebase Dependencies

1. In Xcode, go to your project settings
2. Select your target
3. Go to "Package Dependencies" tab
4. Click "+" to add package
5. Enter: `https://github.com/firebase/firebase-ios-sdk.git`
6. Select the following products:
   - FirebaseAuth
   - FirebaseFirestore
   - FirebaseStorage
   - FirebaseAnalytics

### Update Bundle Identifier

1. In Xcode, select your project
2. Select your target
3. Go to "General" tab
4. Update "Bundle Identifier" to match Firebase configuration

## Step 8: Configure Face ID

### Add Face ID Usage Description

1. In Xcode, select your project
2. Select your target
3. Go to "Info" tab
4. Add a new key: `Privacy - Face ID Usage Description`
5. Set value: `R.E.P uses Face ID to provide secure and convenient sign-in to your account.`

### Enable Face ID Capability

1. In Xcode, select your project
2. Select your target
3. Go to "Signing & Capabilities"
4. Click "+" and add "Face ID"

## Step 9: Test the Integration

1. Build and run your app
2. Try signing up with a new account
3. Test Face ID authentication
4. Verify data is saved to Firestore

## Step 10: Production Setup

### Update Security Rules

Before going to production, update Firestore rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Add more specific rules as needed
    match /workouts/{workoutId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
  }
}
```

### Enable App Check (Optional)

1. In Firebase Console, go to "App Check"
2. Enable App Check for your app
3. Add App Check configuration to your app

## Troubleshooting

### Common Issues

1. **Build Errors**: Make sure all Firebase dependencies are properly added
2. **Authentication Fails**: Check your `GoogleService-Info.plist` is correct
3. **Face ID Not Working**: Verify Face ID capability is enabled
4. **Firestore Access Denied**: Check your security rules

### Debug Tips

1. Enable Firebase Analytics for debugging
2. Check Firebase Console logs
3. Use Firebase CLI for local testing
4. Verify network connectivity

## Next Steps

- Set up Firebase Storage for file uploads
- Configure Firebase Analytics for user insights
- Add push notifications with Firebase Cloud Messaging
- Implement offline data synchronization

## Support

- [Firebase Documentation](https://firebase.google.com/docs)
- [Firebase iOS SDK](https://firebase.google.com/docs/ios/setup)
- [Firebase Community](https://firebase.google.com/community) 