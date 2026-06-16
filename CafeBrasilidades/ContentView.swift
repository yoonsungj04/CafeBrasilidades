import SwiftUI

struct ContentView: View {
    @State private var store = CoffeeStore()
    @State private var showingAddCoffee = false
    @State private var headerVisible = false

    var body: some View {
        ZStack(alignment: .bottom) {
            PhotoCloudView(store: store)

            // Minimal header
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("café")
                            .font(.system(size: 13, weight: .light))
                            .tracking(4)
                            .foregroundStyle(Color.cafeText.opacity(0.45))
                        Text("brasilidades")
                            .font(.system(size: 22, weight: .light, design: .serif))
                            .foregroundStyle(Color.cafeText.opacity(0.65))
                    }
                    Spacer()
                    if !store.entries.isEmpty {
                        Text("\(store.entries.count)")
                            .font(.system(size: 13, weight: .light, design: .monospaced))
                            .foregroundStyle(Color.cafeText.opacity(0.35))
                    }
                }
                .padding(.horizontal, 28)
                .padding(.top, 60)
                .padding(.bottom, 16)
                .background(
                    LinearGradient(
                        colors: [Color.cafeBg.opacity(0.95), Color.cafeBg.opacity(0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .opacity(headerVisible ? 1 : 0)

                Spacer()
            }

            // Add button
            Button {
                showingAddCoffee = true
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.cafeBg)
                        .shadow(color: .black.opacity(0.10), radius: 16, x: 0, y: 6)
                        .frame(width: 56, height: 56)
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .light))
                        .foregroundStyle(Color.cafeText.opacity(0.65))
                }
            }
            .padding(.bottom, 44)
            .opacity(headerVisible ? 1 : 0)
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showingAddCoffee) {
            AddCoffeeView(store: store)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.7).delay(0.3)) {
                headerVisible = true
            }
        }
    }
}
