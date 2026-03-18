import Foundation
import SwiftUI

struct LuminaTask: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var notes: String = ""
    var isCompleted: Bool = false
    var priority: Priority = .medium
    var category: Category = .personal
    var dueDate: Date?
    var createdAt: Date = Date()
    var completedAt: Date?
    var xpReward: Int { priority.xpReward }

    enum Priority: String, Codable, CaseIterable {
        case low, medium, high, urgent
        var label: String { rawValue.capitalized }
        var color: Color {
            switch self {
            case .low: return .luminaGreen
            case .medium: return .luminaCyan
            case .high: return .luminaOrange
            case .urgent: return .luminaPink
            }
        }
        var xpReward: Int {
            switch self { case .low: 10; case .medium: 20; case .high: 35; case .urgent: 50 }
        }
        var icon: String {
            switch self { case .low: "arrow.down"; case .medium: "minus"; case .high: "arrow.up"; case .urgent: "bolt.fill" }
        }
    }

    enum Category: String, Codable, CaseIterable {
        case work, personal, health, learning, creative, social
        var label: String { rawValue.capitalized }
        var icon: String {
            switch self {
            case .work: return "briefcase.fill"
            case .personal: return "house.fill"
            case .health: return "heart.fill"
            case .learning: return "book.fill"
            case .creative: return "paintbrush.fill"
            case .social: return "person.2.fill"
            }
        }
        var color: Color {
            switch self {
            case .work: return .luminaViolet
            case .personal: return .luminaCyan
            case .health: return .luminaPink
            case .learning: return .luminaGold
            case .creative: return .luminaOrange
            case .social: return .luminaGreen
            }
        }
    }
}
