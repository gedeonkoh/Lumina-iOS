import SwiftUI

struct HabitsView: View {
  @EnvironmentObject var appState: AppState
  @State private var showingAdd = false
  @State private var newName = ""
  @State private var newEmoji = "⚡️"
  @State private var newColor: LuminaHabit.HabitColor = .purple
  @State private var animateCards = false

  var body: some View {
    ZStack {
      LuminaBackground()
      VStack(spacing: 0) {
        // Header
        HStack {
          VStack(alignment: .leading, spacing: 4) {
            Text("Habits")
              .font(.system(size: 34, weight: .black, design: .rounded))
              .foregroundColor(.white)
            let streak = appState.habitStore.habits.map { $0.currentStreak }.max() ?? 0
            Text(streak > 0 ? "Best streak: \(streak) days" : "Build your streaks")
              .font(.system(size: 14, weight: .medium, design: .rounded))
              .foregroundColor(.white.opacity(0.5))
          }
          Spacer()
          Button(action: { showingAdd = true }) {
            Image(systemName: "plus")
              .font(.system(size: 18, weight: .bold))
              .foregroundColor(.white)
              .frame(width: 44, height: 44)
              .background(
                Circle()
                  .fill(Color.luminaMint.opacity(0.25))
                  .overlay(Circle().stroke(Color.luminaMint.opacity(0.5), lineWidth: 1))
              )
          }
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 20)

        if appState.habitStore.habits.isEmpty {
          Spacer()
          VStack(spacing: 14) {
            Text("🌱")
              .font(.system(size: 56))
            Text("Plant your first habit")
              .font(.system(size: 18, weight: .semibold, design: .rounded))
              .foregroundColor(.white.opacity(0.6))
            Text("Small actions, massive results.")
              .font(.system(size: 14, weight: .medium, design: .rounded))
              .foregroundColor(.white.opacity(0.35))
          }
          Spacer()
        } else {
          ScrollView {
            LazyVStack(spacing: 14) {
              ForEach(Array(appState.habitStore.habits.enumerated()), id: \.element.id) { idx, habit in
                HabitCard(habit: habit, index: idx, animate: animateCards) {
                  withAnimation(.spring()) {
                    appState.habitStore.markToday(habit)
                    appState.addXP(20)
                  }
                } onDelete: {
                  withAnimation { appState.habitStore.delete(habit) }
                }
              }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 100)
          }
        }
      }
    }
    .sheet(isPresented: $showingAdd) {
      AddHabitSheet(name: $newName, emoji: $newEmoji, color: $newColor) {
        guard !newName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let h = LuminaHabit(name: newName, emoji: newEmoji, color: newColor)
        appState.habitStore.add(h)
        newName = ""; newEmoji = "⚡️"; newColor = .purple
        showingAdd = false
      }
    }
    .onAppear {
      withAnimation(.easeOut(duration: 0.5).delay(0.1)) { animateCards = true }
    }
  }
}

struct HabitCard: View {
  let habit: LuminaHabit
  let index: Int
  let animate: Bool
  let onCheck: () -> Void
  let onDelete: () -> Void
  @State private var pressed = false
  var habitColor: Color {
    switch habit.color {
    case .purple: return .luminaPurple
    case .mint: return .luminaMint
    case .coral: return .luminaCoral
    case .gold: return .luminaGold
    case .blue: return .luminaBlue
    }
  }
  var isCheckedToday: Bool {
    guard let last = habit.lastChecked else { return false }
    return Calendar.current.isDateInToday(last)
  }
  var body: some View {
    HStack(spacing: 16) {
      // Emoji badge
      ZStack {
        Circle()
          .fill(habitColor.opacity(0.18))
          .overlay(Circle().stroke(habitColor.opacity(0.35), lineWidth: 1.5))
          .frame(width: 52, height: 52)
        Text(habit.emoji)
          .font(.system(size: 24))
      }
      // Info
      VStack(alignment: .leading, spacing: 5) {
        Text(habit.name)
          .font(.system(size: 16, weight: .bold, design: .rounded))
          .foregroundColor(.white)
        HStack(spacing: 8) {
          Image(systemName: "flame.fill")
            .font(.system(size: 11))
            .foregroundColor(.luminaCoral)
          Text("\(habit.currentStreak) day streak")
            .font(.system(size: 12, weight: .medium, design: .rounded))
            .foregroundColor(.white.opacity(0.55))
        }
        // Week dots
        HStack(spacing: 5) {
          ForEach(0..<7) { i in
            let done = i < habit.currentStreak
            Circle()
              .fill(done ? habitColor : Color.white.opacity(0.1))
              .frame(width: 7, height: 7)
          }
        }
      }
      Spacer()
      // Check button
      VStack(spacing: 6) {
        Button(action: {
          guard !isCheckedToday else { return }
          withAnimation(.spring(response: 0.3)) { pressed = true }
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring()) { pressed = false }
            onCheck()
          }
        }) {
          ZStack {
            Circle()
              .fill(isCheckedToday ? habitColor.opacity(0.3) : Color.white.opacity(0.07))
              .overlay(Circle().stroke(isCheckedToday ? habitColor : Color.white.opacity(0.2), lineWidth: 2))
              .frame(width: 40, height: 40)
            Image(systemName: isCheckedToday ? "checkmark" : "plus")
              .font(.system(size: 14, weight: .bold))
              .foregroundColor(isCheckedToday ? habitColor : .white.opacity(0.6))
          }
        }
        .scaleEffect(pressed ? 0.88 : 1.0)
        Button(action: onDelete) {
          Image(systemName: "trash")
            .font(.system(size: 11))
            .foregroundColor(.white.opacity(0.2))
        }
      }
    }
    .padding(.horizontal, 18).padding(.vertical, 14)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(Color.white.opacity(0.065))
        .overlay(
          RoundedRectangle(cornerRadius: 20)
            .stroke(isCheckedToday ? habitColor.opacity(0.4) : Color.white.opacity(0.08), lineWidth: 1)
        )
    )
    .offset(y: animate ? 0 : 50)
    .opacity(animate ? 1 : 0)
    .animation(.spring(response: 0.55, dampingFraction: 0.75).delay(Double(index) * 0.07), value: animate)
  }
}

