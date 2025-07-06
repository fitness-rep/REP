//
//  LogMealView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/4/25.
//

import SwiftUI

struct LogMealView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var dailyProgress: DailyProgressViewModel
    @State private var mealName = ""
    @State private var calories = ""
    @State private var selectedMealType = MealType.breakfast
    
    enum MealType: String, CaseIterable {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case snack = "Snack"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Log Your Meal")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Track your nutrition to stay on target")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top)
                    
                    // Meal Type Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Meal Type")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(MealType.allCases, id: \.self) { mealType in
                                MealTypeButton(
                                    title: mealType.rawValue,
                                    isSelected: selectedMealType == mealType
                                ) {
                                    selectedMealType = mealType
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Meal Details
                    VStack(spacing: 20) {
                        // Meal Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Meal Name")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            TextField("e.g., Grilled Chicken Salad", text: $mealName)
                                .textFieldStyle(CustomTextFieldStyle(accentColor: .blue))
                        }
                        
                        // Calories
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Calories")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            TextField("Enter calories", text: $calories)
                                .textFieldStyle(CustomTextFieldStyle(accentColor: .blue))
                                .keyboardType(.numberPad)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Current Progress Preview
                    VStack(spacing: 16) {
                        Text("Today's Progress")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 20) {
                            VStack(spacing: 4) {
                                Text("\(Int(dailyProgress.caloriesConsumed))")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                
                                Text("Consumed")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            VStack(spacing: 4) {
                                Text("\(Int(dailyProgress.caloriesTarget))")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Target")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            VStack(spacing: 4) {
                                Text("\(Int(dailyProgress.caloriesRemaining))")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                
                                Text("Remaining")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                    )
                    .padding(.horizontal)
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: logMeal) {
                            Text("Log Meal")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            LinearGradient(
                                                colors: [.blue, .blue.opacity(0.8)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                )
                        }
                        .disabled(mealName.isEmpty || calories.isEmpty)
                        
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func logMeal() {
        guard let caloriesValue = Double(calories), caloriesValue > 0 else { return }
        
        dailyProgress.logCalories(caloriesValue)
        dismiss()
    }
}

struct MealTypeButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.blue : Color.white.opacity(0.1))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}



//#Preview {
//    LogMealView(dailyProgress: DailyProgressViewModel(userId: "preview", date: Date(), userData: RegistrationUser()))
//} 