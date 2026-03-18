import SwiftUI

extension Color {
    static let luminaViolet  = Color(red: 0.55, green: 0.27, blue: 1.00)
    static let luminaCyan    = Color(red: 0.15, green: 0.85, blue: 1.00)
    static let luminaOrange  = Color(red: 1.00, green: 0.45, blue: 0.15)
    static let luminaGreen   = Color(red: 0.20, green: 0.95, blue: 0.55)
    static let luminaPink    = Color(red: 1.00, green: 0.30, blue: 0.65)
    static let luminaGold    = Color(red: 1.00, green: 0.80, blue: 0.20)
    static let luminaDeep    = Color(red: 0.05, green: 0.04, blue: 0.12)
    static let luminaSurface = Color(red: 0.10, green: 0.09, blue: 0.22)
}

extension LinearGradient {
    static let auroraGradient = LinearGradient(
        colors: [.luminaViolet, .luminaCyan],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let fireGradient = LinearGradient(
        colors: [.luminaOrange, .luminaPink],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let forestGradient = LinearGradient(
        colors: [.luminaGreen, .luminaCyan],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let goldGradient = LinearGradient(
        colors: [.luminaGold, .luminaOrange],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
}
