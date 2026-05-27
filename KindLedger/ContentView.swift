import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: RecordStore
    @State private var searchText = ""
    @State private var showingNewRecord = false

    var filteredRecords: [KindnessRecord] {
        let records = store.sortedRecords
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !query.isEmpty else { return records }
        return records.filter { $0.searchableText.contains(query) }
    }

    var body: some View {
        TabView {
            NavigationStack {
                ZStack {
                    AppTheme.background.ignoresSafeArea()
                    ScrollView {
                        VStack(spacing: 20) {
                            HeroSummaryView()
                            QuickStatsView()
                            RecordsListView(records: filteredRecords)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                    }
                }
                .navigationTitle("tab.memories")
                .searchable(text: $searchText, prompt: "search.prompt")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingNewRecord = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        .accessibilityLabel(Text("action.add"))
                    }
                }
                .sheet(isPresented: $showingNewRecord) {
                    RecordFormView(mode: .create)
                }
            }
            .tabItem {
                Label("tab.memories", systemImage: "book.pages.fill")
            }

            PeopleView()
                .tabItem {
                    Label("tab.people", systemImage: "person.2.fill")
                }

            SettingsView()
                .tabItem {
                    Label("tab.settings", systemImage: "gearshape.fill")
                }
        }
        .tint(AppTheme.clay)
    }
}

private struct HeroSummaryView: View {
    @EnvironmentObject private var store: RecordStore
    @State private var showingNewRecord = false

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

            Button {
                showingNewRecord = true
            } label: {
                Label("home.hero.button", systemImage: "square.and.pencil")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding(22)
        .background(AppTheme.paper)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 18, x: 0, y: 8)
        .sheet(isPresented: $showingNewRecord) {
            RecordFormView(mode: .create)
        }
    }
}

private struct QuickStatsView: View {
    @EnvironmentObject private var store: RecordStore

    var body: some View {
        HStack(spacing: 12) {
            StatTile(value: "\(store.records.count)", label: "stats.records", symbolName: "tray.full.fill")
            StatTile(value: "\(store.uniquePeopleCount)", label: "stats.people", symbolName: "person.crop.circle.badge.checkmark")
            StatTile(value: "\(store.unthankedCount)", label: "stats.toThank", symbolName: "envelope.badge.fill")
        }
    }
}

private struct StatTile: View {
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
                .lineLimit(1)
                .minimumScaleFactor(0.7)
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

private struct RecordsListView: View {
    let records: [KindnessRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("home.recent")
                .font(.headline)
                .foregroundStyle(AppTheme.ink)

            if records.isEmpty {
                ContentUnavailableView(
                    "empty.search.title",
                    systemImage: "magnifyingglass",
                    description: Text("empty.search.subtitle")
                )
                .foregroundStyle(AppTheme.subtle)
                .frame(maxWidth: .infinity, minHeight: 220)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(records) { record in
                        NavigationLink {
                            RecordDetailView(record: record)
                        } label: {
                            RecordRowView(record: record)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

struct RecordRowView: View {
    let record: KindnessRecord

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(AppTheme.gold.opacity(0.2))
                    .frame(width: 48, height: 48)
                Image(systemName: record.category.symbolName)
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundStyle(AppTheme.clay)
            }

            VStack(alignment: .leading, spacing: 7) {
                HStack(alignment: .firstTextBaseline) {
                    Text(record.title.isEmpty ? String(localized: "record.untitled") : record.title)
                        .font(.headline)
                        .foregroundStyle(AppTheme.ink)
                        .lineLimit(2)
                    Spacer(minLength: 8)
                    if record.isThanked {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(AppTheme.sage)
                            .accessibilityLabel(Text("record.thanked"))
                    }
                }
                Text(record.personName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.clay)
                    .lineLimit(1)
                Text(record.story)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.subtle)
                    .lineLimit(2)
                HStack {
                    Text(record.date, style: .date)
                    if !record.place.isEmpty {
                        Text("·")
                        Text(record.place)
                            .lineLimit(1)
                    }
                }
                .font(.caption)
                .foregroundStyle(AppTheme.subtle)
            }
        }
        .padding(16)
        .background(AppTheme.paper)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
