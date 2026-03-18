import SwiftUI

struct XPBar: View {
  @EnvironmentObject var appState: AppState
  @State private var animateBar = false
  @State private var showLevelUp = false
  @State private var previousLevel = 1

  var levelProgress: Double {
    return min(Double(appState.xpPoints % 100) / 100.0, 1.0)
  }

  var body: some View {
    HStack(spacing: 10) {
      // Level badge
      ZStack {
        Circle()
          .fill(LinearGradient(colors: [.luminaGold, .luminaCoral], startPoint: .topLeading, endPoint: .bottomTrailing))
          .frame(width: 28, height: 28)
        Text("\(appState.level)")
          .font(.system(size: 12, weight: .black, design: .rounded))
          .foregroundColor(.white)
      }
      .shadow(color: .luminaGold.opacity(0.4), radius: 4)

      // Progress bar
      GeometryReader { geo in
        ZStack(alignment: .leading) {
          Capsule()
            .fill(Color.white.opacity(0.1))
          Capsule()
            .fill(LinearGradient(colors: [.luminaGold, .luminaCoral], startPoint: .leading, endPoint: .trailing))
            .frame(width: animateBar ? geo.size.width * levelProgress : 0)
            .animation(.spring(response: 0.7, dampingFraction: 0.75), value: levelProgress)
        }
      }
      .frame(height: 6)

      // XP text
      Text("\(appState.xpPoints % 100)/100 XP")
        .font(.system(size: 11, weight: .semibold, design: .rounded))
        .foregroundColor(.white.opacity(0.45))
        .frame(width: 70, alignment: .trailing)
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 8)
    .background(
      Capsule()
        .fill(Color.white.opacity(0.06))
        .overlay(Capsule().stroke(Color.luminaGold.opacity(0.2), lineWidth: 1))
    )
    .overlay(
      Group {
        if showLevelUp {
          Text("⬆️ Level \(appState.level)!")
            .font(.system(size: 13, weight: .bold, design: .rounded))
            .foregroundColor(.luminaGold)
            .transition(.scale.combined(with: .opacity))
        }
      }
    )
    .onAppear { animateBar = true; previousLevel = appState.level }
    .onChange(of: appState.level) { newLevel in
      if newLevel > previousLevel {
        previousLevel = newLevel
        withAnimation(.spring()) { showLevelUp = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          withAnimation { showLevelUp = false }
        }
      }
    }
  }
}
