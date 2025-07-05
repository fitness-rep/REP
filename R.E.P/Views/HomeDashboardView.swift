import SwiftUI

struct HomeDashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    @StateObject private var dailyProgress: DailyProgress
    @State private var showingLogMeal = false
    @State private var showingLogWorkout = false
    
    // Initialize with user data
    init() {
        // We'll need to get user data from somewhere - for now using default
        let userData = RegistrationData()
        _dailyProgress = StateObject(wrappedValue: DailyProgress(userData: userData))
    }
    
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
                        
                        // Date display
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(DateFormatter.dayFormatter.string(from: Date()))
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            Text(DateFormatter.monthYearFormatter.string(from: Date()))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Progress Overview Section
                        VStack(spacing: 20) {
                            Text("Today's Progress")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 20) {
                                // Calories Progress
                                CircularProgressView(
                                    progress: dailyProgress.caloriesProgress,
                                    title: "Calories",
                                    value: "\(Int(dailyProgress.caloriesConsumed))",
                                    subtitle: "of \(Int(dailyProgress.caloriesTarget))",
                                    color: .blue,
                                    size: 140
                                )
                                
                                // Workout Progress
                                CircularProgressView(
                                    progress: dailyProgress.workoutProgress,
                                    title: "Workout",
                                    value: "\(Int(dailyProgress.workoutMinutesCompleted))",
                                    subtitle: "of \(Int(dailyProgress.workoutMinutesTarget)) min",
                                    color: .green,
                                    size: 140
                                )
                            }
                            
                            // Progress Details
                            HStack(spacing: 16) {
                                ProgressDetailCard(
                                    title: "Calories Left",
                                    value: "\(Int(dailyProgress.caloriesRemaining))",
                                    icon: "flame.fill",
                                    color: .blue
                                )
                                
                                ProgressDetailCard(
                                    title: "Workout Left",
                                    value: "\(Int(dailyProgress.workoutMinutesRemaining)) min",
                                    icon: "figure.strengthtraining.traditional",
                                    color: .green
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
                                    title: "Log Meal",
                                    icon: "plus.circle.fill",
                                    color: .blue
                                ) {
                                    showingLogMeal = true
                                }
                                
                                QuickActionButton(
                                    title: "Log Workout",
                                    icon: "dumbbell.fill",
                                    color: .green
                                ) {
                                    showingLogWorkout = true
                                }
                            }
                            
                            HStack(spacing: 16) {
                                QuickActionButton(
                                    title: "View Plans",
                                    icon: "list.bullet",
                                    color: .orange
                                ) {
                                    selectedTab = 1 // Switch to workouts tab
                                }
                                
                                QuickActionButton(
                                    title: "Progress",
                                    icon: "chart.line.uptrend.xyaxis",
                                    color: .purple
                                ) {
                                    selectedTab = 3 // Switch to progress tab
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Today's Summary
                        VStack(spacing: 16) {
                            Text("Today's Summary")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 12) {
                                SummaryCard(
                                    title: "Calorie Goal",
                                    progress: dailyProgress.caloriesProgress,
                                    color: .blue
                                )
                                
                                SummaryCard(
                                    title: "Workout Goal",
                                    progress: dailyProgress.workoutProgress,
                                    color: .green
                                )
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
                
                Text("Your personalized workout plans will appear here")
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
        .sheet(isPresented: $showingLogMeal) {
            LogMealView(dailyProgress: dailyProgress)
        }
        .sheet(isPresented: $showingLogWorkout) {
            LogWorkoutView(dailyProgress: dailyProgress)
        }
    }
}

// Supporting Views
struct ProgressDetailCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
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
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
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

struct SummaryCard: View {
    let title: String
    let progress: Double
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("\(Int(progress * 100))% Complete")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Mini progress bar
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 8)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: 60 * progress, height: 8)
                    .animation(.easeInOut(duration: 0.5), value: progress)
            }
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

// Date Formatters
extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    static let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }()
}

#Preview {
    HomeDashboardView()
        .environmentObject(AuthViewModel())
} 