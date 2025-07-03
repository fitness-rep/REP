import SwiftUI

struct HomeDashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome back!")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("Ready for your next workout?")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Quick Stats
                        VStack(spacing: 16) {
                            Text("Today's Overview")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 16) {
                                StatCard(
                                    title: "Calories",
                                    value: "2,100",
                                    subtitle: "Target",
                                    color: .blue,
                                    icon: "flame.fill"
                                )
                                
                                StatCard(
                                    title: "Protein",
                                    value: "140g",
                                    subtitle: "Consumed",
                                    color: .green,
                                    icon: "dumbbell.fill"
                                )
                            }
                            
                            HStack(spacing: 16) {
                                StatCard(
                                    title: "Workouts",
                                    value: "3",
                                    subtitle: "This Week",
                                    color: .orange,
                                    icon: "figure.strengthtraining.traditional"
                                )
                                
                                StatCard(
                                    title: "Steps",
                                    value: "8,432",
                                    subtitle: "Today",
                                    color: .purple,
                                    icon: "figure.walk"
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Recent Activity
                        VStack(spacing: 16) {
                            Text("Recent Activity")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 12) {
                                ActivityCard(
                                    title: "Upper Body Workout",
                                    subtitle: "Completed 2 hours ago",
                                    icon: "figure.strengthtraining.traditional",
                                    color: .blue
                                )
                                
                                ActivityCard(
                                    title: "Protein Shake",
                                    subtitle: "Logged 1 hour ago",
                                    icon: "cup.and.saucer.fill",
                                    color: .green
                                )
                                
                                ActivityCard(
                                    title: "Cardio Session",
                                    subtitle: "Completed yesterday",
                                    icon: "heart.fill",
                                    color: .red
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Quick Actions
                        VStack(spacing: 16) {
                            Text("Quick Actions")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 16) {
                                QuickActionButton(
                                    title: "Start Workout",
                                    icon: "play.fill",
                                    color: .blue
                                ) {
                                    // Action for start workout
                                }
                                
                                QuickActionButton(
                                    title: "Log Meal",
                                    icon: "plus.circle.fill",
                                    color: .green
                                ) {
                                    // Action for log meal
                                }
                            }
                            
                            HStack(spacing: 16) {
                                QuickActionButton(
                                    title: "View Progress",
                                    icon: "chart.line.uptrend.xyaxis",
                                    color: .orange
                                ) {
                                    // Action for view progress
                                }
                                
                                QuickActionButton(
                                    title: "Schedule",
                                    icon: "calendar",
                                    color: .purple
                                ) {
                                    // Action for schedule
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            
            // Workouts Tab
            VStack {
                Text("Workouts")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Your workout plans and routines will appear here")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .tabItem {
                Image(systemName: "dumbbell.fill")
                Text("Workouts")
            }
            .tag(1)
            
            // Nutrition Tab
            VStack {
                Text("Nutrition")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Track your meals and nutrition here")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .tabItem {
                Image(systemName: "fork.knife")
                Text("Nutrition")
            }
            .tag(2)
            
            // Progress Tab
            VStack {
                Text("Progress")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("View your fitness progress and analytics here")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .tabItem {
                Image(systemName: "chart.line.uptrend.xyaxis")
                Text("Progress")
            }
            .tag(3)
            
            // Profile Tab
            VStack {
                Text("Profile")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Manage your account and settings here")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(4)
        }
    }
    

}

// Supporting Views
struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct ActivityCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomeDashboardView()
        .environmentObject(AuthViewModel())
} 