struct AddHabitSheet: View {
  @Binding var name: String
  @Binding var emoji: String
  @Binding var color: LuminaHabit.HabitColor
  let onAdd: () -> Void
  @Environment(\.dismiss) var dismiss
  let emojis = ["⚡️","🔥","💧","🌿","📚","🏃","🎯","🧘","✍️","🎵","💪","🌅"]
  var body: some View {
    NavigationView {
      ZStack {
        Color(red: 0.07, green: 0.07, blue: 0.12).ignoresSafeArea()
        VStack(spacing: 24) {
          // Emoji picker
          VStack(alignment: .leading, spacing: 10) {
            Text("Pick an icon")
              .font(.system(size: 13, weight: .medium, design: .rounded))
              .foregroundColor(.white.opacity(0.5))
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
              ForEach(emojis, id: \.self) { e in
                Button { emoji = e } label: {
                  ZStack {
                    RoundedRectangle(cornerRadius: 12)
                      .fill(emoji == e ? Color.luminaPurple.opacity(0.3) : Color.white.opacity(0.07))
                      .overlay(RoundedRectangle(cornerRadius: 12).stroke(emoji == e ? Color.luminaPurple.opacity(0.7) : Color.clear, lineWidth: 1))
                      .frame(height: 46)
                    Text(e).font(.system(size: 22))
                  }
                }
              }
            }
          }
          // Name
          VStack(alignment: .leading, spacing: 8) {
            Text("Habit name")
              .font(.system(size: 13, weight: .medium, design: .rounded))
              .foregroundColor(.white.opacity(0.5))
            TextField("e.g. Morning run", text: $name)
              .font(.system(size: 17, weight: .semibold, design: .rounded))
              .foregroundColor(.white)
              .padding(14)
              .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.08)))
          }
          // Color
          VStack(alignment: .leading, spacing: 10) {
            Text("Color")
              .font(.system(size: 13, weight: .medium, design: .rounded))
              .foregroundColor(.white.opacity(0.5))
            HStack(spacing: 12) {
              ForEach(LuminaHabit.HabitColor.allCases, id: \.self) { c in
                let col: Color = c == .purple ? .luminaPurple : c == .mint ? .luminaMint : c == .coral ? .luminaCoral : c == .gold ? .luminaGold : .luminaBlue
                Button { withAnimation { color = c } } label: {
                  Circle()
                    .fill(col)
                    .frame(width: 34, height: 34)
                    .overlay(Circle().stroke(Color.white, lineWidth: color == c ? 2.5 : 0))
                    .scaleEffect(color == c ? 1.15 : 1.0)
                    .animation(.spring(response: 0.3), value: color)
                }
              }
            }
          }
          Button(action: onAdd) {
            Text("Create Habit")
              .font(.system(size: 16, weight: .bold, design: .rounded))
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 16)
              .background(
                RoundedRectangle(cornerRadius: 16)
                  .fill(LinearGradient(colors: [.luminaMint, .luminaBlue], startPoint: .leading, endPoint: .trailing))
              )
          }
          Spacer()
        }
        .padding(24)
      }
      .navigationTitle("New Habit")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar { ToolbarItem(placement: .navigationBarLeading) {
        Button("Cancel") { dismiss() }.foregroundColor(.white.opacity(0.6))
      }}
    }
  }
}
