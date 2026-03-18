import Foundation
import Combine

class TaskStore: ObservableObject {
    @Published var tasks: [LuminaTask] = []
    private let key = "lumina_tasks"

    init() { load() }

    func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([LuminaTask].self, from: data) {
            tasks = decoded
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func add(_ task: LuminaTask) {
        tasks.insert(task, at: 0)
        save()
    }

    func complete(_ task: LuminaTask) -> Int {
        if let i = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[i].isCompleted = true
            tasks[i].completedAt = Date()
            save()
            return task.xpReward
        }
        return 0
    }

    func delete(_ task: LuminaTask) {
        tasks.removeAll { $0.id == task.id }
        save()
    }

    func update(_ task: LuminaTask) {
        if let i = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[i] = task
            save()
        }
    }

    var pending: [LuminaTask] { tasks.filter { !$0.isCompleted } }
    var completed: [LuminaTask] { tasks.filter { $0.isCompleted } }
    var todayCompleted: Int {
        let cal = Calendar.current
        return completed.filter { t in
            guard let d = t.completedAt else { return false }
            return cal.isDateInToday(d)
        }.count
    }
}
