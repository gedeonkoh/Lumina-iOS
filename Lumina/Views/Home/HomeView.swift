import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var habitStore: HabitStore
    @EnvironmentObject var focusTimer: FocusTimerModel
    @State private var greetingScale: CGFloat = 0.8
    @State private var cardsOffset: CGFloat = 40

    var greeting: String {
        let h = Calendar.current.component(.hour, from: Date())
        switch h {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<21: return "Good evening"
        default: return "Late night grind"
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(greeting + ",")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.6))
                        Text(appState.userEmoji + " " + appState.userName)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    // Level badge
                    VStack(spacing: 2) {
                        Text("LVL \(appState.level)")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.luminaGold)
                        Text(appState.levelTitle)
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.luminaGold.opacity(0.12))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.luminaGold.opacity(0.3), lineWidth: 1)
                            }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .scaleEffect(greetingScale)
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: greetingScale)

                // XP Progress Bar
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("\(appState.xpPoints) XP")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.luminaViolet)
                        Spacer()
                        Text("\(appState.xpToNextLevel) to Level \(appState.level + 1)")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.4))
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.08))
                                .frame(height: 6)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(LinearGradient.auroraGradient)
                                .frame(width: geo.size.width * appState.xpProgress, height: 6)
                                .animation(.spring(response: 0.8, dampingFraction: 0.7), value: appState.xpProgress)
                        }
                    }
                    .frame(height: 6)
                }
                .padding(.horizontal, 20)

                // Today's Summary Cards
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    StatCard(icon: "checkmark.circle.fill", value: "\(taskStore.todayCompleted)", label: "Done Today", color: .luminaCyan)
                    StatCard(icon: "flame.fill", value: "\(habitStore.totalStreakToday)/\(habitStore.habits.count)", label: "Habits", color: .luminaGreen)
                    StatCard(icon: "timer", value: "\(appState.totalFocusMinutes)m", label: "Focus", color: .luminaOrange)
                    StatCard(icon: "bolt.fill", value: "\(taskStore.pending.count)", label: "Pending", color: .luminaPink)
                }
                .padding(.horizontal, 20)
                .offset(y: cardsOffset)
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: cardsOffset)

                // Quick Tasks
                if !taskStore.pending.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Up Next")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20)

                        ForEach(taskStore.pending.prefix(3)) { task in
                            HomeTaskRow(task: task)
                                .padding(.horizontal, 20)
                        }
                    }
                }

                Spacer(minLength: 100)
            }
        }
        .onAppear {
            withAnimation { greetingScale = 1.0; cardsOffset = 0 }
        }
    }
}

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    @State private var appeared = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(color)
                .glow(color, radius: 6)
            Text(value)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(color.opacity(0.08))
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                }
        }
        .scaleEffect(appeared ? 1 : 0.9)
        .opacity(appeared ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { appeared = true }
        }
    }
}

struct HomeTaskRow: View {
    let task: LuminaTask
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(task.priority.color.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay {
                    Image(systemName: task.priority.icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(task.priority.color)
                }
            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Text(task.category.label)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.4))
            }
            Spacer()
            Text("+\(task.xpReward) XP")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(Color.luminaGold)
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(Color.luminaGold.opacity(0.12))
                .clipShape(Capsule())
        }
        .padding(12)
        .background { GlassCard(cornerRadius: 14) }
    }
}
