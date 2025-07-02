//
//  R_E_PApp.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//

import SwiftUI
import SwiftData
import Firebase

//@main
//struct R_E_PApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//        .modelContainer(sharedModelContainer)
//    }
//}

import SwiftUI
import Firebase

@main
struct REPApp: App {
    init() {
        // Configure Firebase with error handling
        do {
            FirebaseApp.configure()
        } catch {
            print("Firebase configuration failed: \(error)")
            // Continue without Firebase for now
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
