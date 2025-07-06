//
//  ProgressCalendarView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/4/25.
//

import SwiftUI

struct ProgressCalendarView: View {
    @State private var selectedDate = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E MMM d"
        return formatter
    }()
    
    // Ensure we always start with today
    private var displayText: String {
        if calendar.isDateInToday(selectedDate) {
            return "Today"
        } else {
            return dateFormatter.string(from: selectedDate)
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Left arrow
            Button(action: { 
                selectedDate = calendar.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.1))
                    )
            }
            
            // Date display
            Text(displayText)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(width: 100, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
            
            // Right arrow
            Button(action: { 
                let nextDate = calendar.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                let today = Date()
                // Allow going forward to today, but not beyond
                if nextDate <= today {
                    selectedDate = nextDate
                }
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(calendar.isDateInToday(selectedDate) ? .white.opacity(0.3) : .white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.1))
                    )
            }
            .disabled(calendar.isDateInToday(selectedDate))
        }
        .padding(.horizontal, 20)
        .onAppear {
            // Ensure we always start with today
            selectedDate = Date()
        }
    }
}

struct TodayProgressCard: View {
    @ObservedObject var dailyProgress: DailyProgressViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Today's Progress")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Overall progress indicator
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 4)
                        .frame(width: 40, height: 40)
                    
                    Circle()
                        .trim(from: 0, to: (dailyProgress.caloriesProgress + dailyProgress.workoutProgress) / 2)
                        .stroke(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 40, height: 40)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.0), value: dailyProgress.caloriesProgress)
                    
                    Text("\(Int((dailyProgress.caloriesProgress + dailyProgress.workoutProgress) / 2 * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            
            // Progress bars
            VStack(spacing: 12) {
                ProgressBarRow(
                    title: "Calories",
                    current: Int(dailyProgress.caloriesConsumed),
                    target: Int(dailyProgress.caloriesTarget),
                    progress: dailyProgress.caloriesProgress,
                    color: .blue,
                    icon: "flame.fill"
                )
                
                ProgressBarRow(
                    title: "Workout",
                    current: Int(dailyProgress.workoutMinutesCompleted),
                    target: Int(dailyProgress.workoutMinutesTarget),
                    progress: dailyProgress.workoutProgress,
                    color: .green,
                    icon: "figure.strengthtraining.traditional"
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.1),
                            Color.white.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct ProgressBarRow: View {
    let title: String
    let current: Int
    let target: Int
    let progress: Double
    let color: Color
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(current)/\(target)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [color, color.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progress, height: 6)
                            .animation(.easeInOut(duration: 1.0), value: progress)
                    }
                }
                .frame(height: 6)
            }
        }
    }
}

struct WeeklyProgressGrid: View {
    let historicalData: [Date: DayProgress]
    @Binding var selectedDate: Date
    
    private let calendar = Calendar.current
    private let daysInWeek = 7
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("This Week")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(0..<daysInWeek, id: \.self) { dayOffset in
                    let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date())!
                    let isToday = calendar.isDateInToday(date)
                    let progress = historicalData[date]?.goal ?? 0.0
                    
                    DayProgressCell(
                        date: date,
                        progress: progress,
                        isToday: isToday,
                        isSelected: calendar.isDate(selectedDate, inSameDayAs: date)
                    ) {
                        selectedDate = date
                    }
                }
            }
        }
    }
}

struct DayProgressCell: View {
    let date: Date
    let progress: Double
    let isToday: Bool
    let isSelected: Bool
    let action: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                // Day of week
                Text(calendar.veryShortWeekdaySymbols[calendar.component(.weekday, from: date) - 1])
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(isToday ? .white : .white.opacity(0.6))
                
                // Progress circle
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 2)
                        .frame(width: 32, height: 32)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            LinearGradient(
                                colors: progress > 0.8 ? [.green, .green.opacity(0.7)] :
                                       progress > 0.6 ? [.orange, .orange.opacity(0.7)] :
                                       [.red, .red.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 2, lineCap: .round)
                        )
                        .frame(width: 32, height: 32)
                        .rotationEffect(.degrees(-90))
                    
                    // Day number
                    Text("\(calendar.component(.day, from: date))")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(isToday ? .white : .white.opacity(0.8))
                }
                
                // Progress percentage
                Text("\(Int(progress * 100))%")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(
                        progress > 0.8 ? .green :
                        progress > 0.6 ? .orange : .red
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    isSelected ? Color.white.opacity(0.2) :
                    isToday ? Color.white.opacity(0.1) :
                    Color.clear
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isSelected ? Color.white.opacity(0.4) :
                            isToday ? Color.white.opacity(0.3) :
                            Color.clear,
                            lineWidth: 1
                        )
                )
        )
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Select Date")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .colorScheme(.dark)
                    .accentColor(.blue)
                    
                    Button("Done") {
                        dismiss()
                    }
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)
                    )
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct DayProgress {
    let calories: Int
    let workout: Int
    let goal: Double
}

extension DateFormatter {
    static let calendarDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter
    }()
} 