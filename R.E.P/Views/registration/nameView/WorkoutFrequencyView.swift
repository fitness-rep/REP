import SwiftUI

struct WorkoutFrequencyView: View {
    @State private var selectedFrequency: WorkoutFrequency? = nil
    @State private var navigateToNext = false
    @State private var showCustomSheet = false
    @State private var selectedCustomRange: CustomFrequencyRange? = nil
    
    let options: [WorkoutFrequency] = WorkoutFrequency.allCases
    let customRanges: [CustomFrequencyRange] = CustomFrequencyRange.allCases
    
    var body: some View {
        VStack(spacing: 0) {
            Text("How often do you wanna workout?")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 40)
            Spacer()
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(options, id: \ .self) { option in
                        WorkoutFrequencyCard(
                            frequency: option,
                            isSelected: selectedFrequency == option || (option == .custom && selectedCustomRange != nil)
                        ) {
                            if option == .custom {
                                showCustomSheet = true
                            } else {
                                selectedFrequency = option
                                navigateToNext = true
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            Spacer(minLength: 0)
            NavigationLink(destination: SchedulePreferenceView(), isActive: $navigateToNext) {
                EmptyView()
            }
        }
        .sheet(isPresented: $showCustomSheet) {
            CustomFrequencyPickerSheet(selectedRange: $selectedCustomRange, onDone: {
                showCustomSheet = false
                if selectedCustomRange != nil {
                    selectedFrequency = .custom
                    navigateToNext = true
                }
            })
            .presentationDetents([.fraction(0.35)])
        }
    }
}

enum WorkoutFrequency: String, CaseIterable, Hashable {
    case two = "2 days a week"
    case three = "3 days a week"
    case four = "4 days a week"
    case five = "5 days a week"
    case six = "6 days a week"
    case seven = "7 days a week"
    case custom = "Custom (choose your own)"
    
    var icon: String {
        switch self {
        case .two: return "2.circle"
        case .three: return "3.circle"
        case .four: return "4.circle"
        case .five: return "5.circle"
        case .six: return "6.circle"
        case .seven: return "7.circle"
        case .custom: return "slider.horizontal.3"
        }
    }
    
    var color: Color {
        switch self {
        case .two: return .gray
        case .three: return .blue
        case .four: return .green
        case .five: return .orange
        case .six: return .purple
        case .seven: return .pink
        case .custom: return .teal
        }
    }
}

enum CustomFrequencyRange: String, CaseIterable, Hashable {
    case twoToThree = "2 to 3 days a week"
    case threeToFive = "3 to 5 days a week"
    case fourToSix = "4 to 6 days a week"
    case fiveToSix = "5 to 6 days a week"
    case customOther = "Other (specify)"
}

struct CustomFrequencyPickerSheet: View {
    @Binding var selectedRange: CustomFrequencyRange?
    var onDone: () -> Void
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Select your custom range")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                Picker("Custom Range", selection: $selectedRange) {
                    ForEach(CustomFrequencyRange.allCases, id: \ .self) { range in
                        Text(range.rawValue).tag(Optional(range))
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 120)
                Button("Done") {
                    onDone()
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                )
                .foregroundColor(.white)
                .cornerRadius(16)
                .padding(.horizontal)
                Spacer()
            }
            .padding()
        }
    }
}

struct WorkoutFrequencyCard: View {
    let frequency: WorkoutFrequency
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
                                gradient: Gradient(colors: [frequency.color.opacity(0.7), frequency.color.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 54, height: 54)
                        .shadow(color: frequency.color.opacity(0.18), radius: 6, x: 0, y: 2)
                    Image(systemName: frequency.icon)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(isPressed ? 0.92 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(frequency.rawValue)
                        .font(.headline)
                        .foregroundColor(isSelected ? .white : .primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(frequency.color)
                        .font(.title2)
                        .transition(.scale)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isSelected ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [frequency.color, .purple]), startPoint: .leading, endPoint: .trailing)) : AnyShapeStyle(Color(.systemGray6)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? AnyShapeStyle(frequency.color) : AnyShapeStyle(Color.clear), lineWidth: 2)
            )
            .shadow(color: isSelected ? frequency.color.opacity(0.15) : .clear, radius: 8, x: 0, y: 4)
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
    WorkoutFrequencyView()
} 