import SwiftUI

struct ExerciseLocationView: View {
    @State private var selectedLocation: ExerciseLocation? = nil
    @State private var navigateToNext = false
    
    let options: [ExerciseLocation] = ExerciseLocation.allCases
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Where do you exercise?")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 40)
            Spacer()
            VStack(spacing: 24) {
                ForEach(options, id: \ .self) { option in
                    ExerciseLocationCard(
                        location: option,
                        isSelected: selectedLocation == option
                    ) {
                        selectedLocation = option
                        navigateToNext = true
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
            NavigationLink(destination: SchedulePreferenceView(), isActive: $navigateToNext) {
                EmptyView()
            }
        }
    }
}

enum ExerciseLocation: String, CaseIterable, Hashable {
    case largeGym = "Large gym"
    case smallGym = "Small gym"
    case atHome = "At home"
    case garageGym = "Garage gym"
    case custom = "Custom (build your own equipment list)"
    
    var icon: String {
        switch self {
        case .largeGym: return "building.2.crop.circle"
        case .smallGym: return "building"
        case .atHome: return "house.fill"
        case .garageGym: return "car.2"
        case .custom: return "wrench.and.screwdriver"
        }
    }
    
    var color: Color {
        switch self {
        case .largeGym: return .blue
        case .smallGym: return .green
        case .atHome: return .orange
        case .garageGym: return .gray
        case .custom: return .purple
        }
    }
}

struct ExerciseLocationCard: View {
    let location: ExerciseLocation
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
                                gradient: Gradient(colors: [location.color.opacity(0.7), location.color.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 54, height: 54)
                        .shadow(color: location.color.opacity(0.18), radius: 6, x: 0, y: 2)
                    Image(systemName: location.icon)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(isPressed ? 0.92 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.rawValue)
                        .font(.headline)
                        .foregroundColor(isSelected ? .white : .primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(location.color)
                        .font(.title2)
                        .transition(.scale)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isSelected ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [location.color, .purple]), startPoint: .leading, endPoint: .trailing)) : AnyShapeStyle(Color(.systemGray6)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? AnyShapeStyle(location.color) : AnyShapeStyle(Color.clear), lineWidth: 2)
            )
            .shadow(color: isSelected ? location.color.opacity(0.15) : .clear, radius: 8, x: 0, y: 4)
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
    ExerciseLocationView()
} 