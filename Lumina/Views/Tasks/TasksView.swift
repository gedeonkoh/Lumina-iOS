import SwiftUI

struct TasksView: View {
  @EnvironmentObject var appState: AppState
  @State private var showingAdd = false
  @State private var newTitle = ""
  @State private var newPriority: LuminaTask.Priority = .medium
  @State private var selectedFilter: FilterOption = .all
  @State private var animateList = false

  enum FilterOption: String, CaseIterable {
    case all = "All"
    case today = "Today"
    case high = "High"
    case done = "Done"
    var icon: String {
      switch self {
      case .all: return "list.bullet"
      case .today: return "sun.max"
      case .high: return "flame"
      case .done: return "checkmark.seal"
      }
    }
  }

  var filteredTasks: [LuminaTask] {
    switch selectedFilter {
    case .all: return appState.taskStore.tasks.filter { !$0.isCompleted }
    case .today:
      return appState.taskStore.tasks.filter {
        !$0.isCompleted && Calendar.current.isDateInToday($0.createdAt)
      }
    case .high: return appState.taskStore.tasks.filter { !$0.isCompleted && $0.priority == .high }
    case .done: return appState.taskStore.tasks.filter { $0.isCompleted }
    }
  }

  var body: some View {
    ZStack {
      LuminaBackground()
      VStack(spacing: 0) {
        // Header
        HStack {
          VStack(alignment: .leading, spacing: 4) {
            Text("Tasks")
              .font(.system(size: 34, weight: .black, design: .rounded))
              .foregroundColor(.white)
            Text("\(appState.taskStore.tasks.filter { !$0.isCompleted }.count) remaining")
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
                  .fill(Color.luminaPurple.opacity(0.3))
                  .overlay(Circle().stroke(Color.luminaPurple.opacity(0.6), lineWidth: 1))
              )
          }
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 16)

        // Filter chips
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            ForEach(FilterOption.allCases, id: \.self) { opt in
              FilterChip(option: opt, isSelected: selectedFilter == opt) {
                withAnimation(.spring(response: 0.3)) { selectedFilter = opt }
              }
            }
          }
          .padding(.horizontal, 24)
        }
        .padding(.bottom, 16)

        // Task list
        if filteredTasks.isEmpty {
          Spacer()
          VStack(spacing: 12) {
            Image(systemName: selectedFilter == .done ? "checkmark.seal.fill" : "sparkles")
              .font(.system(size: 48))
              .foregroundColor(.luminaPurple.opacity(0.6))
            Text(selectedFilter == .done ? "Nothing done yet" : "All clear!")
              .font(.system(size: 18, weight: .semibold, design: .rounded))
              .foregroundColor(.white.opacity(0.6))
          }
          Spacer()
        } else {
          ScrollView {
            LazyVStack(spacing: 12) {
              ForEach(Array(filteredTasks.enumerated()), id: \.element.id) { idx, task in
                TaskRow(task: task, index: idx, animateList: animateList) {
                  withAnimation(.spring()) {
                    appState.taskStore.toggle(task)
                    if !task.isCompleted { appState.addXP(10) }
                  }
                } onDelete: {
                  withAnimation { appState.taskStore.delete(task) }
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
      AddTaskSheet(title: $newTitle, priority: $newPriority) {
        guard !newTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let t = LuminaTask(title: newTitle, priority: newPriority)
        appState.taskStore.add(t)
        newTitle = ""
        newPriority = .medium
        showingAdd = false
      }
    }
    .onAppear {
      withAnimation(.easeOut(duration: 0.4).delay(0.1)) { animateList = true }
    }
  }
}

struct FilterChip: View {
  let option: TasksView.FilterOption
  let isSelected: Bool
  let action: () -> Void
  var body: some View {
    Button(action: action) {
      HStack(spacing: 6) {
        Image(systemName: option.icon)
          .font(.system(size: 11, weight: .semibold))
        Text(option.rawValue)
          .font(.system(size: 13, weight: .semibold, design: .rounded))
      }
      .foregroundColor(isSelected ? .white : .white.opacity(0.5))
      .padding(.horizontal, 14).padding(.vertical, 8)
      .background(
        Capsule()
          .fill(isSelected ? Color.luminaPurple.opacity(0.35) : Color.white.opacity(0.05))
          .overlay(Capsule().stroke(isSelected ? Color.luminaPurple.opacity(0.7) : Color.white.opacity(0.1), lineWidth: 1))
      )
      .scaleEffect(isSelected ? 1.04 : 1.0)
    }
    .buttonStyle(.plain)
  }
}

struct TaskRow: View {
  let task: LuminaTask
  let index: Int
  let animateList: Bool
  let onToggle: () -> Void
  let onDelete: () -> Void
  @State private var offset: CGFloat = 40
  var priorityColor: Color {
    switch task.priority {
    case .high: return .luminaCoral
    case .medium: return .luminaGold
    case .low: return .luminaMint
    }
  }
  var body: some View {
    HStack(spacing: 14) {
      Button(action: onToggle) {
        ZStack {
          Circle()
            .stroke(task.isCompleted ? Color.luminaMint : Color.white.opacity(0.3), lineWidth: 2)
            .frame(width: 26, height: 26)
          if task.isCompleted {
            Image(systemName: "checkmark")
              .font(.system(size: 12, weight: .bold))
              .foregroundColor(.luminaMint)
          }
        }
      }
      VStack(alignment: .leading, spacing: 3) {
        Text(task.title)
          .font(.system(size: 16, weight: .semibold, design: .rounded))
          .foregroundColor(task.isCompleted ? .white.opacity(0.35) : .white)
          .strikethrough(task.isCompleted)
        HStack(spacing: 6) {
          Circle().fill(priorityColor).frame(width: 6, height: 6)
          Text(task.priority.rawValue)
            .font(.system(size: 11, weight: .medium, design: .rounded))
            .foregroundColor(priorityColor.opacity(0.8))
        }
      }
      Spacer()
      Button(action: onDelete) {
        Image(systemName: "trash")
          .font(.system(size: 13))
          .foregroundColor(.white.opacity(0.25))
      }
    }
    .padding(.horizontal, 18).padding(.vertical, 14)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.white.opacity(0.06))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.09), lineWidth: 1))
    )
    .offset(y: animateList ? 0 : offset)
    .opacity(animateList ? 1 : 0)
    .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(Double(index) * 0.06), value: animateList)
  }
}

