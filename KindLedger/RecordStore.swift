import Foundation

@MainActor
final class RecordStore: ObservableObject {
    @Published private(set) var records: [KindnessRecord] = []
    @Published var hasLoaded = false

    private let fileName = "kindness-records.json"

    init() {
        if ScreenshotConfig.screen != nil {
            records = Self.sampleRecords(localeIdentifier: ScreenshotConfig.localeIdentifier)
            hasLoaded = true
        } else {
            load()
        }
    }

    var sortedRecords: [KindnessRecord] {
        records.sorted { $0.date > $1.date }
    }

    var people: [PersonSummary] {
        Dictionary(grouping: records, by: { normalizedName($0.personName) })
            .map { PersonSummary(name: $0.key, records: $0.value.sorted { $0.date > $1.date }) }
            .sorted {
                if $0.latestDate == $1.latestDate {
                    return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                }
                return $0.latestDate > $1.latestDate
            }
    }

    var unthankedCount: Int {
        records.filter { !$0.isThanked }.count
    }

    var uniquePeopleCount: Int {
        Set(records.map { normalizedName($0.personName) }).count
    }

    func add(_ record: KindnessRecord) {
        var copy = record
        copy.createdAt = .now
        copy.updatedAt = .now
        records.append(copy)
        save()
    }

    func update(_ record: KindnessRecord) {
        guard let index = records.firstIndex(where: { $0.id == record.id }) else { return }
        var copy = record
        copy.updatedAt = .now
        records[index] = copy
        save()
    }

    func delete(_ record: KindnessRecord) {
        records.removeAll { $0.id == record.id }
        save()
    }

    func toggleThanked(_ record: KindnessRecord) {
        guard let index = records.firstIndex(where: { $0.id == record.id }) else { return }
        records[index].isThanked.toggle()
        records[index].updatedAt = .now
        save()
    }

    func records(for person: PersonSummary) -> [KindnessRecord] {
        records
            .filter { normalizedName($0.personName) == person.name }
            .sorted { $0.date > $1.date }
    }

    private func load() {
        defer { hasLoaded = true }

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            records = Self.sampleRecords()
            save()
            return
        }

        do {
            let data = try Data(contentsOf: fileURL)
            records = try JSONDecoder.appDecoder.decode([KindnessRecord].self, from: data)
        } catch {
            records = Self.sampleRecords()
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder.appEncoder.encode(records)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            assertionFailure("Failed to save records: \(error.localizedDescription)")
        }
    }

    private var fileURL: URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directory.appending(path: fileName)
    }

    private func normalizedName(_ value: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? String(localized: "person.unknown") : trimmed
    }

    private static func sampleRecords(localeIdentifier: String = Locale.current.identifier) -> [KindnessRecord] {
        if localeIdentifier.hasPrefix("zh") {
            return [
                KindnessRecord(
                    personName: "陈老师",
                    title: "他帮我看清下一步",
                    story: "他耐心看完我粗糙的计划，指出了最值得先做的一件事。",
                    date: Calendar.current.date(byAdding: .day, value: -3, to: .now) ?? .now,
                    place: "工作室",
                    category: .teaching,
                    impact: .turningPoint,
                    tags: ["工作", "方向"],
                    isThanked: false,
                    thankNote: "告诉他那条建议改变了我的开始方式。"
                ),
                KindnessRecord(
                    personName: "林娜",
                    title: "她陪我度过了艰难的晚上",
                    story: "她在我很崩溃的时候一直陪我通电话，帮我做出了下一个小决定。",
                    date: Calendar.current.date(byAdding: .day, value: -12, to: .now) ?? .now,
                    place: "家里",
                    category: .companionship,
                    impact: .meaningful,
                    tags: ["友情"],
                    isThanked: true,
                    thankNote: "周末给她发一条安静的感谢消息。"
                )
            ]
        }

        return [
            KindnessRecord(
                personName: "Mr. Chen",
                title: "He helped me see the next step",
                story: "He reviewed my rough plan patiently and pointed out the one thing worth focusing on first.",
                date: Calendar.current.date(byAdding: .day, value: -3, to: .now) ?? .now,
                place: "Studio",
                category: .teaching,
                impact: .turningPoint,
                tags: ["work", "direction"],
                isThanked: false,
                thankNote: "Tell him the advice changed how I started."
            ),
            KindnessRecord(
                personName: "Lena",
                title: "She sat with me through a hard evening",
                story: "She stayed on the phone while I was overwhelmed and helped me make the next small decision.",
                date: Calendar.current.date(byAdding: .day, value: -12, to: .now) ?? .now,
                place: "Home",
                category: .companionship,
                impact: .meaningful,
                tags: ["friendship"],
                isThanked: true,
                thankNote: "Send a quiet thank-you message this weekend."
            )
        ]
    }
}

private extension JSONEncoder {
    static var appEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }
}

private extension JSONDecoder {
    static var appDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
