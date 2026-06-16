import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient.cbBackground
                .ignoresSafeArea()

            TabView {
                JournalView()
                    .tabItem {
                        Label("Diário", systemImage: "list.bullet.clipboard.fill")
                    }

                InsightsView()
                    .tabItem {
                        Label("Insights", systemImage: "chart.xyaxis.line")
                    }
            }
            .tint(Color.cbYellow)
        }
    }
}
