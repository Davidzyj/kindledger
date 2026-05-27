import SwiftUI

enum RecordFormMode: Identifiable {
    case create
    case edit(KindnessRecord)

    var id: String {
        switch self {
        case .create: "create"
        case .edit(let record): record.id.uuidString
        }
    }
}

struct RecordFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: RecordStore

    let mode: RecordFormMode

    @State private var personName = ""
    @State private var title = ""
    @State private var story = ""
    @State private var date = Date.now
    @State private var place = ""
    @State private var category: KindnessCategory = .encouragement
    @State private var impact: KindnessImpact = .meaningful
    @State private var tagsText = ""
    @State private var isThanked = false
    @State private var thankNote = ""

    private var isEditing: Bool {
        if case .edit = mode { return true }
        return false
    }

    private var canSave: Bool {
        !personName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !story.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("form.section.person") {
                    TextField("form.person.placeholder", text: $personName)
                    TextField("form.title.placeholder", text: $title)
                }

                Section("form.section.kindness") {
                    TextField("form.story.placeholder", text: $story, axis: .vertical)
                        .lineLimit(4...8)
                    DatePicker("form.date", selection: $date, displayedComponents: .date)
                    TextField("form.place.placeholder", text: $place)
                }

                Section("form.section.context") {
                    Picker("form.category", selection: $category) {
                        ForEach(KindnessCategory.allCases) { category in
                            Label(category.titleKey, systemImage: category.symbolName)
                                .tag(category)
                        }
                    }
                    Picker("form.impact", selection: $impact) {
                        ForEach(KindnessImpact.allCases) { impact in
                            Text(impact.titleKey).tag(impact)
                        }
                    }
                    TextField("form.tags.placeholder", text: $tagsText)
                        .textInputAutocapitalization(.never)
                }

                Section("form.section.thanks") {
                    Toggle("form.thanked", isOn: $isThanked)
                    TextField("form.thankNote.placeholder", text: $thankNote, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.background)
            .navigationTitle(isEditing ? "form.title.edit" : "form.title.new")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("action.cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("action.save") {
                        save()
                    }
                    .disabled(!canSave)
                }
            }
            .onAppear(perform: populate)
        }
    }

    private func populate() {
        guard case .edit(let record) = mode else { return }
        personName = record.personName
        title = record.title
        story = record.story
        date = record.date
        place = record.place
        category = record.category
        impact = record.impact
        tagsText = record.tags.joined(separator: ", ")
        isThanked = record.isThanked
        thankNote = record.thankNote
    }

    private func save() {
        let tags = tagsText
            .split { $0 == "," || $0 == "，" || $0 == "#" }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let record = KindnessRecord(
            id: existingID ?? UUID(),
            personName: personName.trimmingCharacters(in: .whitespacesAndNewlines),
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            story: story.trimmingCharacters(in: .whitespacesAndNewlines),
            date: date,
            place: place.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category,
            impact: impact,
            tags: tags,
            isThanked: isThanked,
            thankNote: thankNote.trimmingCharacters(in: .whitespacesAndNewlines),
            createdAt: existingCreatedAt ?? .now,
            updatedAt: .now
        )

        if isEditing {
            store.update(record)
        } else {
            store.add(record)
        }

        dismiss()
    }

    private var existingID: UUID? {
        guard case .edit(let record) = mode else { return nil }
        return record.id
    }

    private var existingCreatedAt: Date? {
        guard case .edit(let record) = mode else { return nil }
        return record.createdAt
    }
}
