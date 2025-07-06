import SwiftUI

struct WorkoutDurationView: View {
    @State private var workoutDuration: Double = 45
    @State private var startTime = Calendar.current.date(from: DateComponents(hour: 6, minute: 0)) ?? Date()
    @State private var endTime = Calendar.current.date(from: DateComponents(hour: 8, minute: 0)) ?? Date()
    @State private var showStartTimePicker = false
    @State private var showEndTimePicker = false
    @State private var navigateToNext = false
    @EnvironmentObject var registrationUser: RegistrationUser
    
    let minValue: Double = 0
    let maxValue: Double = 120
    let step: Double = 5
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Duration Section
                VStack(spacing: 24) {
                    Text("How long do you want your workouts to be?")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.top, 40)
                    
                    // Large duration display
                    HStack(alignment: .lastTextBaseline, spacing: 12) {
                        Text("\(Int(workoutDuration))")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                            )
                            .animation(.spring(), value: workoutDuration)
                        Text("min")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 20)
                    
                    // Single slider
                    SingleSlider(value: $workoutDuration, lowerBound: minValue, upperBound: maxValue, step: step)
                        .frame(height: 60)
                        .padding(.horizontal, 40)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
                
                // Custom Time Range Section
                VStack(spacing: 24) {
                    Text("When do you prefer to train?")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                    
                    Text("Tap to set your preferred training time window")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    // Time range display
                    VStack(spacing: 16) {
                        HStack(spacing: 20) {
                            VStack(spacing: 8) {
                                Text("Start Time")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Button(action: {
                                    showStartTimePicker = true
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "sunrise")
                                            .font(.title2)
                                            .foregroundColor(.orange)
                                        Text(timeFormatter.string(from: startTime))
                                            .font(.system(size: 24, weight: .bold, design: .rounded))
                                            .foregroundStyle(
                                                LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing)
                                            )
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.8)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.orange.opacity(0.1))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                    )
                                }
                            }
                            
                            VStack(spacing: 8) {
                                Text("End Time")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Button(action: {
                                    showEndTimePicker = true
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "sunset")
                                            .font(.title2)
                                            .foregroundColor(.purple)
                                        Text(timeFormatter.string(from: endTime))
                                            .font(.system(size: 24, weight: .bold, design: .rounded))
                                            .foregroundStyle(
                                                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing)
                                            )
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.8)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.purple.opacity(0.1))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                                    )
                                }
                            }
                        }
                        
                        // Time range summary
                        VStack(spacing: 8) {
                            Text("Your Training Window")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("\(timeFormatter.string(from: startTime)) - \(timeFormatter.string(from: endTime))")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]), startPoint: .leading, endPoint: .trailing)
                                        )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .leading, endPoint: .trailing),
                                            lineWidth: 1
                                        )
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
                
                // Continue button
                Button(action: {
                    navigateToNext = true
                    registrationUser.workoutDuration = workoutDuration
                    registrationUser.printProperties(context: "WorkoutDurationView -> AgeSelectionView")
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
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
                
                NavigationLink(destination: AgeSelectionView().environmentObject(registrationUser), isActive: $navigateToNext) {
                    EmptyView()
                }
            }
        }

        .sheet(isPresented: $showStartTimePicker) {
            TimePickerSheet(
                title: "Select Start Time",
                selectedTime: $startTime,
                onDone: { showStartTimePicker = false }
            )
            .presentationDetents([.fraction(0.4)])
        }
        .sheet(isPresented: $showEndTimePicker) {
            TimePickerSheet(
                title: "Select End Time",
                selectedTime: $endTime,
                onDone: { showEndTimePicker = false }
            )
            .presentationDetents([.fraction(0.4)])
        }
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

struct TimePickerSheet: View {
    let title: String
    @Binding var selectedTime: Date
    let onDone: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text(title)
                    .font(.title2)
                    .bold()
                    .padding(.top)
                
                DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
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

// MARK: - Single Slider
struct SingleSlider: View {
    @Binding var value: Double
    let lowerBound: Double
    let upperBound: Double
    let step: Double
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let thumbSize: CGFloat = 32
            let trackHeight: CGFloat = 8
            let minX = thumbSize / 2
            let maxX = width - thumbSize / 2
            let range = upperBound - lowerBound
            let thumbX = minX + CGFloat((value - lowerBound) / range) * (maxX - minX)
            
            ZStack {
                // Background track
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .leading, endPoint: .trailing))
                    .frame(height: trackHeight)
                
                // Filled track (fixed width calculation)
                HStack(spacing: 0) {
                    Capsule()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .frame(width: max(0, thumbX - minX), height: trackHeight)
                    
                    Spacer()
                }
                .frame(width: width)
                
                // Single thumb (dumbbell)
                Image(systemName: "dumbbell")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: thumbSize, height: thumbSize)
                    .foregroundColor(.blue)
                    .background(Circle().fill(Color.white).frame(width: thumbSize + 8, height: thumbSize + 8))
                    .shadow(color: Color.blue.opacity(0.18), radius: 6, x: 0, y: 2)
                    .position(x: thumbX, y: trackHeight / 2 + 8)
                    .gesture(
                        DragGesture()
                            .onChanged { dragValue in
                                let x = min(max(dragValue.location.x, minX), maxX)
                                let percent = (x - minX) / (maxX - minX)
                                let newValue = lowerBound + Double(percent) * range
                                value = min(max(lowerBound, round(newValue / step) * step), upperBound)
                            }
                    )
            }
        }
        .frame(height: 48)
    }
}

//#Preview {
//    WorkoutDurationView()
//}
