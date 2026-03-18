import SwiftUI

struct FocusView: View {
    @EnvironmentObject var focusTimer: FocusTimerModel
    @EnvironmentObject var appState: AppState
    @State private var showingComplete = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                // Header
                Text("Focus")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 60)

                // Mode Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(FocusTimerModel.Mode.allCases, id: \.self) { mode in
                            ModeChip(mode: mode, isSelected: focusTimer.mode == mode) {
                                focusTimer.setMode(mode)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }

                // Main Timer Ring
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(focusTimer.mode.color.opacity(0.08))
                        .frame(width: 280, height: 280)
                        .blur(radius: 30)

                    AuroraRing(
                        progress: focusTimer.progress,
                        size: 240,
                        lineWidth: 14,
                        colors: [focusTimer.mode.color, focusTimer.mode.color.opacity(0.5)],
                        label: focusTimer.timeString,
                        sublabel: focusTimer.mode.rawValue
                    )

                    // Center icon
                    VStack(spacing: 4) {
                        Spacer().frame(height: 48)
                        Image(systemName: focusTimer.mode.icon)
                            .font(.system(size: 14))
                            .foregroundStyle(focusTimer.mode.color.opacity(0.6))
                    }
                    .frame(height: 240)
                }

                // Task input
                HStack {
                    Image(systemName: "pencil")
                        .foregroundStyle(.white.opacity(0.4))
                    TextField("What are you working on?", text: $focusTimer.currentTask)
                        .font(.system(size: 15, design: .rounded))
                        .foregroundStyle(.white)
                }
                .padding(14)
                .background { GlassCard(cornerRadius: 14) }
                .padding(.horizontal, 20)

                // Controls
                HStack(spacing: 20) {
                    // Reset
                    Button { focusTimer.stop() } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.5))
                            .frame(width: 56, height: 56)
                            .background { GlassCard(cornerRadius: 28) }
                    }

                    // Play/Pause
                    Button {
                        if focusTimer.state == .running { focusTimer.pause() }
                        else { focusTimer.start() }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    colors: [focusTimer.mode.color, focusTimer.mode.color.opacity(0.7)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                ))
                                .frame(width: 80, height: 80)
                                .shadow(color: focusTimer.mode.color.opacity(0.5), radius: 20)
                            Image(systemName: focusTimer.state == .running ? "pause.fill" : "play.fill")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                    }
                    .scaleEffect(focusTimer.state == .running ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: focusTimer.state == .running)

                    // Sessions count
                    VStack(spacing: 2) {
                        Text("\(focusTimer.completedSessions)")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Done")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.4))
                    }
                    .frame(width: 56, height: 56)
                    .background { GlassCard(cornerRadius: 28) }
                }

                // Sessions dots
                HStack(spacing: 8) {
                    ForEach(0..<4, id: \.self) { i in
                        Circle()
                            .fill(i < focusTimer.completedSessions % 4 ?
                                  focusTimer.mode.color : Color.white.opacity(0.15))
                            .frame(width: 10, height: 10)
                            .shadow(color: i < focusTimer.completedSessions % 4 ?
                                    focusTimer.mode.color : .clear, radius: 6)
                    }
                }

                Spacer(minLength: 100)
            }
        }
        .onChange(of: focusTimer.state) { s in
            if s == .finished {
                appState.addFocusMinutes(focusTimer.minutesElapsed())
            }
        }
    }
}

struct ModeChip: View {
    let mode: FocusTimerModel.Mode
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: mode.icon)
                    .font(.system(size: 12, weight: .semibold))
                Text(mode.rawValue)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(isSelected ? mode.color : .white.opacity(0.4))
            .padding(.horizontal, 14).padding(.vertical, 8)
            .background {
                Capsule()
                    .fill(isSelected ? mode.color.opacity(0.15) : Color.white.opacity(0.06))
                    .overlay {
                        Capsule().stroke(isSelected ? mode.color.opacity(0.4) : Color.clear, lineWidth: 1)
                    }
            }
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}
