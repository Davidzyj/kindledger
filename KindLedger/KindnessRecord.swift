import Foundation
import SwiftUI

enum KindnessCategory: String, Codable, CaseIterable, Identifiable {
    case listening
    case practicalHelp
    case encouragement
    case protection
    case opportunity
    case companionship
    case teaching
    case other

    var id: String { rawValue }

    var titleKey: LocalizedStringKey {
        switch self {
        case .listening: "category.listening"
        case .practicalHelp: "category.practicalHelp"
        case .encouragement: "category.encouragement"
        case .protection: "category.protection"
        case .opportunity: "category.opportunity"
        case .companionship: "category.companionship"
        case .teaching: "category.teaching"
        case .other: "category.other"
        }
    }

    var symbolName: String {
        switch self {
        case .listening: "ear"
        case .practicalHelp: "hand.raised.fill"
        case .encouragement: "sparkles"
        case .protection: "shield.lefthalf.filled"
        case .opportunity: "door.left.hand.open"
        case .companionship: "person.2.fill"
        case .teaching: "book.closed.fill"
        case .other: "heart.fill"
        }
    }
}

enum KindnessImpact: String, Codable, CaseIterable, Identifiable {
    case small
    case meaningful
    case turningPoint

    var id: String { rawValue }

    var titleKey: LocalizedStringKey {
        switch self {
        case .small: "impact.small"
        case .meaningful: "impact.meaningful"
        case .turningPoint: "impact.turningPoint"
        }
    }
}

struct KindnessRecord: Codable, Identifiable, Equatable {
    var id: UUID
    var personName: String
    var title: String
    var story: String
    var date: Date
    var place: String
    var category: KindnessCategory
    var impact: KindnessImpact
    var tags: [String]
    var isThanked: Bool
    var thankNote: String
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        personName: String = "",
        title: String = "",
        story: String = "",
        date: Date = .now,
        place: String = "",
        category: KindnessCategory = .encouragement,
        impact: KindnessImpact = .meaningful,
        tags: [String] = [],
        isThanked: Bool = false,
        thankNote: String = "",
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.personName = personName
        self.title = title
        self.story = story
        self.date = date
        self.place = place
        self.category = category
        self.impact = impact
        self.tags = tags
        self.isThanked = isThanked
        self.thankNote = thankNote
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var searchableText: String {
        ([personName, title, story, place, thankNote] + tags).joined(separator: " ").lowercased()
    }

    static var empty: KindnessRecord {
        KindnessRecord()
    }
}

struct PersonSummary: Identifiable, Equatable {
    var id: String { name }
    let name: String
    let records: [KindnessRecord]

    var totalCount: Int { records.count }
    var unthankedCount: Int { records.filter { !$0.isThanked }.count }
    var latestDate: Date { records.map(\.date).max() ?? .now }
}
