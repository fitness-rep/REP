import SwiftUI

struct AgeSelectionView: View {
    @State private var age: Double = 25
    @State private var height: Double = 170
    @State private var weight: Double = 70
    @State private var heightUnit: HeightUnit = .cm
    @State private var weightUnit: WeightUnit = .kg
    @State private var navigateToNext = false
    let minAge: Double = 13
    let maxAge: Double = 80
    let step: Double = 1
    
    // BMI calculation
    var bmi: Double {
        let heightInMeters = heightUnit == .cm ? height / 100 : height / 39.37
        let weightInKg = weightUnit == .kg ? weight : weight / 2.20462
        return weightInKg / (heightInMeters * heightInMeters)
    }
    
    var bmiCategory: String {
        switch bmi {
        case ..<18.5: return "Underweight"
        case 18.5..<25: return "Normal"
        case 25..<30: return "Overweight"
        default: return "Obese"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Age Section
                VStack(spacing: 24) {
                    Text("What's your age?")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.top, 40)
                    
                    // Large animated age display
                    Text("\(Int(age))")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                        )
                        .animation(.spring(), value: age)
                        .padding(.bottom, 20)
                    
                    // Custom horizontal slider
                    AgeSlider(age: $age, minAge: minAge, maxAge: maxAge, step: step)
                        .frame(height: 60)
                        .padding(.horizontal, 40)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
                
                // Height Section
                VStack(spacing: 24) {
                    Text("What's your height?")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                    
                    // Height display with unit toggle
                    VStack(spacing: 16) {
                        Text(heightUnit == .cm ? "\(Int(height)) cm" : "\(Int(height / 30.48))' \(Int((height.truncatingRemainder(dividingBy: 30.48)) / 2.54))\"")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing)
                            )
                            .animation(.spring(), value: height)
                            .animation(.spring(), value: heightUnit)
                        
                        // Unit toggle button
                        Button(action: { heightUnit = heightUnit == .cm ? .feet : .cm }) {
                            HStack(spacing: 8) {
                                Image(systemName: heightUnit == .cm ? "ruler" : "ruler.fill")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Switch to \(heightUnit == .cm ? "Feet/Inches" : "Centimeters")")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.blue.opacity(0.1))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Height slider
                    HeightSlider(height: $height, unit: heightUnit)
                        .frame(height: 60)
                        .padding(.horizontal, 40)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
                
                // Weight Section
                VStack(spacing: 24) {
                    Text("How much do you weigh?")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                    
                    // Weight display with unit toggle
                    VStack(spacing: 16) {
                        Text(weightUnit == .kg ? "\(Int(weight)) kg" : "\(Int(weight * 2.20462)) lbs")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing)
                            )
                            .animation(.spring(), value: weight)
                            .animation(.spring(), value: weightUnit)
                        
                        // Unit toggle button
                        Button(action: { weightUnit = weightUnit == .kg ? .lbs : .kg }) {
                            HStack(spacing: 8) {
                                Image(systemName: weightUnit == .kg ? "scalemass" : "scalemass.fill")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Switch to \(weightUnit == .kg ? "Pounds" : "Kilograms")")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.orange)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.orange.opacity(0.1))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Weight slider
                    WeightSlider(weight: $weight, unit: weightUnit)
                        .frame(height: 60)
                        .padding(.horizontal, 40)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
                
                // BMI Section
                VStack(spacing: 16) {
                    Text("Your BMI")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 16) {
                        VStack(spacing: 4) {
                            Text(String(format: "%.1f", bmi))
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing)
                                )
                            Text("BMI")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Text(bmiCategory)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Text("Category")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                    )
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
                
                NavigationLink(destination: FoodPreferenceView(), isActive: $navigateToNext) {
                    EmptyView()
                }
            }
        }
    }
}

// Height Unit Enum
enum HeightUnit: CaseIterable {
    case cm, feet
    
    var displayText: String {
        switch self {
        case .cm: return "Centimeters"
        case .feet: return "Feet/Inches"
        }
    }
}

// Weight Unit Enum
enum WeightUnit: CaseIterable {
    case kg, lbs
    
    var displayText: String {
        switch self {
        case .kg: return "Kilograms"
        case .lbs: return "Pounds"
        }
    }
}

struct HeightSlider: View {
    @Binding var height: Double
    let unit: HeightUnit
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let thumbSize: CGFloat = 44
            let trackHeight: CGFloat = 10
            let minX = thumbSize / 2
            let maxX = width - thumbSize / 2
            
