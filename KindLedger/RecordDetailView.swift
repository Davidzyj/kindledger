import SwiftUI

struct RecordDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: RecordStore
    @State private var showingEdit = false
    @State private var showingDeleteAlert = false

    let record: KindnessRecord

    private var currentRecord: KindnessRecord {
        store.records.first(where: { $0.id == record.id }) ?? record
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        Label(currentRecord.category.titleKey, systemImage: currentRecord.category.symbolName)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppTheme.clay)
                        Spacer()
                        ImpactBadge(impact: currentRecord.impact)
                    }

                    Text(currentRecord.title.isEmpty ? String(localized: "record.untitled") : currentRecord.title)
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(AppTheme.ink)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(currentRecord.personName)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(AppTheme.clay)
                }
                .padding(22)
                .background(AppTheme.paper)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                DetailBlock(title: "detail.story", symbolName: "quote.opening") {
                    Text(currentRecord.story)
                        .font(.body)
                        .foregroundStyle(AppTheme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                }

                DetailBlock(title: "detail.whenWhere", symbolName: "calendar") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(currentRecord.date, style: .date)
                        if !currentRecord.place.isEmpty {
                            Text(currentRecord.place)
                        }
                    }
                    .font(.body)
                    .foregroundStyle(AppTheme.ink)
                }

                if !currentRecord.tags.isEmpty {
                    DetailBlock(title: "detail.tags", symbolName: "tag.fill") {
                        FlowLayout(items: currentRecord.tags) { tag in
                            Text("#\(tag)")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(AppTheme.clay)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(AppTheme.gold.opacity(0.18))
                                .clipShape(Capsule())
                        }
                    }
                }

                DetailBlock(title: "detail.thanks", symbolName: "envelope.open.fill") {
                    VStack(alignment: .leading, spacing: 12) {
                        Button {
                            store.toggleThanked(currentRecord)
                        } label: {
                            Label(
                                currentRecord.isThanked ? "detail.thanked" : "detail.markThanked",
                                systemImage: currentRecord.isThanked ? "checkmark.seal.fill" : "seal"
                            )
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(SecondaryButtonStyle())

                        if !currentRecord.thankNote.isEmpty {
                            Text(currentRecord.thankNote)
                                .font(.body)
                                .foregroundStyle(AppTheme.ink)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("detail.title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        showingEdit = true
                    } label: {
                        Label("action.edit", systemImage: "pencil")
                    }
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("action.delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .accessibilityLabel(Text("action.more"))
            }
        }
        .sheet(isPresented: $showingEdit) {
            RecordFormView(mode: .edit(currentRecord))
        }
        .alert("delete.title", isPresented: $showingDeleteAlert) {
            Button("action.cancel", role: .cancel) {}
            Button("action.delete", role: .destructive) {
                store.delete(currentRecord)
                dismiss()
            }
        } message: {
            Text("delete.message")
        }
    }
}

private struct DetailBlock<Content: View>: View {
    let title: LocalizedStringKey
    let symbolName: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: symbolName)
                .font(.headline)
                .foregroundStyle(AppTheme.ink)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(AppTheme.paper)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct ImpactBadge: View {
    let impact: KindnessImpact

    var body: some View {
        Text(impact.titleKey)
            .font(.caption.weight(.bold))
            .foregroundStyle(AppTheme.sage)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(AppTheme.sage.opacity(0.13))
            .clipShape(Capsule())
    }
}

struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let items: Data
    @ViewBuilder let content: (Data.Element) -> Content

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 8) {
                ForEach(Array(items), id: \.self) { item in
                    content(item)
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(items), id: \.self) { item in
                    content(item)
                }
            }
        }
    }
}
