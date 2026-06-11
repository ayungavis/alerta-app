import Foundation
import SwiftData

struct CustomPattern: Identifiable {
    let id: UUID
    let name: String
    let steps: [RecordedStep]
}

@Observable
@MainActor
final class HapticsSettingsViewModel {
    var selections: [Urgency: String] = [:]

    let availablePatterns: [String] = [
        "Steady Alert",
        "Rapid Pulse",
        "Heartbeat",
        "S.O.S.",
        "Staccato"
    ]

    var customPatterns: [CustomPattern] = []

    private let modelContext: ModelContext
    private var settingsRecord: UserSettingsModel?
    private weak var boundService: CoreHapticService?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadSettings()
    }

    /// Convenience init used by SettingsView: loads settings *and* immediately
    /// pushes them to the shared service so there is never a window where the
    /// service holds stale/default values.
    init(modelContext: ModelContext, hapticService: CoreHapticService) {
        self.modelContext = modelContext
        loadSettings()
        bind(to: hapticService)
    }

    // MARK: - Public

    func bind(to service: CoreHapticService) {
        boundService = service
        pushToService(service)
    }

    func selectPattern(_ pattern: String, for level: Urgency) {
        selections[level] = pattern
        settingsRecord?.hapticSelections[level.storageKey] = pattern
        save()
        syncBoundService()
    }

    func addCustomPattern(name: String, steps: [RecordedStep]) {
        let model = CustomPatternModel(name: name, steps: steps)
        modelContext.insert(model)
        save()
        customPatterns.append(CustomPattern(id: model.id, name: name, steps: steps))
        syncBoundService()
    }

    private func syncBoundService() {
        if let service = boundService {
            pushToService(service)
        } else {
            print(
                "[HapticsSettingsViewModel] syncBoundService called but boundService is nil — bind(to:) was never called or service was deallocated"
            )
        }
    }

    private func pushToService(_ service: CoreHapticService) {
        service.selections = selections
        service.customPatterns = customPatterns
        print(
            "[HapticsSettingsViewModel] pushed to service — selections: \(selections.map { "\($0.key.storageKey)=\($0.value)" }.sorted()), customPatterns: \(customPatterns.map(\.name))"
        )
    }

    private func loadSettings() {
        let settingsDescriptor = FetchDescriptor<UserSettingsModel>()
        let existingSettings = try? modelContext.fetch(settingsDescriptor)

        if let record = existingSettings?.first {
            settingsRecord = record
            for urgency in Urgency.allCases {
                selections[urgency] = record.hapticSelections[urgency.storageKey]
            }
        } else {
            let defaults: [String: String] = Dictionary(
                uniqueKeysWithValues: Urgency.allCases.map {
                    ($0.storageKey, $0.defaultPatternName)
                }
            )
            let newRecord = UserSettingsModel(hapticSelections: defaults)
            modelContext.insert(newRecord)
            settingsRecord = newRecord
            save()

            for urgency in Urgency.allCases {
                selections[urgency] = defaults[urgency.storageKey]
            }
        }

        let patternDescriptor = FetchDescriptor<CustomPatternModel>(
            sortBy: [SortDescriptor(\.name)]
        )
        let savedPatterns = (try? modelContext.fetch(patternDescriptor)) ?? []
        customPatterns = savedPatterns.map {
            CustomPattern(id: $0.id, name: $0.name, steps: $0.steps)
        }

        print(
            "[HapticsSettingsViewModel] loadSettings complete — selections: \(selections.map { "\($0.key.storageKey)=\($0.value)" }.sorted())"
        )
    }

    private func save() {
        try? modelContext.save()
    }
}
