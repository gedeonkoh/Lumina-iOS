import SwiftUI

struct LuminaBackground: View {
    @State private var animate = false
    var body: some View {
        ZStack {
            Color.luminaDeep
            Circle()
                .fill(Color.luminaViolet.opacity(0.18))
                .frame(width: 350, height: 350).blur(radius: 80)
                .offset(x: animate ? -60 : 60, y: animate ? -120 : -80)
                .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: animate)
            Circle()
                .fill(Color.luminaCyan.opacity(0.12))
                .frame(width: 280, height: 280).blur(radius: 70)
                .offset(x: animate ? 80 : -40, y: animate ? 200 : 300)
                .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: animate)
            Circle()
                .fill(Color.luminaPink.opacity(0.10))
                .frame(width: 200, height: 200).blur(radius: 60)
                .offset(x: animate ? 120 : 40, y: animate ? 0 : 100)
                .animation(.easeInOut(duration: 7).repeatForever(autoreverses: true), value: animate)
            ForEach(0..<50, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(Double.random(in: 0.05...0.3)))
                    .frame(width: CGFloat.random(in: 1...2.5), height: CGFloat.random(in: 1...2.5))
                    .offset(
                        x: CGFloat((i * 37 + 13) % 380) - 190,
                        y: CGFloat((i * 53 + 7) % 800) - 400
                    )
                    .opacity(animate ? 0.3 : 1.0)
                    .animation(
                        .easeInOut(duration: Double((i % 4) + 2))
                        .repeatForever(autoreverses: true)
                        .delay(Double(i % 5) * 0.4),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
    }
}

struct AuroraRing: View {
    var progress: Double
    var size: CGFloat = 120
    var lineWidth: CGFloat = 10
    var colors: [Color] = [.luminaViolet, .luminaCyan]
    var label: String = ""
    var sublabel: String = ""
    @State private var appeared = false
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.08), lineWidth: lineWidth)
                .frame(width: size, height: size)
            Circle()
                .trim(from: 0, to: appeared ? progress : 0)
                .stroke(
                    LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1), value: appeared)
            VStack(spacing: 2) {
                if !label.isEmpty {
                    Text(label)
                        .font(.system(size: size * 0.18, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                if !sublabel.isEmpty {
                    Text(sublabel)
                        .font(.system(size: size * 0.12, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
        }
        .onAppear { appeared = true }
    }
}
