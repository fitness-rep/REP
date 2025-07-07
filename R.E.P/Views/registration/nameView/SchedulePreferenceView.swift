import SwiftUI

struct SchedulePreferenceView: View {
    enum ScheduleTab { case smart, fixed }
    @Environment(\.presentationMode) var presentationMode
    @Namespace private var tabNamespace
    @State private var selectedTab: ScheduleTab = .smart
    @State private var selectedSmart: Int? = nil
    @State private var selectedDays: Set<String> = []
    @State private var navigateToNext = false
    @EnvironmentObject var registrationUser: RegistrationUser
    
    let smartOptions = [
        "1 workout/week",
        "2 workouts/week",
        "3 workouts/week",
        "4 workouts/week",
        "5 workouts/week",
        "6 workouts/week",
        "Every Day"
    ]
    let weekDays = [
        "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
    ]
    
    var canContinue: Bool {
        switch selectedTab {
        case .smart: return selectedSmart != nil
        case .fixed: return !selectedDays.isEmpty
        }
    }
    
    // Segmented control as a computed property
    private var segmentedControl: some View {
        HStack(spacing: 0) {
            ForEach([ScheduleTab.smart, ScheduleTab.fixed], id: \.self) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedTab = tab
                    }
                }) {
                    HStack(spacing: 4) {
                        Text(tab == .smart ? "SMART SCHEDULE ✨" : "FIXED SCHEDULE")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(selectedTab == tab ? .black : .primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        ZStack {
                            if selectedTab == tab {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.07), radius: 4, x: 0, y: 2)
                                    .matchedGeometryEffect(id: "tab", in: tabNamespace)
                            }
                        }
                    )
                }
            }
        }
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
    
    // Smart options as a computed property
    private var smartOptionsList: some View {
        ForEach(smartOptions.indices, id: \.self) { idx in
            let option = smartOptions[idx]
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    selectedSmart = idx
                }
            }) {
                HStack {
                    Text(option)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(selectedSmart == idx ? .white : .primary)
                    Spacer()
                }
                .padding(.vertical, 18)
                .padding(.horizontal, 18)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(selectedSmart == idx
                            ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                            : AnyShapeStyle(Color(.systemGray6))
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // Fixed options as a computed property
    private var fixedOptionsList: some View {
        ForEach(weekDays, id: \.self) { day in
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    if selectedDays.contains(day) {
                        selectedDays.remove(day)
                    } else {
                        selectedDays.insert(day)
                    }
                }
            }) {
                HStack {
                    Text(day)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(selectedDays.contains(day) ? .white : .primary)
                    Spacer()
                }
                .padding(.vertical, 18)
                .padding(.horizontal, 18)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(selectedDays.contains(day)
                            ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                            : AnyShapeStyle(Color(.systemGray6))
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Title
            Text("to workout?")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            // Segmented control
            segmentedControl
            // Description
            Text(selectedTab == .smart ?
                 "I'll dynamically adapt your schedule according to your activity and preferences."
                 : "You can pick the specific weekdays you want to work out and maintain a set schedule.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 16)
            // Options
            VStack(spacing: 14) {
                if selectedTab == .smart {
                    smartOptionsList
                } else {
                    fixedOptionsList
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            Spacer()
            Spacer()
            
            // Continue button
            Button(action: {
                navigateToNext = true
                
                // Save schedule preference data
                registrationUser.scheduleType = selectedTab == .smart ? "smart" : "fixed"
                
                if selectedTab == .smart {
                    registrationUser.smartScheduleWorkoutsPerWeek = selectedSmart
                    registrationUser.fixedScheduleDays = nil
                } else {
                    registrationUser.smartScheduleWorkoutsPerWeek = nil
                    registrationUser.fixedScheduleDays = selectedDays
                }
                
                registrationUser.printProperties(context: "SchedulePreferenceView -> WorkoutDurationView")
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(16)
                    .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
                    .opacity(canContinue ? 1.0 : 0.5)
            }
            .disabled(!canContinue)
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
            NavigationLink(destination: WorkoutDurationView().environmentObject(registrationUser), isActive: $navigateToNext) {
                EmptyView()
            }
        }
        .background(Color(.systemBackground))
        .ignoresSafeArea(edges: .bottom)
    }
}
