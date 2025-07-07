//
//  TrainingFocusView.swift
//  R.E.P
//
//  Created by KISHORE BANDARU on 7/6/25.
//

import SwiftUI

struct TrainingFocusView: View {
    @State private var selectedAreas: Set<TrainingArea> = []
    @State private var navigateToNext = false
    
    @EnvironmentObject var registrationUser: RegistrationUser
    
    let columns = [
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("What areas need improvement?")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.top, 20)
                .padding(.bottom, 20)
                .padding(.horizontal, 24)
            
            Spacer(minLength: 16)
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(TrainingArea.allCases, id: \ .self) { area in
                    TrainingFocusCard(area: area, isSelected: selectedAreas.contains(area)) {
                        if selectedAreas.contains(area) {
                            selectedAreas.remove(area)
                        } else {
                            selectedAreas.insert(area)
                        }
                    }
                }
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 20)
            
            Spacer(minLength: 20)
            
            Button(action: { 
                navigateToNext = true
                registrationUser.trainingFocusAreas = Set(selectedAreas.map { $0.rawValue })
                registrationUser.printProperties(context: "TrainingFocusView -> FoodPreferenceView")
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
            .padding(.bottom, 24)
            
            NavigationLink(destination: FoodPreferenceView().environmentObject(registrationUser), isActive: $navigateToNext) {
                EmptyView()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.black)
    }
}

enum TrainingArea: String, CaseIterable {
    case fullBody = "Full Body"
    case shoulders = "Shoulders"
    case arms = "Arms"
    case back = "Back"
    case chest = "Chest"
    case belly = "Belly"
    case butt = "Butt"
    case legs = "Legs"
    
    var label: String { self.rawValue }
}

struct TrainingFocusCard: View {
    let area: TrainingArea
    let isSelected: Bool
    let onTap: () -> Void
    
    private var imageName: String {
        switch area {
        case .fullBody: return "focus_fullbody"
        case .shoulders: return "focus_shoulders"
        case .arms: return "focus_arms"
        case .back: return "focus_back"
        case .chest: return "focus_chest"
        case .belly: return "focus_belly"
        case .butt: return "focus_butt"
        case .legs: return "focus_legs"
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.black)
                        .frame(width: 120, height: 120)
                        .shadow(color: isSelected ? Color.purple.opacity(0.3) : Color.white.opacity(0.1), radius: 8, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(
                                    isSelected ?
                                        AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                        : AnyShapeStyle(Color.white.opacity(0.2)),
                                    lineWidth: 2
                                )
                        )
                    if area == .fullBody {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 110, height: 110)
                            .clipped()
                    } else {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 96, height: 96)
                            .clipped()
                    }
                }
                Text(area.label)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .frame(height: 20)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Example vector icons
struct FullBodyIcon: View {
    var body: some View {
        ZStack {
            HumanOutline()
            HighlightArms()
            HighlightChest()
            HighlightAbs()
            HighlightLegs()
        }
    }
}

struct ShouldersIcon: View {
    var body: some View {
        ZStack {
            HumanOutline()
            HighlightShoulders()
        }
    }
}

struct ArmsIcon: View {
    var body: some View {
        ZStack {
            HumanOutline()
            HighlightArms()
        }
    }
}

struct BackIcon: View {
    var body: some View {
        ZStack {
            HumanOutline()
            HighlightBack()
        }
    }
}

struct ChestIcon: View {
    var body: some View {
        ZStack {
            HumanOutline()
            HighlightChest()
        }
    }
}

struct BellyIcon: View {
    var body: some View {
        ZStack {
            HumanOutline()
            HighlightAbs()
        }
    }
}

struct ButtIcon: View {
    var body: some View {
        ZStack {
            HumanOutline()
            HighlightButt()
        }
    }
}

struct LegsIcon: View {
    var body: some View {
        ZStack {
            HumanOutline()
            HighlightLegs()
        }
    }
}

// Human outline (simple stylized body)
struct HumanOutline: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(Color.gray.opacity(0.4), lineWidth: 2)
            .frame(width: 60, height: 80)
    }
}

// Highlights (simple blue shapes for each muscle group)
struct HighlightShoulders: View {
    var body: some View {
        HStack(spacing: 16) {
            Circle().fill(Color.blue).frame(width: 16, height: 16).offset(x: -10, y: -18)
            Circle().fill(Color.blue).frame(width: 16, height: 16).offset(x: 10, y: -18)
        }
    }
}

struct HighlightArms: View {
    var body: some View {
        HStack(spacing: 24) {
            Capsule().fill(Color.blue).frame(width: 10, height: 32).offset(x: -18, y: 0)
            Capsule().fill(Color.blue).frame(width: 10, height: 32).offset(x: 18, y: 0)
        }
    }
}

struct HighlightChest: View {
    var body: some View {
        HStack(spacing: 0) {
            Capsule().fill(Color.blue).frame(width: 16, height: 18).offset(x: -8, y: -10)
            Capsule().fill(Color.blue).frame(width: 16, height: 18).offset(x: 8, y: -10)
        }
    }
}

struct HighlightBack: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 30, y: 20))
            path.addLine(to: CGPoint(x: 10, y: 40))
            path.addLine(to: CGPoint(x: 50, y: 40))
            path.closeSubpath()
        }
        .fill(Color.blue.opacity(0.8))
        .frame(width: 60, height: 80)
    }
}

struct HighlightAbs: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.blue)
            .frame(width: 18, height: 28)
            .offset(y: 10)
    }
}

struct HighlightButt: View {
    var body: some View {
        HStack(spacing: 8) {
            Ellipse().fill(Color.blue).frame(width: 14, height: 18).offset(x: -8, y: 18)
            Ellipse().fill(Color.blue).frame(width: 14, height: 18).offset(x: 8, y: 18)
        }
    }
}

struct HighlightLegs: View {
    var body: some View {
        HStack(spacing: 8) {
            Capsule().fill(Color.blue).frame(width: 12, height: 32).offset(x: -8, y: 28)
            Capsule().fill(Color.blue).frame(width: 12, height: 32).offset(x: 8, y: 28)
        }
    }
}


