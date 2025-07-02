import SwiftUI

struct HomeDashboardView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to your account!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

#Preview {
    HomeDashboardView()
} 