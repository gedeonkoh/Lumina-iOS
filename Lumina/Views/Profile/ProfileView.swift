import SwiftUI

struct ProfileView: View {
  @EnvironmentObject var appState: AppState
  @State private var animateStats = false

  var levelProgress: Double {
    let xpForNext = Double(appState.level * 100)
    return min(Double(appState.xpPoints % 100) / 100.0, 1.0)
  }

  var body: some View {
    ZStack {
      LuminaBackground()
      ScrollView {
        VStack(spacing: 28) {
          // Avatar + Name
          VStack(spacing: 16) {
            ZStack {
              Circle()
                .fill(
                  LinearGradient(
                    colors: [.luminaPurple, .luminaBlue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                  )
                )
                .frame(width: 100, height: 100)
              Text("👤")
                .font(.system(size: 48))
            }
            .shadow(color: .luminaPurple.opacity(0.5), radius: 20)

            Text(appState.userName.isEmpty ? "Lumina User" : appState.userName)
              .font(.system(size: 24, weight: .black, design: .rounded))
              .foregroundColor(.white)

            // Level badge
            HStack(spacing: 8) {
              Image(systemName: "star.fill")
                .foregroundColor(.luminaGold)
                .font(.system(size: 13))
              Text("Level \(appState.level) • \(appState.xpPoints) XP")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.luminaGold)
            }
            .padding(.horizontal, 18).padding(.vertical, 8)
            .background(
              Capsule()
                .fill(Color.luminaGold.opacity(0.15))
                .overlay(Capsule().stroke(Color.luminaGold.opacity(0.4), lineWidth: 1))
            )

            // XP progress bar
            VStack(spacing: 6) {
              GeometryReader { geo in
                ZStack(alignment: .leading) {
                  Capsule().fill(Color.white.opacity(0.1))
                  Capsule()
                    .fill(LinearGradient(colors: [.luminaPurple, .luminaBlue], startPoint: .leading, endPoint: .trailing))
                    .frame(width: animateStats ? geo.size.width * levelProgress : 0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3), value: animateStats)
                }
              }
              .frame(height: 8)
              HStack {
                Text("\(Int(levelProgress * 100))% to Level \(appState.level + 1)")
                  .font(.system(size: 12, weight: .medium, design: .rounded))
                  .foregroundColor(.white.opacity(0.45))
                Spacer()
              }
            }
          }
          .padding(.top, 40)
          .padding(.horizontal, 32)

          // Stats grid
          LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
            StatCard(title: "Tasks Done", value: "\(appState.taskStore.tasks.filter { $0.isCompleted }.count)", icon: "checkmark.seal.fill", color: .luminaMint, animate: animateStats, delay: 0.1)
            StatCard(title: "Habits Tracked", value: "\(appState.habitStore.habits.count)", icon: "flame.fill", color: .luminaCoral, animate: animateStats, delay: 0.2)
            StatCard(title: "Focus Minutes", value: "\(appState.totalFocusMinutes)", icon: "timer", color: .luminaPurple, animate: animateStats, delay: 0.3)
            StatCard(title: "Best Streak", value: "\(appState.habitStore.habits.map { $0.currentStreak }.max() ?? 0)d", icon: "bolt.fill", color: .luminaGold, animate: animateStats, delay: 0.4)
          }
          .padding(.horizontal, 24)

          // Achievements
          VStack(alignment: .leading, spacing: 14) {
            Text("Achievements")
              .font(.system(size: 20, weight: .bold, design: .rounded))
              .foregroundColor(.white)
              .padding(.horizontal, 24)

            ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: 14) {
                AchievementBadge(emoji: "🔥", title: "On Fire", desc: "3 day streak", unlocked: appState.habitStore.habits.contains { $0.currentStreak >= 3 })
                AchievementBadge(emoji: "🎯", title: "Focused", desc: "25 min session", unlocked: appState.totalFocusMinutes >= 25)
                AchievementBadge(emoji: "✅", title: "Taskmaster", desc: "10 tasks done", unlocked: appState.taskStore.tasks.filter { $0.isCompleted }.count >= 10)
                AchievementBadge(emoji: "⚡", title: "XP Grinder", desc: "500 XP earned", unlocked: appState.xpPoints >= 500)
                AchievementBadge(emoji: "🌟", title: "Level Up", desc: "Reach level 5", unlocked: appState.level >= 5)
              }
              .padding(.horizontal, 24)
            }
          }

          // Quote of the day
          VStack(spacing: 10) {
            Text("💫 Today's Mantra")
              .font(.system(size: 13, weight: .semibold, design: .rounded))
              .foregroundColor(.white.opacity(0.4))
            Text("\"The secret of getting ahead is getting started.\"")
              .font(.system(size: 15, weight: .medium, design: .rounded))
              .foregroundColor(.white.opacity(0.75))
              .multilineTextAlignment(.center)
              .italic()
          }
          .padding(20)
          .background(
            RoundedRectangle(cornerRadius: 20)
              .fill(Color.white.opacity(0.05))
              .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.08), lineWidth: 1))
          )
          .padding(.horizontal, 24)
          .padding(.bottom, 100)
        }
      }
    }
    .onAppear {
      withAnimation(.easeOut(duration: 0.5).delay(0.2)) { animateStats = true }
    }
  }
}

struct StatCard: View {
  let title: String
  let value: String
  let icon: String
  let color: Color
  let animate: Bool
  let delay: Double
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Image(systemName: icon)
        .font(.system(size: 18, weight: .semibold))
        .foregroundColor(color)
      Text(value)
        .font(.system(size: 28, weight: .black, design: .rounded))
        .foregroundColor(.white)
      Text(title)
        .font(.system(size: 12, weight: .medium, design: .rounded))
        .foregroundColor(.white.opacity(0.45))
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(18)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(Color.white.opacity(0.06))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(color.opacity(0.2), lineWidth: 1))
    )
    .scaleEffect(animate ? 1.0 : 0.85)
    .opacity(animate ? 1.0 : 0)
    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(delay), value: animate)
  }
}

struct AchievementBadge: View {
  let emoji: String
  let title: String
  let desc: String
  let unlocked: Bool
  var body: some View {
    VStack(spacing: 8) {
      ZStack {
        Circle()
          .fill(unlocked ? Color.luminaGold.opacity(0.2) : Color.white.opacity(0.05))
          .overlay(Circle().stroke(unlocked ? Color.luminaGold.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1.5))
          .frame(width: 64, height: 64)
        Text(emoji)
          .font(.system(size: 28))
          .opacity(unlocked ? 1.0 : 0.3)
          .grayscale(unlocked ? 0 : 1)
      }
      Text(title)
        .font(.system(size: 12, weight: .bold, design: .rounded))
        .foregroundColor(unlocked ? .white : .white.opacity(0.3))
      Text(desc)
        .font(.system(size: 10, weight: .medium, design: .rounded))
        .foregroundColor(.white.opacity(0.3))
    }
    .frame(width: 80)
  }
}
