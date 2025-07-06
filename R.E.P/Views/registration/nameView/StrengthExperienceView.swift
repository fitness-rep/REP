import SwiftUI

struct StrengthExperienceView: View {
    @State private var selectedExperience: StrengthExperience? = nil
    @State private var navigateToNext = false
    
    let options: [StrengthExperience] = StrengthExperience.allCases
    
    var body: some View {
        VStack(spacing: 0) {
            Text("How much strength training experience do you have?")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, 40)
            Spacer()
            VStack(spacing: 24) {
                ForEach(options, id: \ .self) { option in
                    ExperienceOptionCard(
                        experience: option,
                        isSelected: selectedExperience == option
                    ) {
                        selectedExperience = option
                        navigateToNext = true // You can update this to navigate to the next screen
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
            // NavigationLink to next screen (placeholder for now)
            NavigationLink(destination: ExperienceLevelView(), isActive: $navigateToNext) {
                EmptyView()
            }
        }
    }
}

enum StrengthExperience: String, CaseIterable, Hashable {
    case moreThan4 = "More than 4 years"
    case twoToFour = "2 to 4 years"
    case oneToTwo = "1 to 2 years"
    case lessThanOne = "Less than a year"
    case none = "None"
    
    var icon: String {
        switch self {
        case .moreThan4: return "flame.fill"
        case .twoToFour: return "bolt.heart.fill"
        case .oneToTwo: return "figure.strengthtraining.traditional"
        case .lessThanOne: return "figure.walk"
        case .none: return "questionmark.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .moreThan4: return .purple
        case .twoToFour: return .blue
        case .oneToTwo: return .green
        case .lessThanOne: return .orange
        case .none: return .gray
        }
    }
}

struct ExperienceOptionCard: View {
    let experience: StrengthExperience
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
                                gradient: Gradient(colors: [experience.color.opacity(0.7), experience.color.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 54, height: 54)
                        .shadow(color: experience.color.opacity(0.18), radius: 6, x: 0, y: 2)
                    Image(systemName: experience.icon)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(isPressed ? 0.92 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(experience.rawValue)
                        .font(.headline)
                        .foregroundColor(isSelected ? .white : .primary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(experience.color)
                        .font(.title2)
                        .transition(.scale)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isSelected ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [experience.color, .purple]), startPoint: .leading, endPoint: .trailing)) : AnyShapeStyle(Color(.systemGray6)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? AnyShapeStyle(experience.color) : AnyShapeStyle(Color.clear), lineWidth: 2)
            )
            .shadow(color: isSelected ? experience.color.opacity(0.15) : .clear, radius: 8, x: 0, y: 4)
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
//    StrengthExperienceView()
//} 