struct AddTaskSheet: View {
  @Binding var title: String
  @Binding var priority: LuminaTask.Priority
  let onAdd: () -> Void
  @Environment(\.dismiss) var dismiss
  var body: some View {
    NavigationView {
      ZStack {
        Color(red: 0.07, green: 0.07, blue: 0.12).ignoresSafeArea()
        VStack(spacing: 24) {
          VStack(alignment: .leading, spacing: 8) {
            Text("Task name")
              .font(.system(size: 13, weight: .medium, design: .rounded))
              .foregroundColor(.white.opacity(0.5))
            TextField("e.g. Review pitch deck", text: $title)
              .font(.system(size: 17, weight: .semibold, design: .rounded))
              .foregroundColor(.white)
              .padding(14)
              .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.08)))
          }
          VStack(alignment: .leading, spacing: 10) {
            Text("Priority")
              .font(.system(size: 13, weight: .medium, design: .rounded))
              .foregroundColor(.white.opacity(0.5))
            HStack(spacing: 10) {
              ForEach(LuminaTask.Priority.allCases, id: \.self) { p in
                Button {
                  withAnimation(.spring(response: 0.3)) { priority = p }
                } label: {
                  Text(p.rawValue)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(priority == p ? .white : .white.opacity(0.45))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                      RoundedRectangle(cornerRadius: 12)
                        .fill(priority == p ? Color.luminaPurple.opacity(0.35) : Color.white.opacity(0.06))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(priority == p ? Color.luminaPurple.opacity(0.7) : Color.clear, lineWidth: 1))
                    )
                    .scaleEffect(priority == p ? 1.04 : 1.0)
                }
              }
            }
          }
          Button(action: onAdd) {
            Text("Add Task")
              .font(.system(size: 16, weight: .bold, design: .rounded))
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 16)
              .background(
                RoundedRectangle(cornerRadius: 16)
                  .fill(LinearGradient(colors: [.luminaPurple, .luminaBlue], startPoint: .leading, endPoint: .trailing))
              )
          }
          Spacer()
        }
        .padding(24)
      }
      .navigationTitle("New Task")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar { ToolbarItem(placement: .navigationBarLeading) {
        Button("Cancel") { dismiss() }.foregroundColor(.white.opacity(0.6))
      }}
    }
  }
}
