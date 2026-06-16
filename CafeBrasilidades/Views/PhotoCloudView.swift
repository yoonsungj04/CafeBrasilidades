import SwiftUI

struct PhotoCloudView: View {
    var store: CoffeeStore

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Warm pastel beige background — layered for depth
                Color.cafeBg.ignoresSafeArea()
                RadialGradient(
                    colors: [
                        Color(red: 0.97, green: 0.96, blue: 0.94).opacity(0.6),
                        Color.clear,
                    ],
                    center: .topLeading,
                    startRadius: 0,
                    endRadius: geo.size.width * 0.8
                )
                .ignoresSafeArea()
                RadialGradient(
                    colors: [
                        Color(red: 0.93, green: 0.88, blue: 0.82).opacity(0.4),
                        Color.clear,
                    ],
                    center: .bottomTrailing,
                    startRadius: 0,
                    endRadius: geo.size.width * 0.9
                )
                .ignoresSafeArea()

                if store.entries.isEmpty {
                    EmptyCloudView()
                } else {
                    ForEach(store.entries) { entry in
                        PhotoCardView(
                            entry: entry,
                            containerSize: geo.size,
                            store: store
                        )
                    }
                }
            }
        }
    }
}

struct EmptyCloudView: View {
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.90, green: 0.86, blue: 0.80).opacity(0.5))
                    .frame(width: 96, height: 96)
                Image(systemName: "cup.and.saucer")
                    .font(.system(size: 36, weight: .ultraLight))
                    .foregroundStyle(Color.cafeText.opacity(0.4))
            }
            .scaleEffect(appeared ? 1 : 0.75)

            VStack(spacing: 6) {
                Text("your coffee cloud")
                    .font(.system(size: 18, weight: .light, design: .serif))
                    .foregroundStyle(Color.cafeText.opacity(0.5))
                Text("tap + to capture a moment")
                    .font(.system(size: 13, weight: .light))
                    .tracking(0.5)
                    .foregroundStyle(Color.cafeText.opacity(0.32))
            }
            .opacity(appeared ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.65)) {
                appeared = true
            }
        }
    }
}
