import SwiftUI

struct AgeSelectionView: View {
    @State private var age: Double = 25
    @State private var height: Double = 175
    @State private var weight: Double = 70
    @State private var heightUnit: HeightUnit = .cm
    @State private var weightUnit: WeightUnit = .kg
    @State private var navigateToNext = false
    let minAge: Double = 12
    let maxAge: Double = 100
    let step: Double = 1
    
    // BMI calculation
    var bmi: Double {
        let heightInMeters: Double
        if heightUnit == .cm {
            heightInMeters = height / 100
        } else {
            // Convert feet to meters: feet * 12 inches/foot * 0.0254 meters/inch
            heightInMeters = height * 12 * 0.0254
        }
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
        VStack(spacing: 0) {
                            // Age Section
                VStack(spacing: 20) {
                    Text("Age")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.top, 30)
                
                                    // Ruler picker for age
                    ScrollableRulerPicker(
                        value: $age,
                        minValue: minAge,
                        maxValue: maxAge,
                        step: step,
                        color: .blue,
                        unit: "years",
                        displayPrecision: 0,
                        width: UIScreen.main.bounds.width - 80
                    )
                    .frame(height: 120)
                    .padding(.horizontal, 20)
                            }
                .padding(.horizontal, 32)
                .padding(.bottom, 30)
                
                // Height Section
                VStack(spacing: 20) {
                    HStack {
                        Text("Height")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        // Unit toggle button
                        Button(action: {
                            if heightUnit == .cm {
                                heightUnit = .feet
                                // Convert cm to feet for display
                                height = height / 30.48
                            } else {
                                heightUnit = .cm
                                // Convert feet to cm for display
                                height = height * 30.48
                            }
                        }) {
                            Text(heightUnit == .cm ? "ft" : "cm")
                                .font(.caption)
                                .foregroundColor(heightUnit == .cm ? .blue : .green)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill((heightUnit == .cm ? Color.blue : Color.green).opacity(0.1))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke((heightUnit == .cm ? Color.blue : Color.green).opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    // Ruler picker for height
                    ScrollableRulerPicker(
                        value: $height,
                        minValue: heightUnit == .cm ? 91.44 : 3.0,
                        maxValue: heightUnit == .cm ? 304.8 : 10.0,
                        step: heightUnit == .cm ? 1 : 0.1,
                        color: .green,
                        unit: heightUnit == .cm ? "cm" : "ft",
                        displayPrecision: heightUnit == .cm ? 0 : 1,
                        width: UIScreen.main.bounds.width - 80
                    )
                    .frame(height: 120)
                    .padding(.horizontal, 20)
                    .onAppear {
                        // Ensure height is within valid range
                        if heightUnit == .cm {
                            height = min(max(height, 91.44), 304.8)
                        } else {
                            height = min(max(height, 3.0), 10.0)
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 30)
                
                // Weight Section
                VStack(spacing: 20) {
                    HStack {
                        Text("Weight")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        // Unit toggle button
                        Button(action: {
                            if weightUnit == .kg {
                                weightUnit = .lbs
                                // Convert kg to lbs for display
                                weight = weight * 2.20462
                            } else {
                                weightUnit = .kg
                                // Convert lbs to kg for display
                                weight = weight / 2.20462
                            }
                        }) {
                            Text(weightUnit == .kg ? "lbs" : "kg")
                                .font(.caption)
                                .foregroundColor(weightUnit == .kg ? .orange : .red)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill((weightUnit == .kg ? Color.orange : Color.red).opacity(0.1))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke((weightUnit == .kg ? Color.orange : Color.red).opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    // Ruler picker for weight
                    ScrollableRulerPicker(
                        value: $weight,
                        minValue: weightUnit == .kg ? 1 : 2.2,
                        maxValue: weightUnit == .kg ? 300 : 660,
                        step: 1,
                        color: .orange,
                        unit: weightUnit == .kg ? "kg" : "lbs",
                        displayPrecision: 0,
                        width: UIScreen.main.bounds.width - 80
                    )
                    .frame(height: 120)
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 30)
                

                
                Spacer()
                
                // BMI Section
                HStack {
                    Text("Your BMI - \(String(format: "%.1f", bmi)) \(bmiCategory)")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 16)
                
                // Continue button
                Button(action: { navigateToNext = true }) {
                    Text("Continue")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(20)
                        .shadow(color: .purple.opacity(0.4), radius: 12, x: 0, y: 6)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
                
                NavigationLink(destination: TargetWeightView(), isActive: $navigateToNext) {
                    EmptyView()
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
            
            let (minHeight, maxHeight) = unit == .cm ? (10.0, 250.0) : (0.33 * 30.48, 8.2 * 30.48) // 4 inches to 8ft 2in in cm
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

struct HorizontalScaleSlider: View {
    @Binding var value: Double
    let minValue: Double
    let maxValue: Double
    let step: Double
    let color: Color
    var displayValue: String?
    @State private var isDragging: Bool = false
    
    private var formattedValue: String {
        if let displayValue = displayValue {
            return displayValue
        }
        return "\(Int(value))"
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let thumbSize: CGFloat = 44
            let trackHeight: CGFloat = 8
            let minX = thumbSize / 2
            let maxX = width - thumbSize / 2
            let range = maxValue - minValue
            let thumbX = minX + CGFloat((value - minValue) / range) * (maxX - minX)
            
            VStack(spacing: 20) {
                // Value display in the middle
                Text(formattedValue)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(gradient: Gradient(colors: [color, color.opacity(0.7)]), startPoint: .leading, endPoint: .trailing)
                    )
                    .animation(.spring(), value: value)
                
                // Scale with tick marks
                ZStack {
                    // Background track
                    Capsule()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: trackHeight)
                    
                    // Progress track
                    Capsule()
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [color, color.opacity(0.7)]), startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: thumbX - minX, height: trackHeight)
                        .offset(x: minX - width / 2)
                    
                    // Tick marks (4 small + 1 big pattern)
                    HStack(spacing: 0) {
                        ForEach(0..<Int((maxValue - minValue) / step) + 1, id: \.self) { index in
                            let tickValue = minValue + Double(index) * step
                            let tickX = minX + CGFloat((tickValue - minValue) / range) * (maxX - minX)
                            
                            Rectangle()
                                .fill(index % 5 == 0 ? color : Color.gray.opacity(0.6))
                                .frame(width: index % 5 == 0 ? 3 : 1, height: index % 5 == 0 ? 20 : 12)
                                .position(x: tickX, y: trackHeight / 2 + 15)
                        }
                    }
                    
                    // Thumb
                    Circle()
                        .fill(Color.white)
                        .frame(width: thumbSize, height: thumbSize)
                        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
                        .overlay(
                            Circle()
                                .stroke(color, lineWidth: 3)
                        )
                        .position(x: thumbX, y: trackHeight / 2 + 8)
                        .gesture(
                            DragGesture()
                                .onChanged { dragValue in
                                    isDragging = true
                                    let x = min(max(dragValue.location.x, minX), maxX)
                                    let percent = (x - minX) / (maxX - minX)
                                    let newValue = minValue + Double(percent) * range
                                    value = min(max(minValue, round(newValue / step) * step), maxValue)
                                }
                                .onEnded { _ in
                                    isDragging = false
                                }
                        )
                }
            }
        }
        .frame(height: 120)
    }
}

struct ScrollableRulerPicker: View {
    @Binding var value: Double
    let minValue: Double
    let maxValue: Double
    let step: Double
    let color: Color
    let unit: String
    let displayPrecision: Int
    let width: CGFloat
    let tickSpacing: CGFloat = 16
    let majorTickHeight: CGFloat = 32
    let minorTickHeight: CGFloat = 16
    let fadeWidth: CGFloat = 48

    @State private var scrollOffset: CGFloat = 0
    @GestureState private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false

    private var totalTicks: Int { Int((maxValue - minValue) / step) + 1 }
    private var totalWidth: CGFloat { CGFloat(totalTicks - 1) * tickSpacing + width }

    var body: some View {
        VStack(spacing: 0) {
            // Value display
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(String(format: "%.\(displayPrecision)f", value))
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Text(unit)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 8)

            ZStack {
                // Ruler
                ScrollView(.horizontal, showsIndicators: false) {
                    ZStack(alignment: .topLeading) {
                        HStack(spacing: 0) {
                            ForEach(0..<totalTicks, id: \.self) { i in
                                let tickValue = minValue + Double(i) * step
                                VStack(spacing: 0) {
                                    Rectangle()
                                        .fill(i % 5 == 0 ? color : Color.gray.opacity(0.5))
                                        .frame(width: i % 5 == 0 ? 2 : 1, height: i % 5 == 0 ? majorTickHeight : minorTickHeight)
                                    Spacer().frame(height: 0)
                                }
                                .frame(width: tickSpacing)
                            }
                        }
                        .padding(.horizontal, width/2 - tickSpacing/2)
                    }
                }
                .content.offset(x: scrollOffset + dragOffset)
                .frame(width: width, height: majorTickHeight + 24)
                .gesture(
                    DragGesture()
                        .onChanged { _ in
                            isDragging = true
                        }
                        .updating($dragOffset) { value, state, _ in
                            let maxScrollOffset: CGFloat = 0
                            let minScrollOffset = -CGFloat((maxValue - minValue) / step) * tickSpacing
                            let newOffset = scrollOffset + value.translation.width
                            let clampedOffset = min(maxScrollOffset, max(minScrollOffset, newOffset))
                            state = clampedOffset - scrollOffset
                            
                            // Update value in real-time during drag
                            let totalDrag = scrollOffset + value.translation.width
                            let tickFloat = -totalDrag / tickSpacing
                            let nearestTick = round(tickFloat)
                            let newValue = min(max(minValue, minValue + nearestTick * step), maxValue)
                            self.value = newValue
                        }
                        .onEnded { value in
                            isDragging = false
                            let totalDrag = scrollOffset + value.translation.width
                            let tickFloat = -totalDrag / tickSpacing
                            let nearestTick = round(tickFloat)
                            let newValue = min(max(minValue, minValue + nearestTick * step), maxValue)
                            let maxScrollOffset: CGFloat = 0
                            let minScrollOffset = -CGFloat((maxValue - minValue) / step) * tickSpacing
                            let newScrollOffset = -CGFloat((newValue - minValue) / step) * tickSpacing
                            let clampedScrollOffset = min(maxScrollOffset, max(minScrollOffset, newScrollOffset))
                            
                            withAnimation(.spring()) {
                                self.value = newValue
                                scrollOffset = clampedScrollOffset
                            }
                        }
                )
                                        .onAppear {
                            // Center the initial value
                            let initialOffset = -CGFloat((value - minValue) / step) * tickSpacing
                            let maxScrollOffset: CGFloat = 0
                            let minScrollOffset = -CGFloat((maxValue - minValue) / step) * tickSpacing
                            scrollOffset = min(maxScrollOffset, max(minScrollOffset, initialOffset))
                        }
                        .onChange(of: value) { newValue in
                            if !isDragging {
                                let newOffset = -CGFloat((newValue - minValue) / step) * tickSpacing
                                let maxScrollOffset: CGFloat = 0
                                let minScrollOffset = -CGFloat((maxValue - minValue) / step) * tickSpacing
                                scrollOffset = min(maxScrollOffset, max(minScrollOffset, newOffset))
                            }
                        }

                // Center highlight line
                Rectangle()
                    .fill(color)
                    .frame(width: 2, height: majorTickHeight + 16)
                    .position(x: width/2, y: (majorTickHeight + 24)/2)

                // Fading edges removed for cleaner appearance
            }
        }
    }
}

#Preview {
    AgeSelectionView()
} 
