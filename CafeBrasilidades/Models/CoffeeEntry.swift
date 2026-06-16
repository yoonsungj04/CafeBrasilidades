import Foundation
import Observation

struct CoffeeEntry: Identifiable, Codable {
    var id = UUID()
    var cafeName: String
    var imagePath: String?
    var dateAdded: Date = Date()
    var positionX: Double
    var positionY: Double
    var rotation: Double
    var phaseOffset: Double
    var floatAmplitude: Double
    var floatDurationX: Double
    var floatDurationY: Double

    init(cafeName: String, imagePath: String? = nil) {
        self.cafeName = cafeName
        self.imagePath = imagePath
        self.positionX = Double.random(in: 0.12...0.82)
        self.positionY = Double.random(in: 0.18...0.80)
        self.rotation = Double.random(in: -7...7)
        self.phaseOffset = Double.random(in: 0...(2 * .pi))
        self.floatAmplitude = Double.random(in: 5...12)
        self.floatDurationX = Double.random(in: 2.8...4.2)
        self.floatDurationY = Double.random(in: 3.2...5.0)
    }
}

@Observable
class CoffeeStore {
    var entries: [CoffeeEntry] = []

    private let saveKey = "coffee_entries_v1"

    init() { load() }

    func add(_ entry: CoffeeEntry) {
        entries.append(entry)
        save()
    }

    func remove(id: UUID) {
        if let path = entries.first(where: { $0.id == id })?.imagePath {
            try? FileManager.default.removeItem(atPath: path)
        }
        entries.removeAll { $0.id == id }
        save()
    }

    func updatePosition(id: UUID, x: Double, y: Double) {
        guard let idx = entries.firstIndex(where: { $0.id == id }) else { return }
        entries[idx].positionX = max(0.05, min(0.90, x))
        entries[idx].positionY = max(0.08, min(0.88, y))
        save()
    }

    func saveImage(_ data: Data) -> String? {
        let filename = UUID().uuidString + ".jpg"
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = docs.appendingPathComponent(filename)
        try? data.write(to: url)
        return url.path
    }

    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let saved = try? JSONDecoder().decode([CoffeeEntry].self, from: data)
        else { return }
        entries = saved
    }
}
