import SwiftUI

struct SchedulePreferenceView: View {
    @State private var selectedPreference: SchedulePreference? = nil
    @State private var navigateToNext = false
    
    let options: [SchedulePreference] = SchedulePreference.allCases
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Choose the way you want to schedule your workout?")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 40)
            Spacer()
            VStack(spacing: 24) {
                ForEach(options, id: \ .self) { option in
                    SchedulePreferenceCard(
                        preference: option,
                        isSelected: selectedPreference == option
                    ) {
                        selectedPreference = option
                        navigateToNext = true
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
            NavigationLink(destination: WorkoutDurationView(), isActive: $navigateToNext) {
                EmptyView()
            }
        }
    }
}

enum SchedulePreference: String, CaseIterable, Hashable {
    case calendar = "Calendar driven"
    case flexible = "No calendar"
    case hybrid = "Hybrid"
    
    var subtitle: String {
        switch self {
        case .calendar:
            return "Stay committed and focused with a structured workout calendar"
        case .flexible:
            return "Train according to your own schedule"
        case .hybrid:
            return "Mix of calendar and flexible scheduling"
        }
    }
    
    var icon: String {
        switch self {
        case .calendar: return "calendar"
        case .flexible: return "clock.arrow.circlepath"
        case .hybrid: return "rectangle.3.group.bubble.left"
        }
    }
    
    var color: Color {
        switch self {
        case .calendar: return .blue
        case .flexible: return .orange
        case .hybrid: return .purple
        }
    }
}

struct SchedulePreferenceCard: View {
    let preference: SchedulePreference
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false
    var body: some View {
        Button(action: action) {
            HStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [preference.color.opacity(0.7), preference.color.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 54, height: 54)
                        .shadow(color: preference.color.opacity(0.18), radius: 6, x: 0, y: 2)
                    Image(systemName: preference.icon)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(isPressed ? 0.92 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(preference.rawValue)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(isSelected ? .white : .primary)
                    Text(preference.subtitle)
                        .font(.subheadline)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(preference.color)
                        .font(.title2)
                        .transition(.scale)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isSelected ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [preference.color, .purple]), startPoint: .leading, endPoint: .trailing)) : AnyShapeStyle(Color(.systemGray6)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? AnyShapeStyle(preference.color) : AnyShapeStyle(Color.clear), lineWidth: 2)
            )
            .shadow(color: isSelected ? preference.color.opacity(0.15) : .clear, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

//#Preview {
//    SchedulePreferenceView()
//} 