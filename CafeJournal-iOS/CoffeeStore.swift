import Foundation
import Observation

@Observable
final class CoffeeStore {
    var entries: [CoffeeEntry] = []

    private let key = "cb_journal_v1"

    init() { load() }

    // MARK: CRUD

    func add(_ entry: CoffeeEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: CoffeeEntry) {
        guard let i = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[i] = entry
        save()
    }

    func delete(_ entry: CoffeeEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    // MARK: Derived

    var bestEntry: CoffeeEntry? {
        guard entries.count >= 2 else { return nil }
        return entries.max(by: { $0.overall < $1.overall })
    }

    var worstEntry: CoffeeEntry? {
        guard entries.count >= 2 else { return nil }
        return entries.min(by: { $0.overall < $1.overall })
    }

    func avgRating(_ kp: KeyPath<CoffeeEntry, Double>) -> Double {
        guard !entries.isEmpty else { return 0 }
        let sum = entries.reduce(0.0) { $0 + $1[keyPath: kp] }
        return sum / Double(entries.count)
    }

    // MARK: Persistence

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let decoded = try? JSONDecoder().decode([CoffeeEntry].self, from: data)
        else { return }
        entries = decoded
    }
}
