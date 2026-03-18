import SwiftUI

struct OnboardingPage {
  let emoji: String
  let title: String
  let subtitle: String
  let gradient: [Color]
}

struct OnboardingView: View {
  @EnvironmentObject var appState: AppState
  @State private var currentPage = 0
  @State private var nameInput = ""
  @State private var animatePage = false
  @FocusState private var nameFieldFocused: Bool

  let pages: [OnboardingPage] = [
    OnboardingPage(
      emoji: "✨",
      title: "Welcome to Lumina",
      subtitle: "Your life, gamified. Productivity has never felt this alive.",
      gradient: [Color(red: 0.45, green: 0.25, blue: 0.85), Color(red: 0.25, green: 0.5, blue: 0.95)]
    ),
    OnboardingPage(
      emoji: "🔥",
      title: "Build Habits That Stick",
      subtitle: "Track streaks, earn XP, and watch small habits compound into massive change.",
      gradient: [Color(red: 0.9, green: 0.35, blue: 0.35), Color(red: 0.9, green: 0.6, blue: 0.2)]
    ),
    OnboardingPage(
      emoji: "⏱",
      title: "Focus Like a Pro",
      subtitle: "Pomodoro sessions, mode chips, and session tracking. Flow state on demand.",
      gradient: [Color(red: 0.2, green: 0.75, blue: 0.65), Color(red: 0.3, green: 0.5, blue: 0.9)]
    ),
    OnboardingPage(
      emoji: "🌟",
      title: "Level Up Daily",
      subtitle: "Every completed task earns XP. Every habit builds your streak. You are the character.",
      gradient: [Color(red: 0.85, green: 0.7, blue: 0.15), Color(red: 0.9, green: 0.4, blue: 0.2)]
    )
  ]

  var isLastPage: Bool { currentPage == pages.count }

  var body: some View {
    ZStack {
      // Dynamic background
      if currentPage < pages.count {
        LinearGradient(
          colors: pages[currentPage].gradient.map { $0.opacity(0.25) } + [Color(red: 0.05, green: 0.05, blue: 0.1)],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.6), value: currentPage)
      } else {
        Color(red: 0.05, green: 0.05, blue: 0.1).ignoresSafeArea()
      }

      // Floating orbs
      if currentPage < pages.count {
        Circle()
          .fill(pages[currentPage].gradient[0].opacity(0.15))
          .frame(width: 300, height: 300)
          .blur(radius: 60)
          .offset(x: -80, y: -200)
          .animation(.easeInOut(duration: 0.6), value: currentPage)
        Circle()
          .fill(pages[currentPage].gradient[1].opacity(0.12))
          .frame(width: 250, height: 250)
          .blur(radius: 50)
          .offset(x: 100, y: 200)
          .animation(.easeInOut(duration: 0.6), value: currentPage)
      }

      VStack {
        if isLastPage {
          // Name entry
          VStack(spacing: 32) {
            Spacer()
            Text("💫")
              .font(.system(size: 72))
              .scaleEffect(animatePage ? 1 : 0.5)
              .opacity(animatePage ? 1 : 0)

            VStack(spacing: 12) {
              Text("What should we call you?")
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
              Text("Your name powers your journey.")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)
            }
            .opacity(animatePage ? 1 : 0)
            .offset(y: animatePage ? 0 : 20)

            TextField("Your name...", text: $nameInput)
              .font(.system(size: 20, weight: .semibold, design: .rounded))
              .foregroundColor(.white)
              .multilineTextAlignment(.center)
              .padding(18)
              .background(
                RoundedRectangle(cornerRadius: 18)
                  .fill(Color.white.opacity(0.1))
                  .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.luminaPurple.opacity(0.5), lineWidth: 1.5))
              )
              .padding(.horizontal, 40)
              .focused($nameFieldFocused)
              .opacity(animatePage ? 1 : 0)
              .offset(y: animatePage ? 0 : 20)

            Spacer()

            Button(action: finishOnboarding) {
              HStack(spacing: 10) {
                Text("Start My Journey")
                  .font(.system(size: 17, weight: .bold, design: .rounded))
                Image(systemName: "arrow.right")
                  .font(.system(size: 15, weight: .bold))
              }
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 18)
              .background(
                RoundedRectangle(cornerRadius: 18)
                  .fill(LinearGradient(colors: [.luminaPurple, .luminaBlue], startPoint: .leading, endPoint: .trailing))
              )
              .shadow(color: .luminaPurple.opacity(0.4), radius: 12, y: 4)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 50)
          }
        } else {
          // Onboarding pages
          VStack(spacing: 0) {
            Spacer()

            // Emoji
            Text(pages[currentPage].emoji)
              .font(.system(size: 90))
              .scaleEffect(animatePage ? 1.0 : 0.3)
              .opacity(animatePage ? 1 : 0)
              .animation(.spring(response: 0.6, dampingFraction: 0.65), value: animatePage)
              .id("emoji-\(currentPage)")

            Spacer().frame(height: 40)

            // Text
            VStack(spacing: 16) {
              Text(pages[currentPage].title)
                .font(.system(size: 30, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
              Text(pages[currentPage].subtitle)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            }
            .padding(.horizontal, 36)
            .opacity(animatePage ? 1 : 0)
            .offset(y: animatePage ? 0 : 30)
            .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(0.1), value: animatePage)
            .id("text-\(currentPage)")

            Spacer()

            // Page dots
            HStack(spacing: 8) {
              ForEach(0..<pages.count, id: \.self) { i in
                Capsule()
                  .fill(i == currentPage ? Color.white : Color.white.opacity(0.25))
                  .frame(width: i == currentPage ? 22 : 8, height: 8)
                  .animation(.spring(response: 0.3), value: currentPage)
              }
            }
            .padding(.bottom, 32)

            // Next button
            Button(action: nextPage) {
              HStack(spacing: 10) {
                Text(currentPage == pages.count - 1 ? "Almost there" : "Next")
                  .font(.system(size: 17, weight: .bold, design: .rounded))
                Image(systemName: "arrow.right")
                  .font(.system(size: 15, weight: .bold))
              }
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 18)
              .background(
                RoundedRectangle(cornerRadius: 18)
                  .fill(LinearGradient(
                    colors: pages[currentPage].gradient,
                    startPoint: .leading,
                    endPoint: .trailing
                  ))
                  .shadow(color: pages[currentPage].gradient[0].opacity(0.5), radius: 12, y: 4)
              )
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 50)
          }
        }
      }
    }
    .onAppear { triggerAnimation() }
  }

  func nextPage() {
    withAnimation(.easeIn(duration: 0.15)) { animatePage = false }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
      currentPage += 1
      triggerAnimation()
      if isLastPage { nameFieldFocused = true }
    }
  }

  func triggerAnimation() {
    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) { animatePage = true }
  }

  func finishOnboarding() {
    let name = nameInput.trimmingCharacters(in: .whitespaces)
    appState.userName = name.isEmpty ? "Lumina User" : name
    withAnimation(.easeInOut(duration: 0.5)) {
      appState.hasCompletedOnboarding = true
    }
  }
}
