import SwiftUI

struct HealthInfoView: View {
    @State private var isTakingMedications: Bool? = nil
    @State private var medications: String = ""
    @State private var hasInjuries: Bool? = nil
    @State private var injuries: String = ""
    @State private var showMedicationTextField = false
    @State private var showInjuryTextField = false
    @State private var navigateToNext = false
    @EnvironmentObject var registrationUser: RegistrationUser
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Text("Health Information")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.top, 40)
                    
                    Text("This helps us provide safe and personalized recommendations")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 40)
                
                // Medications Section
                VStack(spacing: 24) {
                    Text("Are you taking any medications?")
                        .font(.title3)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                    
                    // Medication options
                    HStack(spacing: 20) {
                        // Yes button
                        Button(action: {
                            isTakingMedications = true
                            showMedicationTextField = true
                        }) {
                            VStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.red.opacity(0.8), Color.orange.opacity(0.4)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 50, height: 50)
                                        .shadow(color: Color.red.opacity(0.2), radius: 4, x: 0, y: 2)
                                    
                                    Image(systemName: "pills")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                Text("Yes")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(isTakingMedications == true ? .white : .primary)
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(isTakingMedications == true ? 
                                        AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing)) :
                                        AnyShapeStyle(Color(.systemGray6))
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(isTakingMedications == true ? Color.red : Color.clear, lineWidth: 2)
                            )
                            .shadow(color: isTakingMedications == true ? Color.red.opacity(0.2) : .clear, radius: 6, x: 0, y: 3)
                        }
                        
                        // No button
                        Button(action: {
                            isTakingMedications = false
                            showMedicationTextField = false
                            medications = ""
                        }) {
                            VStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.green.opacity(0.8), Color.blue.opacity(0.4)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 50, height: 50)
                                        .shadow(color: Color.green.opacity(0.2), radius: 4, x: 0, y: 2)
                                    
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                Text("No")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(isTakingMedications == false ? .white : .primary)
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(isTakingMedications == false ? 
                                        AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)) :
                                        AnyShapeStyle(Color(.systemGray6))
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(isTakingMedications == false ? Color.green : Color.clear, lineWidth: 2)
                            )
                            .shadow(color: isTakingMedications == false ? Color.green.opacity(0.2) : .clear, radius: 6, x: 0, y: 3)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Medication text field
                    if showMedicationTextField {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Please mention your medications:")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            TextField("Enter medications here...", text: $medications, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(3...6)
                                .padding(.horizontal, 24)
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
                
                // Injuries Section
                VStack(spacing: 24) {
                    Text("Do you have any injuries?")
                        .font(.title3)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                    
                    // Injury options
                    HStack(spacing: 20) {
                        // Yes button
                        Button(action: {
                            hasInjuries = true
                            showInjuryTextField = true
                        }) {
                            VStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.orange.opacity(0.8), Color.red.opacity(0.4)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 50, height: 50)
                                        .shadow(color: Color.orange.opacity(0.2), radius: 4, x: 0, y: 2)
                                    
                                    Image(systemName: "bandage")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                Text("Yes")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(hasInjuries == true ? .white : .primary)
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(hasInjuries == true ? 
                                        AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing)) :
                                        AnyShapeStyle(Color(.systemGray6))
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(hasInjuries == true ? Color.orange : Color.clear, lineWidth: 2)
                            )
                            .shadow(color: hasInjuries == true ? Color.orange.opacity(0.2) : .clear, radius: 6, x: 0, y: 3)
                        }
                        
                        // No button
                        Button(action: {
                            hasInjuries = false
                            showInjuryTextField = false
                            injuries = ""
                        }) {
                            VStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.green.opacity(0.8), Color.blue.opacity(0.4)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 50, height: 50)
                                        .shadow(color: Color.green.opacity(0.2), radius: 4, x: 0, y: 2)
                                    
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                Text("No")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(hasInjuries == false ? .white : .primary)
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(hasInjuries == false ? 
                                        AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)) :
                                        AnyShapeStyle(Color(.systemGray6))
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(hasInjuries == false ? Color.green : Color.clear, lineWidth: 2)
                            )
                            .shadow(color: hasInjuries == false ? Color.green.opacity(0.2) : .clear, radius: 6, x: 0, y: 3)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Injury text field
                    if showInjuryTextField {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Please mention your injuries:")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            TextField("Enter injuries here...", text: $injuries, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(3...6)
                                .padding(.horizontal, 24)
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
                
                // Continue button
                Button(action: { 
                    navigateToNext = true 
                    registrationUser.isTakingMedications = isTakingMedications ?? false
                    registrationUser.hasInjuries = hasInjuries ?? false
                    registrationUser.medications = medications
                    registrationUser.injuries = injuries
                    registrationUser.printProperties(context: "HealthInfoView -> RegistrationView")
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
                        .opacity(canProceed ? 1.0 : 0.5)
                }
                .disabled(!canProceed)
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
                
                NavigationLink(destination: RegistrationView().environmentObject(registrationUser), isActive: $navigateToNext) {
                    EmptyView()
                }
            }
        }
        .animation(.spring(), value: showMedicationTextField)
        .animation(.spring(), value: showInjuryTextField)
    }
    
    private var canProceed: Bool {
        isTakingMedications != nil && hasInjuries != nil
    }
}

//#Preview {
//    HealthInfoView()
//} 
