import SwiftUI

struct PrivacyFirstView: View {
    @EnvironmentObject var registrationUser: RegistrationUser
    @State private var agreedToPrivacy = false
    @State private var agreedToTerms = false
    @State private var navigateToFitnessGoal = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    Spacer()
                    // Icon and Headline
                    VStack(spacing: 18) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.18), Color.blue.opacity(0.18)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 80, height: 80)
                                .blur(radius: 0.5)
                            Image(systemName: "lock.shield.fill")
                                .font(.system(size: 38, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: Color.purple.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.bottom, 2)
                        // Gradient headline
                        Text("Privacy First")
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: Color.purple.opacity(0.3), radius: 8, x: 0, y: 4)
                        Text("We care about your privacy. Please agree to continue.")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 32)
                    // No card, just checkboxes on black background
                    VStack(spacing: 28) {
                        CheckboxRow(isChecked: $agreedToPrivacy, label: "I agree to the Privacy Policy")
                        CheckboxRow(isChecked: $agreedToTerms, label: "I agree to the Terms and Conditions")
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    Spacer()
                    // Floating Continue Button
                    Button(action: { 
                        registrationUser.printProperties(context: "PrivacyFirstView - Continue Button")
                        navigateToFitnessGoal = true 
                    }) {
                        Text("Continue")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(32)
                            .shadow(color: .purple.opacity(0.3), radius: 12, x: 0, y: 6)
                            .opacity(agreedToPrivacy && agreedToTerms ? 1.0 : 0.5)
                    }
                    .disabled(!(agreedToPrivacy && agreedToTerms))
                    .padding(.horizontal, 40)
                    .padding(.bottom, 48)
                    NavigationLink(destination: FitnessGoalView().environmentObject(registrationUser), isActive: $navigateToFitnessGoal) {
                        EmptyView()
                    }
                }
            }
        }
    }
}

struct CheckboxRow: View {
    @Binding var isChecked: Bool
    var label: String
    @State private var isPressed = false
    var body: some View {
        Button(action: { withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) { isChecked.toggle() } }) {
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
                    .foregroundColor(.white)
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

//#Preview {
//    PrivacyFirstView().environmentObject(RegistrationUser())
//} 



