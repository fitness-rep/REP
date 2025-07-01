//
//  SubscriptionView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//

import SwiftUI

struct SubscriptionView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Subscription Plans")
                    .font(.title)
                // List plans, add payment button
            }
            .navigationTitle("Subscription")
        }
    }
}
