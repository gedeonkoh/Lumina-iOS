# ✨ Lumina - Gamified Productivity

> Your life, reimagined. Productivity that feels **alive**.

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Platform](https://img.shields.io/badge/platform-iOS%2015.0+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 💡 What is Lumina?

Lumina is a **next-generation iOS productivity app** that transforms how you manage tasks, habits, and focus time. Inspired by the gamification principles found in "cool iPhone apps you can't live without," Lumina turns everyday productivity into an immersive, rewarding experience.

### Why Lumina?
- **Glassmorphic UI**: Stunning, modern design with animated gradients and glassmorphism
- **Gamification**: Earn XP, level up, unlock achievements  
- **Habit Streaks**: Track daily habits with fire streaks and progress visualization
- **Focus Timer**: Pomodoro sessions with mode chips (Deep Work, Learning, Creating)
- **Animated Everything**: Smooth spring animations, micro-interactions, delightful UX
- **Dark-First Design**: Built for OLED displays, easy on the eyes

---

## 🎯 Features

### ✅ Smart Task Management
- Priority-based tasks (High, Medium, Low)
- Filter by All, Today, High Priority, Done
- Animated task rows with staggered entrance
- Complete tasks to earn **10 XP**

### 🔥 Habit Tracking
- Custom habit creation with emoji icons & colors
- 7-day streak visualization with animated dots
- Daily check-ins with satisfying tap feedback
- Complete habits to earn **20 XP**

### ⏱️ Focus Sessions
- Pomodoro timer (25 min default, customizable)
- Mode selection: Deep Work, Learning, Creating, Flow
- Animated circular progress with gradient fills
- Session history and total focus minutes tracked

### 🌟 Leveling System
- Real-time XP bar with animated progress
- Level up celebrations with gold gradient badges
- Profile stats: Tasks done, habits tracked, focus minutes, best streak
- Achievement badges (On Fire, Focused, Taskmaster, XP Grinder, Level Up)

### ✨ Onboarding Experience
- 4-page animated onboarding with dynamic gradients
- Floating orbs and smooth page transitions
- Personalized name input with focused keyboard
- "Start My Journey" call-to-action

---

## 📱 Screenshots

_Coming soon! Run the app in Xcode Simulator to see the magic._

---

## 🛠️ Tech Stack

- **Language**: Swift 5.9
- **Framework**: SwiftUI
- **Architecture**: MVVM with @EnvironmentObject
- **Animations**: Spring physics, easeOut, custom curves
- **Design**: Glassmorphism, gradient overlays, SF Symbols
- **Storage**: @AppStorage for UserDefaults persistence

---

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 15.0+ deployment target
- macOS 13.0+ (for Xcode 15)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/gedeonkoh/Lumina-iOS.git
   cd Lumina-iOS
   ```

2. **Open in Xcode**
   ```bash
   open Lumina.xcodeproj
   ```

3. **Select a simulator** (iPhone 14 Pro recommended for best visuals)

4. **Run the app** (⌘R)

5. **Experience Lumina!**

---

## 🎨 Design Philosophy

Lumina's design is inspired by:
- **Apple's design guidelines**: SF Rounded font, SF Symbols, haptics
- **Glassmorphism trends**: Frosted glass cards with subtle borders
- **Game UI**: Progress bars, level badges, achievement unlocks
- **Motion design**: Spring animations, staggered entrances, scale effects

### Color Palette
- **Lumina Purple**: `#7A3FE4` - Primary brand color
- **Lumina Blue**: `#4A90E2` - Accent gradient
- **Lumina Mint**: `#34D399` - Success/habits
- **Lumina Coral**: `#FF6B6B` - High priority/streaks
- **Lumina Gold**: `#FFD93D` - XP/levels/achievements

---

## 📝 Project Structure

```
Lumina/
├── LuminaApp.swift           # App entry point
├── ContentView.swift         # Main tab navigation
├── AppState.swift            # Global state management
├── Info.plist                # App configuration
├── Models/
│   ├── Task.swift
│   ├── TaskStore.swift
│   ├── Habit.swift
│   ├── HabitStore.swift
│   └── FocusTimerModel.swift
├── Views/
│   ├── Home/
│   │   └── HomeView.swift        # Dashboard with quick actions
│   ├── Tasks/
│   │   └── TasksView.swift       # Task list with filters
│   ├── Habits/
│   │   └── HabitsView.swift      # Habit tracker
│   ├── Focus/
│   │   └── FocusView.swift       # Pomodoro timer
│   ├── Profile/
│   │   └── ProfileView.swift     # Stats & achievements
│   └── Onboarding/
│       └── OnboardingView.swift  # First-launch experience
├── Components/
│   ├── GlassCard.swift           # Reusable glassmorphic card
│   ├── XPBar.swift               # Animated XP progress bar
│   └── LuminaBackground.swift    # Animated gradient background
└── Extensions/
    └── Color+Lumina.swift        # Custom color extensions
```

---

## ✨ Key Innovations

1. **Dual-Mode Background**: Animated cosmic gradient in Home, solid dark in other views
2. **Smart XP System**: Tasks = 10 XP, Habits = 20 XP, 100 XP per level
3. **Staggered List Animations**: Each item fades in with a delay based on index
4. **Mode Chips**: Focus timer modes rendered as glassmorphic pills
5. **Achievement System**: Visual badges that unlock based on real progress

---

## 🔮 Roadmap

- [ ] Widget support (Home Screen & Lock Screen)
- [ ] Siri Shortcuts integration
- [ ] iCloud sync across devices
- [ ] Apple Watch companion app
- [ ] Customizable themes
- [ ] Weekly reports & insights
- [ ] Social features (share streaks)

---

## 💬 Inspiration

Lumina was built from the ground up to feel like the apps you see in "my favorite iPhone apps" compilations:
- Smooth, delightful animations
- Glassmorphism and gradients everywhere
- Gamification that actually motivates
- Attention to micro-interactions
- "Feels illegal" level of polish

---

## 👨‍💻 Author

**Gedeon Koh**  
Passionate about building delightful iOS experiences with SwiftUI.

---

## 📜 License

MIT License - feel free to use this project for learning or inspiration!

---

## ⭐ If you love Lumina...

Give this repo a star! It helps others discover the project.

---

**Built with ❤️ and SwiftUI. Productivity has never felt this alive.**
