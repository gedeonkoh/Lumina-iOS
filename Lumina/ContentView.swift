//
//  ContentView.swift
//  Lumina
//
//  Main navigation shell with custom tab bar
//  Aurora glass bottom bar with haptic feedback
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: Tab = .home
    @State private var tabBarOffset: CGFloat = 0
    @Namespace private var tabAnimation

    enum Tab: String, CaseIterable {
        case home = "house.fill"
        case tasks = "checkmark.circle.fill"
        case focus = "timer"
        case habits = "flame.fill"
        case profile = "person.fill"

        var label: String {
            switch self {
            case .home: return "Home"
            case .tasks: return "Tasks"
            case .focus: return "Focus"
            case .habits: return "Habits"
            case .profile: return "You"
            }
        }

        var accentColor: Color {
            switch self {
            case .home: return Color.luminaViolet
            case .tasks: return Color.luminaCyan
            case .focus: return Color.luminaOrange
            case .habits: return Color.luminaGreen
            case .profile: return Color.luminaPink
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            LuminaBackground()
                .ignoresSafeArea()

            // Content
            Group {
                switch selectedTab {
                case .home:    HomeView()
                case .tasks:   TasksView()
                case .focus:   FocusView()
                case .habits:  HabitsView()
                case .profile: ProfileView()
                }
            }
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.2), value: selectedTab)

            // Custom Tab Bar
            LuminaTabBar(selectedTab: $selectedTab, namespace: tabAnimation)
        }
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - Custom Tab Bar

struct LuminaTabBar: View {
    @Binding var selectedTab: ContentView.Tab
    var namespace: Namespace.ID

    var body: some View {
        HStack(spacing: 0) {
            ForEach(ContentView.Tab.allCases, id: \.self) { tab in
                TabItemView(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    namespace: namespace
                ) {
                    let impact = UIImpactFeedbackGenerator(style: .soft)
                    impact.impactOccurred()
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            GlassCard(cornerRadius: 32)
                .shadow(color: .black.opacity(0.4), radius: 20, y: 10)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }
}

struct TabItemView: View {
    let tab: ContentView.Tab
    let isSelected: Bool
    var namespace: Namespace.ID
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(tab.accentColor.opacity(0.2))
                            .frame(width: 48, height: 32)
                            .matchedGeometryEffect(id: "tab_bg", in: namespace)
                    }
                    Image(systemName: tab.rawValue)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(isSelected ? tab.accentColor : .white.opacity(0.4))
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                }
                .frame(width: 48, height: 32)

                Text(tab.label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(isSelected ? tab.accentColor : .white.opacity(0.3))
            }
        }
        .frame(maxWidth: .infinity)
    }
}
