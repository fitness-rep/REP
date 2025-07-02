//
//  Untitled.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 6/30/25.
//

import SwiftUI
import AVKit

struct HomeView: View {
    @State private var showSignIn = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 50) {
                    Text("Welcome to R.E.P!")
                        .font(.largeTitle)
                        .bold()
                    VideoPlayer(player: AVPlayer(url:  URL(string: "https://www.example.com/yourvideo.mp4")!))
                        .frame(height: 400)

                    NavigationLink("Get Started with R.E.P", destination: GenderSelectionView().environmentObject(RegistrationData()))
                    
                    Button("Already have an account? Sign In") {
                        showSignIn = true
                    }
                    .foregroundColor(.blue)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showSignIn) {
            SignInView()
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Item.self, inMemory: true)
}
