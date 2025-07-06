import SwiftUI

struct CalorieMacrosView: View {
    @State private var navigateToNext = false
    
    // Sample data - in a real app, this would come from previous screens
    let userData = UserNutritionData(
        age: 25,
        weight: 70, // kg
        height: 175, // cm
        gender: "male",
        activityLevel: "moderate",
        fitnessGoal: "weight_loss"
    )
    
    var body: some View {
        VStack(spacing: 0) {
                // Header spacing
                Spacer()
                    .frame(height: 20)
                
                // Calorie Section
                VStack(spacing: 24) {
                    Text("Daily Calorie Target")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.primary)
                    
                    ZStack {
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 8
                            )
                            .frame(width: 200, height: 200)
                        
                        Circle()
                            .trim(from: 0, to: 0.85)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 1.5), value: true)
                        
                        VStack(spacing: 4) {
                            Text("\(calculateDailyCalories())")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Text("calories")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 20)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 20)
                
                // Macros Section
                VStack(spacing: 24) {
                    Text("Macronutrient Breakdown")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.primary)
                    
                    let macros = calculateMacros()
                    
                    VStack(spacing: 16) {
                        // Protein
                        MacroCard(
                            title: "Protein",
                            amount: macros.protein,
                            unit: "g",
                            percentage: macros.proteinPercentage,
                            color: Color.blue,
                            icon: "dumbbell.fill"
                        )
                        
                        // Carbs
                        MacroCard(
                            title: "Carbohydrates",
                            amount: macros.carbs,
                            unit: "g",
                            percentage: macros.carbsPercentage,
                            color: Color.orange,
                            icon: "leaf.fill"
                        )
                        
                        // Fats
                        MacroCard(
                            title: "Fats",
                            amount: macros.fats,
                            unit: "g",
                            percentage: macros.fatsPercentage,
                            color: Color.yellow,
                            icon: "drop.fill"
                        )
                        
                        // Fiber
                        MacroCard(
                            title: "Fiber",
                            amount: macros.fiber,
                            unit: "g",
                            percentage: macros.fiberPercentage,
                            color: Color.green,
                            icon: "leaf.circle.fill"
                        )
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 20)
                
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
                
                NavigationLink(destination: RegistrationView(), isActive: $navigateToNext) {
                    EmptyView()
                }
            }
            .padding(.horizontal)
    }
    
    // Calculate daily calorie needs using Mifflin-St Jeor Equation
    private func calculateDailyCalories() -> Int {
        let bmr: Double
        
        if userData.gender.lowercased() == "male" {
            bmr = (10 * userData.weight) + (6.25 * userData.height) - (5 * Double(userData.age)) + 5
        } else {
            bmr = (10 * userData.weight) + (6.25 * userData.height) - (5 * Double(userData.age)) - 161
        }
        
        // Activity multiplier
        let activityMultiplier: Double
        switch userData.activityLevel {
        case "sedentary":
            activityMultiplier = 1.2
        case "light":
            activityMultiplier = 1.375
        case "moderate":
            activityMultiplier = 1.55
        case "active":
            activityMultiplier = 1.725
        case "very_active":
            activityMultiplier = 1.9
        default:
            activityMultiplier = 1.55
        }
        
        let tdee = bmr * activityMultiplier
        
        // Adjust based on fitness goal
        let adjustedCalories: Double
        switch userData.fitnessGoal {
        case "weight_loss":
            adjustedCalories = tdee - 500 // 500 calorie deficit
        case "weight_gain":
            adjustedCalories = tdee + 300 // 300 calorie surplus
        case "maintenance":
            adjustedCalories = tdee
        default:
            adjustedCalories = tdee
        }
        
        return Int(adjustedCalories)
    }
    
    // Calculate macronutrient breakdown
    private func calculateMacros() -> MacroBreakdown {
        let calories = Double(calculateDailyCalories())
        
        // Protein: 1.6-2.2g per kg for fitness goals
        let proteinPerKg = 2.0
        let protein = userData.weight * proteinPerKg
        let proteinCalories = protein * 4
        let proteinPercentage = (proteinCalories / calories) * 100
        
        // Fats: 20-35% of total calories
        let fatPercentage = 25.0
        let fatCalories = calories * (fatPercentage / 100)
        let fats = fatCalories / 9
        let fatsPercentage = fatPercentage
        
        // Fiber: 25-35g per day
        let fiber = 30.0
        let fiberCalories = fiber * 2 // Rough estimate
        let fiberPercentage = (fiberCalories / calories) * 100
        
        // Carbs: Remaining calories
        let carbCalories = calories - proteinCalories - fatCalories
        let carbs = carbCalories / 4
        let carbsPercentage = (carbCalories / calories) * 100
        
        return MacroBreakdown(
            protein: Int(protein),
            carbs: Int(carbs),
            fats: Int(fats),
            fiber: Int(fiber),
            proteinPercentage: proteinPercentage,
            carbsPercentage: carbsPercentage,
            fatsPercentage: fatsPercentage,
            fiberPercentage: fiberPercentage
        )
    }
}

// Supporting Views
struct MacroCard: View {
    let title: String
    let amount: Int
    let unit: String
    let percentage: Double
    let color: Color
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("\(amount) \(unit)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(percentage))%")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("of daily")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

// Data Models
struct UserNutritionData {
    let age: Int
    let weight: Double // kg
    let height: Double // cm
    let gender: String
    let activityLevel: String
    let fitnessGoal: String
}

struct MacroBreakdown {
    let protein: Int
    let carbs: Int
    let fats: Int
    let fiber: Int
    let proteinPercentage: Double
    let carbsPercentage: Double
    let fatsPercentage: Double
    let fiberPercentage: Double
}

//#Preview {
//    CalorieMacrosView()
//} 