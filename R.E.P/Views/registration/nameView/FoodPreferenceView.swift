import SwiftUI

struct FoodPreferenceView: View {
    @State private var selectedPreference: FoodPreference? = nil
    @State private var navigateToNext = false
    
    @EnvironmentObject var registrationUser: RegistrationUser
    let options: [FoodPreference] = FoodPreference.allCases
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Text("What foods do you prefer?")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.top, 40)
                    
                    Text("This helps us customize your nutrition recommendations")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 40)
                
                // Food preference cards
                VStack(spacing: 20) {
                    ForEach(options, id: \.self) { option in
                        FoodPreferenceCard(
                            preference: option,
                            isSelected: selectedPreference == option
                        ) {
                            selectedPreference = option
                            navigateToNext = true
                            registrationUser.foodPreference = option.rawValue
                            registrationUser.printProperties(context: "FoodPreferenceView -> HealthInfoView")
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
                NavigationLink(destination: HealthInfoView().environmentObject(registrationUser), isActive: $navigateToNext) {
                    EmptyView()
                }
            }
        }
    }
}

enum FoodPreference: String, CaseIterable, Hashable {
    case vegetarian = "Vegetarian"
    case nonVegetarian = "Non-Vegetarian"
    case both = "Both (Flexitarian)"
    case vegan = "Vegan"
    
    var icon: String {
        switch self {
        case .vegetarian: return "leaf.fill"
        case .nonVegetarian: return "fork.knife"
        case .both: return "arrow.left.arrow.right"
        case .vegan: return "leaf.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .vegetarian: return .green
        case .nonVegetarian: return .red
        case .both: return .purple
        case .vegan: return .mint
        }
    }
    
    var description: String {
        switch self {
        case .vegetarian: return "Plant-based foods, dairy, and eggs"
        case .nonVegetarian: return "All foods including meat and fish"
        case .both: return "Flexible diet with both options"
        case .vegan: return "Strictly plant-based only"
        }
    }
    
    var benefits: String {
        switch self {
        case .vegetarian: return "Heart health, sustainability"
        case .nonVegetarian: return "Complete protein, variety"
        case .both: return "Flexibility, balanced nutrition"
        case .vegan: return "Ethical, environmental impact"
        }
    }
}

struct FoodPreferenceCard: View {
    let preference: FoodPreference
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                // Icon with animated background
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [preference.color.opacity(0.8), preference.color.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .shadow(color: preference.color.opacity(0.2), radius: 6, x: 0, y: 3)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                    
                    Image(systemName: preference.icon)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 6) {
                    Text(preference.rawValue)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(isSelected ? .white : .primary)
                        .lineLimit(1)
                    
                    Text(preference.description)
                        .font(.subheadline)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(preference.benefits)
                        .font(.caption)
                        .foregroundColor(isSelected ? .white.opacity(0.7) : .secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Selection indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? 
                        AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [preference.color, preference.color.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing)) :
                        AnyShapeStyle(Color(.systemGray6))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? preference.color : Color.clear, lineWidth: 2)
            )
            .shadow(color: isSelected ? preference.color.opacity(0.2) : .clear, radius: 8, x: 0, y: 4)
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
//    FoodPreferenceView()
//} 
