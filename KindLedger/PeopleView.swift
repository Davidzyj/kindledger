import SwiftUI

struct PeopleView: View {
    @EnvironmentObject private var store: RecordStore

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                if store.people.isEmpty {
                    ContentUnavailableView(
                        "people.empty.title",
                        systemImage: "person.2",
                        description: Text("people.empty.subtitle")
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(store.people) { person in
                                NavigationLink {
                                    PersonDetailView(person: person)
                                } label: {
                                    PersonRowView(person: person)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(20)
                    }
                }
            }
            .navigationTitle("tab.people")
        }
    }
}

private struct PersonRowView: View {
    let person: PersonSummary

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(AppTheme.sage.opacity(0.18))
                    .frame(width: 52, height: 52)
                Text(initial)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(AppTheme.sage)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(person.name)
                    .font(.headline)
                    .foregroundStyle(AppTheme.ink)
                    .lineLimit(1)
                Text("people.records.count \(person.totalCount)")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.subtle)
                if person.unthankedCount > 0 {
                    Text("people.unthanked.count \(person.unthankedCount)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AppTheme.clay)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.subtle)
        }
        .padding(16)
        .background(AppTheme.paper)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var initial: String {
        person.name.first.map { String($0) } ?? "?"
    }
}

private struct PersonDetailView: View {
    @EnvironmentObject private var store: RecordStore
    let person: PersonSummary

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(person.name)
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(AppTheme.ink)
                    HStack(spacing: 12) {
                        PersonMetric(value: "\(person.totalCount)", label: "stats.records")
                        PersonMetric(value: "\(person.unthankedCount)", label: "stats.toThank")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(22)
                .background(AppTheme.paper)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                ForEach(store.records(for: person)) { record in
                    NavigationLink {
                        RecordDetailView(record: record)
                    } label: {
                        RecordRowView(record: record)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("people.detail.title")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct PersonMetric: View {
    let value: String
    let label: LocalizedStringKey

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(AppTheme.ink)
            Text(label)
                .font(.caption)
                .foregroundStyle(AppTheme.subtle)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(AppTheme.background)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
