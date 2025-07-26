# Firestore Integration Setup Guide

## Overview
This guide explains how to set up Firestore integration for the R.E.P fitness app.

## Prerequisites
1. Firebase project created
2. iOS app registered in Firebase console
3. `GoogleService-Info.plist` added to the project

## Firestore Collections Structure

### 1. Users Collection
```
users/{userId}
├── uid: string
├── name: string
├── email: string
├── gender: string ("male" | "female")
├── age: number
├── height: number
├── weight: number
├── fitnessGoal: string
├── registrationDate: timestamp
├── currentRoutineId: string (optional)
├── goals: array
└── schemaVersion: number
```

### 2. Exercise Plans Collection
```
exercisePlans/{planId}
├── documentId: string
├── createdBy: string
├── description: string
├── exercises: array
└── schemaVersion: number
```

### 3. Meal Plans Collection
```
mealPlans/{planId}
├── documentId: string
├── createdBy: string
├── description: string
├── meals: array
└── schemaVersion: number
```

### 4. Foods Collection
```
foods/{foodId}
├── documentId: string
├── name: string
├── category: string
├── defaultQuantity: number
├── defaultUnit: string
├── nutrition: object
└── schemaVersion: number
```

### 5. Routines Collection
```
routines/{routineId}
├── documentId: string
├── goalId: string (optional)
├── name: string
├── description: string
├── startDate: timestamp
├── createdAt: timestamp
├── isActive: boolean
├── dailySchedule: array
├── settings: object (optional)
├── progress: object (optional)
├── customizations: object (optional)
└── schemaVersion: number
```

**Daily Schedule Structure:**
```
dailySchedule: [
  {
    "activityId": string,
    "name": string,
    "startTime": string,
    "endTime": string,
    "activityType": string,
    "referenceId": string (optional),
    "description": string (optional),
    "isRequired": boolean,
    "order": number
  }
]
```

### 6. Activity Logs Collection
```
activityLogs/{logId}
├── documentId: string
├── userId: string
├── activityType: string
├── timestamp: timestamp
├── duration: number (optional)
├── workoutLog: object (optional)
├── mealLog: object (optional)
├── customActivityLog: object (optional)
├── deviceDataLog: object (optional)
└── schemaVersion: number
```

## Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Users can read public exercise plans
    match /exercisePlans/{planId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == resource.data.createdBy;
    }
    
    // Users can read public meal plans
    match /mealPlans/{planId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == resource.data.createdBy;
    }
    
    // Users can read foods
    match /foods/{foodId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    // Users can only access their own routines
    match /routines/{routineId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
    
    // Users can only access their own activity logs
    match /activityLogs/{logId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
```

## Required Indexes

Create the following composite indexes in Firestore:

1. **activityLogs collection:**
   - Fields: `userId` (Ascending), `timestamp` (Descending)
   - Fields: `userId` (Ascending), `activityType` (Ascending), `timestamp` (Descending)

2. **routines collection:**
   - Fields: `userId` (Ascending), `isActive` (Ascending)

3. **foods collection:**
   - Fields: `name` (Ascending)
   - Fields: `category` (Ascending), `name` (Ascending)

## Testing the Integration

### 1. Test User Registration
```swift
// In your registration view
let registrationData = RegistrationData()
registrationData.name = "John Doe"
registrationData.age = 25
registrationData.height = 175.0
registrationData.weight = 70.0
registrationData.fitnessGoal = "weight_loss"

do {
    try await UserDataService.shared.registerUser(
        email: "john@example.com",
        password: "password123",
        registrationData: registrationData
    )
    print("User registered successfully!")
} catch {
    print("Registration failed: \(error)")
}
```

### 2. Test User Sign In
```swift
do {
    try await UserDataService.shared.signIn(
        email: "john@example.com",
        password: "password123"
    )
    print("User signed in successfully!")
} catch {
    print("Sign in failed: \(error)")
}
```

### 3. Test User Data Retrieval
```swift
await UserDataService.shared.loadCurrentUser()
if let user = UserDataService.shared.currentUser {
    print("Current user: \(user.name)")
}
```

## Common Issues and Solutions

### 1. Firebase Not Configured
**Error:** "Firebase is not configured"
**Solution:** Ensure `GoogleService-Info.plist` is added to the project and Firebase is initialized in `App.swift`

### 2. Firestore Permission Denied
**Error:** "Missing or insufficient permissions"
**Solution:** Check Firestore security rules and ensure they match the structure above

### 3. Index Not Found
**Error:** "The query requires an index"
**Solution:** Create the required composite indexes in Firestore console

### 4. Schema Version Mismatch
**Error:** "Failed to decode data"
**Solution:** Ensure all models have the correct `schemaVersion` field

## Next Steps

1. **Test the registration flow** with the updated `RegistrationView`
2. **Add error handling** for network issues
3. **Implement offline support** using Firestore's offline persistence
4. **Add data validation** before saving to Firestore
5. **Implement data migration** for future schema changes

## Files Modified

- `FirebaseAuthManager.swift` - Updated to create user in Firestore during registration
- `AuthViewModel.swift` - Updated to pass registration data
- `RegistrationView.swift` - Updated to use RegistrationData
- `FirestoreService.swift` - Created comprehensive Firestore service
- `UserDataService.swift` - Created user data management service
- `User.swift` - Added schema versioning
- `ExercisePlan.swift` - Added schema versioning
- `MealPlan.swift` - Added schema versioning
- `Food.swift` - Added schema versioning
- `ActivityLog.swift` - Created comprehensive activity logging
- `Routine.swift` - Added schema versioning 