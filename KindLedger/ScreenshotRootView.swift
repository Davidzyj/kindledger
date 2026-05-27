import SwiftUI

enum ScreenshotScreen: String {
    case home
    case add
    case detail
    case people
    case settings

    static var current: ScreenshotScreen? {
        guard let index = ProcessInfo.processInfo.arguments.firstIndex(of: "-kindledgerScreenshot"),
              ProcessInfo.processInfo.arguments.indices.contains(index + 1) else {
            return nil
        }
        return ScreenshotScreen(rawValue: ProcessInfo.processInfo.arguments[index + 1])
    }
}

enum ScreenshotConfig {
    static var screen: ScreenshotScreen? {
        ScreenshotScreen.current
    }

    static var localeIdentifier: String {
        guard let index = ProcessInfo.processInfo.arguments.firstIndex(of: "-kindledgerLocale"),
              ProcessInfo.processInfo.arguments.indices.contains(index + 1) else {
            return Locale.current.identifier
        }
        return ProcessInfo.processInfo.arguments[index + 1]
    }

    static var locale: Locale {
        Locale(identifier: localeIdentifier)
    }
}

struct ScreenshotRootView: View {
    @EnvironmentObject private var store: RecordStore
    let screen: ScreenshotScreen

    var body: some View {
        Group {
            switch screen {
            case .home:
                NavigationStack {
                    ZStack {
                        AppTheme.background.ignoresSafeArea()
                        ScrollView {
                            VStack(spacing: 20) {
                                ScreenshotHeroView()
                                ScreenshotStatsView()
                                ScreenshotRecordsView()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 18)
                        }
                    }
                    .navigationTitle("tab.memories")
                }
            case .add:
                RecordFormView(mode: .create)
            case .detail:
                NavigationStack {
                    RecordDetailView(record: store.sortedRecords.first ?? .empty)
                }
            case .people:
                PeopleView()
            case .settings:
                SettingsView()
            }
        }
        .tint(AppTheme.clay)
    }
}

private struct ScreenshotHeroView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("home.hero.title")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(AppTheme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("home.hero.subtitle")
                        .font(.callout)
                        .foregroundStyle(AppTheme.subtle)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 12)
                ZStack {
                    Circle()
                        .fill(AppTheme.gold.opacity(0.22))
                        .frame(width: 68, height: 68)
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundStyle(AppTheme.clay)
                }
            }

            Label("home.hero.button", systemImage: "square.and.pencil")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .padding(.horizontal, 16)
                .foregroundStyle(.white)
                .background(AppTheme.clay)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .padding(22)
        .background(AppTheme.paper)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 18, x: 0, y: 8)
    }
}

private struct ScreenshotStatsView: View {
    @EnvironmentObject private var store: RecordStore

    var body: some View {
        HStack(spacing: 12) {
            ScreenshotStatTile(value: "\(store.records.count)", label: "stats.records", symbolName: "tray.full.fill")
            ScreenshotStatTile(value: "\(store.uniquePeopleCount)", label: "stats.people", symbolName: "person.crop.circle.badge.checkmark")
            ScreenshotStatTile(value: "\(store.unthankedCount)", label: "stats.toThank", symbolName: "envelope.badge.fill")
        }
    }
}

private struct ScreenshotStatTile: View {
    let value: String
    let label: LocalizedStringKey
    let symbolName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: symbolName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(AppTheme.sage)
                .frame(height: 22)
            Text(value)
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(AppTheme.ink)
            Text(label)
                .font(.caption)
                .foregroundStyle(AppTheme.subtle)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 116, alignment: .leading)
        .padding(14)
        .background(AppTheme.paper)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct ScreenshotRecordsView: View {
    @EnvironmentObject private var store: RecordStore

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("home.recent")
                .font(.headline)
                .foregroundStyle(AppTheme.ink)
            LazyVStack(spacing: 12) {
                ForEach(store.sortedRecords.prefix(2)) { record in
                    RecordRowView(record: record)
                }
            }
        }
    }
}
