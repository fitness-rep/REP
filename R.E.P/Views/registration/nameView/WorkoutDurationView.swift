import SwiftUI

struct WorkoutDurationView: View {
    @State private var minDuration: Double = 40
    @State private var maxDuration: Double = 60
    @State private var frequency: Int = 3
    @State private var showCustomSheet = false
    @State private var selectedCustomRange: CustomFrequencyRange? = nil
    @State private var isCustom = false
    @State private var startTime = Calendar.current.date(from: DateComponents(hour: 6, minute: 0)) ?? Date()
    @State private var endTime = Calendar.current.date(from: DateComponents(hour: 8, minute: 0)) ?? Date()
    @State private var showStartTimePicker = false
    @State private var showEndTimePicker = false
    @State private var navigateToNext = false
    
    let minValue: Double = 30
    let maxValue: Double = 120
    let step: Double = 5
    let minFrequency = 2
    let maxFrequency = 7
    let customRanges: [CustomFrequencyRange] = CustomFrequencyRange.allCases
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Frequency Section
                VStack(spacing: 24) {
                    Text("How often do you want to workout?")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.top, 40)
                    
                    // Large frequency display
                    HStack(spacing: 40) {
                        Button(action: {
                            if frequency > minFrequency {
                                frequency -= 1
                                isCustom = false
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 44, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing)
                                )
                                .opacity(frequency > minFrequency ? 1.0 : 0.3)
                        }
                        .disabled(frequency == minFrequency)
                        
                        VStack(spacing: 8) {
                            if isCustom, let custom = selectedCustomRange {
                                Text(custom.rawValue)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(
                                        LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing)
                                    )
                                    .transition(.opacity)
                            } else {
                                Text("\(frequency)")
                                    .font(.system(size: 64, weight: .bold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing)
                                    )
                                    .transition(.opacity)
                                Text("days per week")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                            }
                            
                            Button(action: {
                                showCustomSheet = true
                            }) {
                                Text("Custom range")
                                    .font(.subheadline)
                                    .foregroundColor(.purple)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.purple.opacity(0.1))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                        
                        Button(action: {
                            if frequency < maxFrequency {
                                frequency += 1
                                isCustom = false
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 44, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing)
                                )
                                .opacity(frequency < maxFrequency ? 1.0 : 0.3)
                        }
                        .disabled(frequency == maxFrequency)
                    }
                    .padding(.vertical, 20)
                    .animation(.spring(), value: frequency)
                    .animation(.spring(), value: isCustom)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
                
                // Duration Section
                VStack(spacing: 24) {
                    Text("How long do you want your workouts to be?")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                    
                    // Large duration display
                    HStack(alignment: .lastTextBaseline, spacing: 12) {
                        Text("\(Int(minDuration))")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .leading, endPoint: .trailing)
                            )
                            .animation(.spring(), value: minDuration)
                        Text("-")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.secondary)
                        Text("\(Int(maxDuration))")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.pink]), startPoint: .leading, endPoint: .trailing)
                            )
                            .animation(.spring(), value: maxDuration)
                        Text("min")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 20)
                    
                    // Range slider
                    RangeSlider(minValue: $minDuration, maxValue: $maxDuration, lowerBound: minValue, upperBound: maxValue, step: step)
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
                Button(action: { navigateToNext = true }) {
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
                
                NavigationLink(destination: AgeSelectionView(), isActive: $navigateToNext) {
                    EmptyView()
                }
            }
        }
        .sheet(isPresented: $showCustomSheet) {
            CustomFrequencyPickerSheet(selectedRange: $selectedCustomRange, onDone: {
                showCustomSheet = false
                if selectedCustomRange != nil {
                    isCustom = true
                }
            })
            .presentationDetents([.fraction(0.35)])
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

// MARK: - Custom Range Slider
struct RangeSlider: View {
    @Binding var minValue: Double
    @Binding var maxValue: Double
    let lowerBound: Double
    let upperBound: Double
    let step: Double
    
    @GestureState private var dragOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let thumbSize: CGFloat = 32
            let trackHeight: CGFloat = 8
            let minX = thumbSize / 2
            let maxX = width - thumbSize / 2
            let range = upperBound - lowerBound
            let minThumbX = minX + CGFloat((minValue - lowerBound) / range) * (maxX - minX)
            let maxThumbX = minX + CGFloat((maxValue - lowerBound) / range) * (maxX - minX)
            ZStack {
                // Track
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .leading, endPoint: .trailing))
                    .frame(height: trackHeight)
                // Selected range
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: maxThumbX - minThumbX, height: trackHeight)
                    .offset(x: (minThumbX + maxThumbX) / 2 - width / 2)
                // Min thumb (dumbbell)
                Image(systemName: "dumbbell")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: thumbSize, height: thumbSize)
                    .foregroundColor(.blue)
                    .background(Circle().fill(Color.white).frame(width: thumbSize + 8, height: thumbSize + 8))
                    .shadow(color: Color.blue.opacity(0.18), radius: 6, x: 0, y: 2)
                    .position(x: minThumbX, y: trackHeight / 2 + 8)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let x = min(max(value.location.x, minX), maxThumbX - thumbSize)
                                let percent = (x - minX) / (maxX - minX)
                                let newValue = lowerBound + Double(percent) * range
                                minValue = min(max(lowerBound, round(newValue / step) * step), maxValue - step)
                            }
                    )
                // Max thumb (kettlebell)
                Image(systemName: "figure.strengthtraining.functional")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: thumbSize, height: thumbSize)
                    .foregroundColor(.purple)
                    .background(Circle().fill(Color.white).frame(width: thumbSize + 8, height: thumbSize + 8))
                    .shadow(color: Color.purple.opacity(0.18), radius: 6, x: 0, y: 2)
                    .position(x: maxThumbX, y: trackHeight / 2 + 8)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let x = max(min(value.location.x, maxX), minThumbX + thumbSize)
                                let percent = (x - minX) / (maxX - minX)
                                let newValue = lowerBound + Double(percent) * range
                                maxValue = max(min(upperBound, round(newValue / step) * step), minValue + step)
                            }
                    )
            }
        }
        .frame(height: 48)
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
                    ForEach(CustomFrequencyRange.allCases, id: \.self) { range in
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

//#Preview {
//    WorkoutDurationView()
//} 