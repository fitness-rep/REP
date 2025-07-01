//
//  ScheduleCallView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//

import SwiftUI

struct ScheduleCallView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Schedule a Call with Your Coach")
                    .font(.title)
                // Integrate calendar or booking API
            }
            .navigationTitle("Coach Call")
        }
    }
}
