//
//  LuminaApp.swift
//  Lumina
//
//  The App Entry Point
//  Design Philosophy: Dark glass + neon aurora. Every pixel intentional.
//

import SwiftUI

@main
struct LuminaApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var habitStore = HabitStore()
    @StateObject private var taskStore = TaskStore()
    @StateObject private var focusTimer = FocusTimerModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(habitStore)
                .environmentObject(taskStore)
                .environmentObject(focusTimer)
                .preferredColorScheme(.dark)
        }
    }
}
