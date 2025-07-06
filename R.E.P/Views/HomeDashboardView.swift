import SwiftUI

struct HomeDashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    @StateObject private var dailyProgress: DailyProgressViewModel
    @State private var showingLogMeal = false
    @State private var showingLogWorkout = false
    
    // Initialize with user data
    init() {
        // We'll need to get user data from somewhere - for now using default
        let userData = RegistrationUser()
        _dailyProgress = StateObject(wrappedValue: DailyProgressViewModel(userId: "default", date: Date(), userData: userData))
    }
    
    // Calculate overall goal progress (average of calories and workout progress)
    var overallGoalProgress: Double {
        return (dailyProgress.caloriesProgress + dailyProgress.workoutProgress) / 2.0
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            VStack(spacing: 0) {
                // Header with contact card, calendar, and logout
                HStack {
                    // Contact Card (Top Left)
                    Button(action: {
                        // Contact action - could open contact info or profile
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                            
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    // Calendar Pill (Center)
                    ProgressCalendarView()
                    
                    Spacer()
                    
                    // Logout Button (Top Right)
                    Button(action: {
                        // Sign out the user with error handling
                        DispatchQueue.main.async {
                            authViewModel.signOut()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                            
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Overall Goal Progress Section
                        VStack(spacing: 20) {
                            // Overall Goal Progress Bar
                            CircularProgressView(
                                progress: overallGoalProgress,
                                title: "Goal Progress",
                                value: "\(Int(overallGoalProgress * 100))%",
                                subtitle: "Complete",
                                color: .purple,
                                size: 160
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Progress Overview Section
                        VStack(spacing: 20) {
                            Text("Today's Progress")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 20) {
                                // Calories Progress
                                CircularProgressView(
                                    progress: dailyProgress.caloriesProgress,
                                    title: "Calories",
                                    value: "\(Int(dailyProgress.caloriesConsumed))",
                                    subtitle: "of \(Int(dailyProgress.caloriesTarget))",
                                    color: .blue,
                                    size: 120
                                )
                                
                                // Workout Progress
                                CircularProgressView(
                                    progress: dailyProgress.workoutProgress,
                                    title: "Workout",
                                    value: "\(Int(dailyProgress.workoutMinutesCompleted))",
                                    subtitle: "of \(Int(dailyProgress.workoutMinutesTarget)) min",
                                    color: .green,
                                    size: 120
                                )
                            }
                            

                        }
                        .padding(.horizontal, 20)
                        
                        // Quick Actions
                        VStack(spacing: 16) {
                            Text("Quick Actions")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 16) {
                                QuickActionButton(
                                    title: "View Today's Meals",
                                    icon: "fork.knife",
                                    color: .blue
                                ) {
                                    showingLogMeal = true
                                }
                                
                                QuickActionButton(
                                    title: "View Today's Workout",
                                    icon: "figure.strengthtraining.traditional",
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
                                .foregroundColor(.white)
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
                                
                                SummaryCard(
                                    title: "Overall Goal",
                                    progress: overallGoalProgress,
                                    color: .purple
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .background(Color.black.ignoresSafeArea())
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
                    .foregroundColor(.white)
                
                Text("Your personalized workout plans will appear here")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .background(Color.black.ignoresSafeArea())
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
                    .foregroundColor(.white)
                
                Text("Track your meals and nutrition here")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .background(Color.black.ignoresSafeArea())
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
                    .foregroundColor(.white)
                
                Text("View your fitness progress and analytics here")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .background(Color.black.ignoresSafeArea())
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
                    .foregroundColor(.white)
                
                Text("Manage your account and settings here")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .background(Color.black.ignoresSafeArea())
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(4)
        }
        .sheet(isPresented: $showingLogMeal) {
            TodaysMealPlanView(dailyProgress: dailyProgress)
        }
        .sheet(isPresented: $showingLogWorkout) {
            TodaysWorkoutPlanView(dailyProgress: dailyProgress)
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
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
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
                    .foregroundColor(.white)
                
                Text("\(Int(progress * 100))% Complete")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
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
                .fill(Color.white.opacity(0.1))
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
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
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

//#Preview {
//    HomeDashboardView()
//        .environmentObject(AuthViewModel())
//        .environmentObject(RegistrationUser())
//} 