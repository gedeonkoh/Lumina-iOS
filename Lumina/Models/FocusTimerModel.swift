import Foundation
import Combine
import SwiftUI

class FocusTimerModel: ObservableObject {
    @Published var mode: Mode = .pomodoro
    @Published var state: TimerState = .idle
    @Published var secondsRemaining: Int = 25 * 60
    @Published var totalSeconds: Int = 25 * 60
    @Published var completedSessions: Int = 0
    @Published var currentTask: String = ""

    private var timer: AnyCancellable?

    enum Mode: String, CaseIterable {
        case pomodoro = "Pomodoro"
        case deepWork = "Deep Work"
        case shortBreak = "Short Break"
        case longBreak = "Long Break"

        var defaultSeconds: Int {
            switch self {
            case .pomodoro: return 25 * 60
            case .deepWork: return 90 * 60
            case .shortBreak: return 5 * 60
            case .longBreak: return 15 * 60
            }
        }
        var color: Color {
            switch self {
            case .pomodoro: return .luminaOrange
            case .deepWork: return .luminaViolet
            case .shortBreak: return .luminaGreen
            case .longBreak: return .luminaCyan
            }
        }
        var icon: String {
            switch self {
            case .pomodoro: return "timer"
            case .deepWork: return "brain.head.profile"
            case .shortBreak: return "cup.and.saucer.fill"
            case .longBreak: return "leaf.fill"
            }
        }
    }

    enum TimerState { case idle, running, paused, finished }

    var progress: Double {
        1.0 - Double(secondsRemaining) / Double(totalSeconds)
    }

    var timeString: String {
        let m = secondsRemaining / 60
        let s = secondsRemaining % 60
        return String(format: "%02d:%02d", m, s)
    }

    func setMode(_ newMode: Mode) {
        stop()
        mode = newMode
        secondsRemaining = newMode.defaultSeconds
        totalSeconds = newMode.defaultSeconds
    }

    func start() {
        state = .running
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.secondsRemaining > 0 {
                    self.secondsRemaining -= 1
                } else {
                    self.finish()
                }
            }
    }

    func pause() { state = .paused; timer?.cancel() }

    func stop() {
        timer?.cancel()
        state = .idle
        secondsRemaining = totalSeconds
    }

    func finish() {
        timer?.cancel()
        state = .finished
        completedSessions += 1
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    func minutesElapsed() -> Int {
        (totalSeconds - secondsRemaining) / 60
    }
}
