import SwiftUI

struct SettingsView: View {
    private let supportURL = URL(string: "https://davidzyj.github.io/kindledger/en/support.html")!
    private let privacyURL = URL(string: "https://davidzyj.github.io/kindledger/en/privacy.html")!
    private let supportURLChinese = URL(string: "https://davidzyj.github.io/kindledger/zh/support.html")!
    private let privacyURLChinese = URL(string: "https://davidzyj.github.io/kindledger/zh/privacy.html")!

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 44, weight: .semibold))
                            .foregroundStyle(AppTheme.clay)
                        Text("settings.about.title")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(AppTheme.ink)
                        Text("settings.about.body")
                            .font(.body)
                            .foregroundStyle(AppTheme.subtle)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 10)
                }

                Section("settings.section.links") {
                    Link(destination: localizedPrivacyURL) {
                        Label("settings.privacy", systemImage: "lock.shield.fill")
                    }
                    Link(destination: localizedSupportURL) {
                        Label("settings.support", systemImage: "questionmark.circle.fill")
                    }
                    Link(destination: URL(string: "mailto:jay212315@gmail.com")!) {
                        Label("settings.email", systemImage: "envelope.fill")
                    }
                }

                Section("settings.section.app") {
                    LabeledContent("settings.version", value: "1.0.0")
                    LabeledContent {
                        Text("settings.storage.local")
                    } label: {
                        Text("settings.storage")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.background)
            .navigationTitle("tab.settings")
        }
    }

    private var localizedSupportURL: URL {
        Locale.current.language.languageCode?.identifier == "zh" ? supportURLChinese : supportURL
    }

    private var localizedPrivacyURL: URL {
        Locale.current.language.languageCode?.identifier == "zh" ? privacyURLChinese : privacyURL
    }
}
