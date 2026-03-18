//
//  AppState.swift
//  Lumina
//  Global app state, theme, onboarding
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isOnboarded: Bool
    @Published var userName: String
    @Published var userEmoji: String
    @Published var currentStreak: Int
    @Published var totalFocusMinutes: Int
    @Published var xpPoints: Int
    @Published var level: Int

    init() {
        let defaults = UserDefaults.standard
        self.isOnboarded = defaults.bool(forKey: "isOnboarded")
        self.userName = defaults.string(forKey: "userName") ?? "Legend"
        self.userEmoji = defaults.string(forKey: "userEmoji") ?? "⚡"
        self.currentStreak = defaults.integer(forKey: "currentStreak")
        self.totalFocusMinutes = defaults.integer(forKey: "totalFocusMinutes")
        self.xpPoints = defaults.integer(forKey: "xpPoints")
        self.level = defaults.integer(forKey: "level")
        if self.level == 0 { self.level = 1 }
    }

    func completeOnboarding(name: String, emoji: String) {
        userName = name
        userEmoji = emoji
        isOnboarded = true
        let d = UserDefaults.standard
        d.set(name, forKey: "userName")
        d.set(emoji, forKey: "userEmoji")
        d.set(true, forKey: "isOnboarded")
    }

    func addXP(_ amount: Int) {
        xpPoints += amount
        let newLevel = (xpPoints / 500) + 1
        if newLevel > level { level = newLevel }
        UserDefaults.standard.set(xpPoints, forKey: "xpPoints")
        UserDefaults.standard.set(level, forKey: "level")
    }

    func addFocusMinutes(_ minutes: Int) {
        totalFocusMinutes += minutes
        UserDefaults.standard.set(totalFocusMinutes, forKey: "totalFocusMinutes")
        addXP(minutes * 2)
    }

    var levelTitle: String {
        switch level {
        case 1: return "Spark"
        case 2: return "Flame"
        case 3: return "Blaze"
        case 4: return "Inferno"
        case 5: return "Aurora"
        case 6...10: return "Luminary"
        default: return "Legend"
        }
    }

    var xpToNextLevel: Int {
        return level * 500 - xpPoints
    }

    var xpProgress: Double {
        let currentLevelXP = (level - 1) * 500
        let nextLevelXP = level * 500
        return Double(xpPoints - currentLevelXP) / Double(nextLevelXP - currentLevelXP)
    }
}
