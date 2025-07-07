import SwiftUI

struct StrengthRoutineView: View {
    @State private var selectedRoutines: Set<StrengthRoutine> = []
    @State private var navigateToNext = false
    
    @EnvironmentObject var registrationUser: RegistrationUser
    
    let options: [StrengthRoutine] = StrengthRoutine.allCases
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Which best describes your current\nstrength training routine?")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, 40)
            Spacer()
            VStack(spacing: 24) {
                ForEach(options, id: \ .self) { option in
                    StrengthRoutineCard(
                        routine: option,
                        isSelected: selectedRoutines.contains(option)
                    ) {
                        if selectedRoutines.contains(option) {
                            selectedRoutines.remove(option)
                        } else {
                            selectedRoutines.insert(option)
                        }
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
            Button(action: {
                navigateToNext = true
                registrationUser.strengthRoutine = selectedRoutines
                registrationUser.printProperties(context: "Strength Routine View - Exercise Location")
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
                    .opacity(selectedRoutines.isEmpty ? 0.5 : 1.0)
            }
            .disabled(selectedRoutines.isEmpty)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            NavigationLink(destination: ExerciseLocationView().environmentObject(registrationUser), isActive: $navigateToNext) {
                EmptyView()
            }
        }
    }
}

enum StrengthRoutine: String, CaseIterable, Hashable, Codable {
    case consistent = "I strength train consistently"
    case struggle = "I struggle with consistency"
    case reestablishing = "I am reestablishing a routine"
    case never = "I never had a routine"
    
    var icon: String {
        switch self {
        case .consistent: return "checkmark.seal.fill"
        case .struggle: return "exclamationmark.triangle.fill"
        case .reestablishing: return "arrow.triangle.2.circlepath"
        case .never: return "questionmark.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .consistent: return .green
        case .struggle: return .orange
        case .reestablishing: return .blue
        case .never: return .gray
        }
    }
}

struct StrengthRoutineCard: View {
    let routine: StrengthRoutine
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
                                gradient: Gradient(colors: [routine.color.opacity(0.7), routine.color.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 54, height: 54)
                        .shadow(color: routine.color.opacity(0.18), radius: 6, x: 0, y: 2)
                    Image(systemName: routine.icon)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(isPressed ? 0.92 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(routine.rawValue)
                        .font(.headline)
                        .foregroundColor(isSelected ? .white : .primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(routine.color)
                        .font(.title2)
                        .transition(.scale)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isSelected ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [routine.color, .purple]), startPoint: .leading, endPoint: .trailing)) : AnyShapeStyle(Color(.systemGray6)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? AnyShapeStyle(routine.color) : AnyShapeStyle(Color.clear), lineWidth: 2)
            )
            .shadow(color: isSelected ? routine.color.opacity(0.15) : .clear, radius: 8, x: 0, y: 4)
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
//    StrengthRoutineView()
//} 
