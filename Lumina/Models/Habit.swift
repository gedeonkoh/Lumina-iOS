import Foundation
import SwiftUI

struct Habit: Identifiable, Codable {
    var id = UUID()
    var name: String
    var emoji: String
    var color: HabitColor
    var frequency: Frequency
    var completedDates: [Date] = []
    var createdAt: Date = Date()
    var targetDays: Int = 21

    enum Frequency: String, Codable, CaseIterable {
        case daily, weekdays, weekends, custom
        var label: String { rawValue.capitalized }
    }

    enum HabitColor: String, Codable, CaseIterable {
        case violet, cyan, orange, green, pink, gold
        var color: Color {
            switch self {
            case .violet: return .luminaViolet
            case .cyan: return .luminaCyan
            case .orange: return .luminaOrange
            case .green: return .luminaGreen
            case .pink: return .luminaPink
            case .gold: return .luminaGold
            }
        }
    }

    var currentStreak: Int {
        let cal = Calendar.current
        var streak = 0
        var date = cal.startOfDay(for: Date())
        for _ in 0..<365 {
            if completedDates.contains(where: { cal.isDate($0, inSameDayAs: date) }) {
                streak += 1
                date = cal.date(byAdding: .day, value: -1, to: date)!
            } else { break }
        }
        return streak
    }

    var isCompletedToday: Bool {
        let cal = Calendar.current
        return completedDates.contains { cal.isDateInToday($0) }
    }

    var completionRate: Double {
        let days = Calendar.current.dateComponents([.day], from: createdAt, to: Date()).day ?? 1
        return Double(completedDates.count) / Double(max(days, 1))
    }

    var progress: Double {
        Double(min(currentStreak, targetDays)) / Double(targetDays)
    }
}