            let (minHeight, maxHeight) = unit == .cm ? (120.0, 220.0) : (4.0 * 30.48, 7.0 * 30.48) // 4ft to 7ft in cm
            let range = maxHeight - minHeight
            let thumbX = minX + CGFloat((height - minHeight) / range) * (maxX - minX)
            
            ZStack {
                // Track
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.3), Color.blue.opacity(0.3)]), startPoint: .leading, endPoint: .trailing))
                    .frame(height: trackHeight)
                
                // Progress
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: thumbX - minX, height: trackHeight)
                    .offset(x: (minX + thumbX) / 2 - width / 2)
                
                // Thumb (ruler icon)
                Image(systemName: "ruler")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: thumbSize, height: thumbSize)
                    .foregroundColor(.green)
                    .background(Circle().fill(Color.white).frame(width: thumbSize + 10, height: thumbSize + 10))
                    .shadow(color: Color.green.opacity(0.18), radius: 6, x: 0, y: 2)
                    .position(x: thumbX, y: trackHeight / 2 + 10)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let x = min(max(value.location.x, minX), maxX)
                                let percent = (x - minX) / (maxX - minX)
                                let newValue = minHeight + Double(percent) * range
                                height = min(max(minHeight, round(newValue)), maxHeight)
                            }
                    )
            }
        }
        .frame(height: 60)
    }
}

struct WeightSlider: View {
    @Binding var weight: Double
    let unit: WeightUnit
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let thumbSize: CGFloat = 44
            let trackHeight: CGFloat = 10
            let minX = thumbSize / 2
            let maxX = width - thumbSize / 2
            
            let (minWeight, maxWeight) = unit == .kg ? (30.0, 150.0) : (66.0, 330.0) // 66 lbs to 330 lbs
            let range = maxWeight - minWeight
            let thumbX = minX + CGFloat((weight - minWeight) / range) * (maxX - minX)
            
            ZStack {
                // Track
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(0.3), Color.red.opacity(0.3)]), startPoint: .leading, endPoint: .trailing))
                    .frame(height: trackHeight)
                
                // Progress
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: thumbX - minX, height: trackHeight)
                    .offset(x: (minX + thumbX) / 2 - width / 2)
                
                // Thumb (scalemass icon)
                Image(systemName: "scalemass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: thumbSize, height: thumbSize)
                    .foregroundColor(.orange)
                    .background(Circle().fill(Color.white).frame(width: thumbSize + 10, height: thumbSize + 10))
                    .shadow(color: Color.orange.opacity(0.18), radius: 6, x: 0, y: 2)
                    .position(x: thumbX, y: trackHeight / 2 + 10)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let x = min(max(value.location.x, minX), maxX)
                                let percent = (x - minX) / (maxX - minX)
                                let newValue = minWeight + Double(percent) * range
                                weight = min(max(minWeight, round(newValue)), maxWeight)
                            }
                    )
            }
        }
        .frame(height: 60)
    }
}

struct AgeSlider: View {
    @Binding var age: Double
    let minAge: Double
    let maxAge: Double
    let step: Double
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let thumbSize: CGFloat = 44
            let trackHeight: CGFloat = 10
            let minX = thumbSize / 2
            let maxX = width - thumbSize / 2
            let range = maxAge - minAge
            let thumbX = minX + CGFloat((age - minAge) / range) * (maxX - minX)
            ZStack {
                // Track
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .leading, endPoint: .trailing))
                    .frame(height: trackHeight)
                // Progress
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: thumbX - minX, height: trackHeight)
                    .offset(x: (minX + thumbX) / 2 - width / 2)
                // Thumb (stair stepper)
                Image(systemName: "figure.stair.stepper")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: thumbSize, height: thumbSize)
                    .foregroundColor(.blue)
                    .background(Circle().fill(Color.white).frame(width: thumbSize + 10, height: thumbSize + 10))
                    .shadow(color: Color.blue.opacity(0.18), radius: 6, x: 0, y: 2)
                    .position(x: thumbX, y: trackHeight / 2 + 10)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let x = min(max(value.location.x, minX), maxX)
                                let percent = (x - minX) / (maxX - minX)
                                let newValue = minAge + Double(percent) * range
                                age = min(max(minAge, round(newValue / step) * step), maxAge)
                            }
                    )
            }
        }
        .frame(height: 60)
    }
}

#Preview {
    AgeSelectionView()
} 