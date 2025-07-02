import SwiftUI

struct FitnessGoalView: View {
    @EnvironmentObject var registrationData: RegistrationData
    @State private var selectedGoal: FitnessGoal? = nil
    @State private var navigateToNext = false
    
    let goals: [FitnessGoal] = [
        .fatLoss, .muscleGain, .bodyRecomp, .generalHealth
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("What are your fitness goals?")
                .font(.largeTitle)
                .bold()
                .padding(.top, 40)
            Spacer()
            VStack(spacing: 24) {
                ForEach(goals, id: \ .self) { goal in
                    FitnessGoalOptionButton(
                        title: goal.displayName,
                        subtitle: goal.subtitle,
                        isSelected: selectedGoal == goal
                    ) {
                        selectedGoal = goal
                        registrationData.fitnessGoal = goal.displayName
                        navigateToNext = true
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
            NavigationLink(destination: StrengthExperienceView(), isActive: $navigateToNext) {
                EmptyView()
            }
        }
    }
}

enum FitnessGoal: String, CaseIterable, Hashable {
    case fatLoss, muscleGain, bodyRecomp, generalHealth
    var displayName: String {
        switch self {
        case .fatLoss: return "Fat Loss / Weight Reduction"
        case .muscleGain: return "Muscle Gain / Strength Building"
        case .bodyRecomp: return "Body Recomposition (Lose fat & build muscle)"
        case .generalHealth: return "General Health & Wellness"
        }
    }
    var subtitle: String {
        switch self {
        case .fatLoss: return "Burn fat, slim down, and lose weight."
        case .muscleGain: return "Build muscle mass and get stronger."
        case .bodyRecomp: return "Lose fat while building muscle."
        case .generalHealth: return "Improve overall health and wellness."
        }
    }
}

struct FitnessGoalOptionButton: View {
    var title: String
    var subtitle: String
    var isSelected: Bool
    var action: () -> Void
    @State private var isPressed = false
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.7), Color.blue.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing)) : AnyShapeStyle(Color(.systemGray6)))
                        .frame(width: 60, height: 60)
                        .shadow(color: isSelected ? Color.purple.opacity(0.2) : .clear, radius: 6, x: 0, y: 2)
                    Image(systemName: isSelected ? "checkmark.seal.fill" : "figure.walk")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(isSelected ? .white : .blue)
                        .scaleEffect(isPressed ? 0.92 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(isSelected ? .white : .primary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                }
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isSelected ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)) : AnyShapeStyle(Color(.systemGray5)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? AnyShapeStyle(Color.purple) : AnyShapeStyle(Color.clear), lineWidth: 2)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .shadow(color: isSelected ? Color.purple.opacity(0.15) : .clear, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

#Preview {
    FitnessGoalView().environmentObject(RegistrationData())
} 