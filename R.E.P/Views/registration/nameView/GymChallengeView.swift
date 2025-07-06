import SwiftUI

struct GymChallengeView: View {
    @State private var selectedChallenges: Set<GymChallenge> = []
    @State private var navigateToNext = false
    
    let options: [GymChallenge] = GymChallenge.allCases
    
    var body: some View {
        VStack(spacing: 0) {
            Text("What is your major challenge at the\ngym?")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 40)
            Spacer()
            VStack(spacing: 24) {
                ForEach(options, id: \ .self) { option in
                    GymChallengeCard(
                        challenge: option,
                        isSelected: selectedChallenges.contains(option)
                    ) {
                        if selectedChallenges.contains(option) {
                            selectedChallenges.remove(option)
                        } else {
                            selectedChallenges.insert(option)
                        }
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
            Button(action: { navigateToNext = true }) {
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
                    .opacity(selectedChallenges.isEmpty ? 0.5 : 1.0)
            }
            .disabled(selectedChallenges.isEmpty)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            NavigationLink(destination: StrengthRoutineView(), isActive: $navigateToNext) {
                EmptyView()
            }
        }
    }
}

enum GymChallenge: String, CaseIterable, Hashable {
    case motivation = "Staying motivated and consistent"
    case guidance = "Not getting enough guidance"
    case interesting = "Keeping my workouts interesting"
    case time = "Finding time to work out"
    case progress = "Seeing progress/results"
    
    var icon: String {
        switch self {
        case .motivation: return "flame"
        case .guidance: return "person.2.fill"
        case .interesting: return "sparkles"
        case .time: return "clock"
        case .progress: return "chart.bar.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .motivation: return .orange
        case .guidance: return .blue
        case .interesting: return .purple
        case .time: return .green
        case .progress: return .pink
        }
    }
}

struct GymChallengeCard: View {
    let challenge: GymChallenge
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
                                gradient: Gradient(colors: [challenge.color.opacity(0.7), challenge.color.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 54, height: 54)
                        .shadow(color: challenge.color.opacity(0.18), radius: 6, x: 0, y: 2)
                    Image(systemName: challenge.icon)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(isPressed ? 0.92 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.rawValue)
                        .font(.headline)
                        .foregroundColor(isSelected ? .white : .primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(challenge.color)
                        .font(.title2)
                        .transition(.scale)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isSelected ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [challenge.color, .purple]), startPoint: .leading, endPoint: .trailing)) : AnyShapeStyle(Color(.systemGray6)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? AnyShapeStyle(challenge.color) : AnyShapeStyle(Color.clear), lineWidth: 2)
            )
            .shadow(color: isSelected ? challenge.color.opacity(0.15) : .clear, radius: 8, x: 0, y: 4)
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
//    GymChallengeView()
//} 