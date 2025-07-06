import SwiftUI

struct ExperienceLevelView: View {
    @State private var selectedLevel: ExperienceLevel? = nil
    @State private var navigateToNext = false
    
    let options: [ExperienceLevel] = ExperienceLevel.allCases
    
    var body: some View {
        VStack(spacing: 0) {
            Text("What would you describe your\nexperience level?")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, 40)
            Spacer()
            VStack(spacing: 24) {
                ForEach(options, id: \ .self) { option in
                    ExperienceLevelCard(
                        level: option,
                        isSelected: selectedLevel == option
                    ) {
                        selectedLevel = option
                        navigateToNext = true // You can update this to navigate to the next screen
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
            // NavigationLink to next screen (placeholder for now)
            NavigationLink(destination: GymChallengeView(), isActive: $navigateToNext) {
                EmptyView()
            }
        }
    }
}

enum ExperienceLevel: String, CaseIterable, Hashable {
    case expert = "Expert"
    case intermediate = "Intermediate"
    case foundational = "Foundational"
    case novice = "Novice"
    case beginner = "Beginner"
    
    var icon: String {
        switch self {
        case .expert: return "star.fill"
        case .intermediate: return "star.lefthalf.fill"
        case .foundational: return "bolt.fill"
        case .novice: return "leaf.fill"
        case .beginner: return "sparkles"
        }
    }
    
    var color: Color {
        switch self {
        case .expert: return .purple
        case .intermediate: return .blue
        case .foundational: return .green
        case .novice: return .orange
        case .beginner: return .gray
        }
    }
}

struct ExperienceLevelCard: View {
    let level: ExperienceLevel
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
                                gradient: Gradient(colors: [level.color.opacity(0.7), level.color.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 54, height: 54)
                        .shadow(color: level.color.opacity(0.18), radius: 6, x: 0, y: 2)
                    Image(systemName: level.icon)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(isPressed ? 0.92 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(level.rawValue)
                        .font(.headline)
                        .foregroundColor(isSelected ? .white : .primary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(level.color)
                        .font(.title2)
                        .transition(.scale)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isSelected ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [level.color, .purple]), startPoint: .leading, endPoint: .trailing)) : AnyShapeStyle(Color(.systemGray6)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? AnyShapeStyle(level.color) : AnyShapeStyle(Color.clear), lineWidth: 2)
            )
            .shadow(color: isSelected ? level.color.opacity(0.15) : .clear, radius: 8, x: 0, y: 4)
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
//    ExperienceLevelView()
//} 