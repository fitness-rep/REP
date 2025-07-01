//
//  InsightsView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//

import SwiftUI

struct InsightsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Your Insights")
                    .font(.title)
                // Add charts, progress, etc.
            }
            .navigationTitle("Insights")
        }
    }
}
