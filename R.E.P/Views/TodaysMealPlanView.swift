//
//  TodaysMealPlanView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/4/25.
//

import SwiftUI

struct TodaysMealPlanView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var dailyProgress: DailyProgress
    @State private var showingLogMeal = false
    
    // Sample meal plan data - in a real app, this would come from a database
    private let todaysMeals = [
        MealPlanItem(name: "Oatmeal with Berries", calories: 350, time: "8:00 AM", type: "Breakfast", isCompleted: false),
        MealPlanItem(name: "Grilled Chicken Salad", calories: 450, time: "12:30 PM", type: "Lunch", isCompleted: false),
        MealPlanItem(name: "Greek Yogurt with Nuts", calories: 200, time: "3:00 PM", type: "Snack", isCompleted: false),
        MealPlanItem(name: "Salmon with Vegetables", calories: 550, time: "7:00 PM", type: "Dinner", isCompleted: false)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Today's Meal Plan")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Your personalized nutrition plan for today")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top)
                    
                    // Progress Summary
                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Calories Consumed")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text("\(Int(dailyProgress.caloriesConsumed)) / \(Int(dailyProgress.caloriesTarget))")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Progress")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text("\(Int(dailyProgress.caloriesProgress * 100))%")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                        }
                        
                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white.opacity(0.2))
                                    .frame(height: 8)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .green],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * dailyProgress.caloriesProgress, height: 8)
                                    .animation(.easeInOut(duration: 1.0), value: dailyProgress.caloriesProgress)
                            }
                        }
                        .frame(height: 8)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                    )
                    .padding(.horizontal)
                    
                    // Meal List
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(todaysMeals, id: \.id) { meal in
                                MealPlanCard(meal: meal) {
                                    // Mark meal as completed
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: { showingLogMeal = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Text("Log Additional Meal")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
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
                        
                        Button("Close") {
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
        .sheet(isPresented: $showingLogMeal) {
            LogMealView(dailyProgress: dailyProgress)
        }
    }
}

struct MealPlanCard: View {
    let meal: MealPlanItem
    let onComplete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Meal icon
            ZStack {
                Circle()
                    .fill(meal.isCompleted ? Color.green.opacity(0.2) : Color.blue.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: meal.isCompleted ? "checkmark.circle.fill" : "fork.knife")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(meal.isCompleted ? .green : .blue)
            }
            
            // Meal details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(meal.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(meal.time)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.6))
                }
                
                HStack {
                    Text(meal.type)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Text("\(meal.calories) cal")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
            
            // Complete button
            Button(action: onComplete) {
                Image(systemName: meal.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(meal.isCompleted ? .green : .white.opacity(0.6))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(meal.isCompleted ? Color.green.opacity(0.3) : Color.clear, lineWidth: 1)
                )
        )
    }
}

struct MealPlanItem {
    let id = UUID()
    let name: String
    let calories: Int
    let time: String
    let type: String
    var isCompleted: Bool
}

#Preview {
    TodaysMealPlanView(dailyProgress: DailyProgress(userData: RegistrationData()))
} 