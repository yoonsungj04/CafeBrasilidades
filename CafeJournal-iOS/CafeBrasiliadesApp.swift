import SwiftUI

@main
struct CafeBrasiliadesApp: App {
    @State private var store = CoffeeStore()

    init() {
        // Dark tab bar glass
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithTransparentBackground()
        tabAppearance.backgroundColor = UIColor(white: 0.04, alpha: 0.88)
        UITabBar.appearance().standardAppearance   = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance

        // Transparent nav bar
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(Color.cbCream)
        ]
        navAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color.cbCream),
            .font: UIFont(name: "ArchivoBlack-Regular", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .heavy)
        ]
        UINavigationBar.appearance().standardAppearance   = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().tintColor = UIColor(Color.cbYellow)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }
}
