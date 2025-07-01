import SwiftUI

struct PrivacyFirstView: View {
    @EnvironmentObject var registrationData: RegistrationData
    @State private var agreedToPrivacy = false
    @State private var agreedToTerms = false
    @State private var navigateToFitnessGoal = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Privacy First")
                .font(.largeTitle)
                .bold()
                .padding(.top, 40)
            NavigationStack {
                VStack(spacing: 30) {
                    Text("To continue, please agree to the following:")
                        .font(.title3)
                    CheckboxRow(isChecked: $agreedToPrivacy, label: "I agree to the Privacy Policy")
                    CheckboxRow(isChecked: $agreedToTerms, label: "I agree to the Terms and Conditions")
                    CustomContinueButton(enabled: agreedToPrivacy && agreedToTerms) {
                        navigateToFitnessGoal = true
                    }
                    NavigationLink(destination: FitnessGoalView().environmentObject(registrationData), isActive: $navigateToFitnessGoal) {
                        EmptyView()
                    }
                }
                .padding()
            }
        }
    }
}

struct CheckboxRow: View {
    @Binding var isChecked: Bool
    var label: String
    @State private var isPressed = false
    var body: some View {
        Button(action: { isChecked.toggle() }) {
            HStack {
                ZStack {
                    Circle()
                        .strokeBorder(isChecked ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)) : AnyShapeStyle(Color.gray.opacity(0.4)), lineWidth: 3)
                        .background(
                            Circle().fill(isChecked ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]), startPoint: .top, endPoint: .bottom)) : AnyShapeStyle(Color.clear))
                        )
                        .frame(width: 28, height: 28)
                        .shadow(color: isChecked ? Color.purple.opacity(0.2) : .clear, radius: 4, x: 0, y: 2)
                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.blue)
                            .transition(.scale)
                    }
                }
                .scaleEffect(isPressed ? 0.92 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
                Text(label)
                    .foregroundColor(.primary)
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

struct CustomContinueButton: View {
    var enabled: Bool
    var action: () -> Void
    @State private var isPressed = false
    var body: some View {
        Button(action: action) {
            Text("Continue")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(16)
                .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
                .opacity(enabled ? 1.0 : 0.5)
                .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .disabled(!enabled)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
    }
}

#Preview {
    PrivacyFirstView().environmentObject(RegistrationData())
} 


