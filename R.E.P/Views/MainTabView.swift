//
//  MainTabView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            GenderSelectionView()
                .tabItem {
                    Label("Registration", systemImage: "person.circle")
                }
            SubscriptionView()
                .tabItem {
                    Label("Subscription", systemImage: "creditcard")
                }
            ScheduleCallView()
                .tabItem {
                    Label("Coach Call", systemImage: "phone")
                }
            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "waveform.path.ecg")
                }
        }
    }
}


