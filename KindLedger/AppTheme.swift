import SwiftUI

enum AppTheme {
    static let background = Color(red: 0.965, green: 0.935, blue: 0.885)
    static let paper = Color(red: 1.0, green: 0.988, blue: 0.958)
    static let ink = Color(red: 0.145, green: 0.164, blue: 0.18)
    static let subtle = Color(red: 0.43, green: 0.42, blue: 0.38)
    static let clay = Color(red: 0.63, green: 0.24, blue: 0.18)
    static let sage = Color(red: 0.26, green: 0.45, blue: 0.37)
    static let gold = Color(red: 0.86, green: 0.62, blue: 0.25)
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 13)
            .padding(.horizontal, 16)
            .foregroundStyle(.white)
            .background(configuration.isPressed ? AppTheme.clay.opacity(0.82) : AppTheme.clay)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .foregroundStyle(AppTheme.clay)
            .background(configuration.isPressed ? AppTheme.gold.opacity(0.26) : AppTheme.gold.opacity(0.16))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
