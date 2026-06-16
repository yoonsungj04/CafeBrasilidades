import Foundation
import SwiftUI
import UIKit

// MARK: - Enums

enum BrewMethod: String, CaseIterable, Codable, Identifiable {
    case v60 = "V60"
    case chemex = "Chemex"
    case aeropress = "AeroPress"
    case frenchPress = "French Press"
    case moka = "Moka"
    case espresso = "Espresso"
    case coldBrew = "Cold Brew"
    case livre = "Livre"
    var id: String { rawValue }
}

enum BrewTechnique: String, CaseIterable, Codable, Identifiable {
    case jamesHoffman = "James Hoffman"
    case kasuya = "4:6 Kasuya"
    case scottRao = "Scott Rao"
    case osmoticFlow = "Osmotic Flow"
    case livre = "Livre"
    var id: String { rawValue }
}

// MARK: - Entry

struct CoffeeEntry: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date = Date()
    var photoData: Data?
    var method: BrewMethod?
    var technique: BrewTechnique?
    var brewTime: String = ""
    var coffee: Double?
    var water: Double?
    var notes: String = ""
    var bitterness: Double = 0
    var sweetness: Double = 0
    var acidity: Double = 0
    var bodyScore: Double = 0
    var overall: Double = 0

    var ratio: String? {
        guard let c = coffee, let w = water, c > 0 else { return nil }
        return String(format: "1 : %.1f", w / c)
    }

    var image: UIImage? {
        guard let data = photoData else { return nil }
        return UIImage(data: data)
    }
}

// MARK: - Brand colours

extension Color {
    static let cbGreen      = Color(red: 0.102, green: 0.420, blue: 0.227)
    static let cbGreenDeep  = Color(red: 0.051, green: 0.231, blue: 0.129)
    static let cbGreenLight = Color(red: 0.176, green: 0.620, blue: 0.345)
    static let cbYellow     = Color(red: 0.961, green: 0.784, blue: 0.000)
    static let cbYellowDark = Color(red: 0.788, green: 0.635, blue: 0.000)
    static let cbCream      = Color(red: 0.969, green: 0.949, blue: 0.910)
    static let cbDark       = Color(red: 0.051, green: 0.122, blue: 0.078)
}

// MARK: - Background gradient

extension ShapeStyle where Self == LinearGradient {
    static var cbBackground: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: Color(red: 0.020, green: 0.059, blue: 0.027), location: 0),
                .init(color: Color(red: 0.040, green: 0.125, blue: 0.063), location: 0.4),
                .init(color: Color(red: 0.051, green: 0.165, blue: 0.090), location: 0.75),
                .init(color: Color(red: 0.025, green: 0.078, blue: 0.040), location: 1)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
