import Foundation
import Combine

class HabitStore: ObservableObject {
    @Published var habits: [Habit] = []
    private let key = "lumina_habits"

    init() { load() }

    func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
            habits = decoded
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func add(_ habit: Habit) {
        habits.append(habit)
        save()
    }

    func delete(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
        save()
    }

    func toggleToday(_ habit: Habit) -> Bool {
        guard let i = habits.firstIndex(where: { $0.id == habit.id }) else { return false }
        let cal = Calendar.current
        if habits[i].isCompletedToday {
            habits[i].completedDates.removeAll { cal.isDateInToday($0) }
            save()
            return false
        } else {
            habits[i].completedDates.append(Date())
            save()
            return true
        }
    }

    var totalStreakToday: Int {
        habits.filter { $0.isCompletedToday }.count
    }

    var completedTodayRatio: Double {
        guard !habits.isEmpty else { return 0 }
        return Double(totalStreakToday) / Double(habits.count)
    }
}
