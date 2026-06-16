import SwiftUI

// MARK: - Journal list

struct JournalView: View {
    @Environment(CoffeeStore.self) var store
    @State private var showAdd = false
    @State private var editingEntry: CoffeeEntry?

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                if store.entries.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(store.entries) { entry in
                                EntryCard(entry: entry)
                                    .onTapGesture { editingEntry = entry }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 110)
                    }
                    .scrollIndicators(.hidden)
                }

                // FAB
                Button { showAdd = true } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.cbDark)
                        .frame(width: 54, height: 54)
                        .background(Color.cbYellow)
                        .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
                        .shadow(color: Color.cbYellow.opacity(0.55), radius: 14, y: 5)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Diário")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Text(store.entries.count == 1 ? "1 registro" : "\(store.entries.count) registros")
                        .font(.caption.bold())
                        .foregroundStyle(.white.opacity(0.4))
                }
            }
        }
        .sheet(isPresented: $showAdd) { AddEntryView() }
        .sheet(item: $editingEntry) { entry in AddEntryView(entry: entry) }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "cup.and.saucer.fill")
                .font(.system(size: 56))
                .foregroundStyle(.white.opacity(0.15))
            Text("Nenhum registro ainda")
                .font(.title3.bold())
                .foregroundStyle(.white.opacity(0.6))
            Text("Toque em + para adicionar\nsua primeira xícara")
                .font(.callout)
                .foregroundStyle(.white.opacity(0.32))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Entry card

struct EntryCard: View {
    let entry: CoffeeEntry
    @Environment(CoffeeStore.self) var store

    private var isBest: Bool  { store.bestEntry?.id  == entry.id }
    private var isWorst: Bool { store.worstEntry?.id == entry.id }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Photo
            if let img = entry.image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 190)
                    .clipped()
            }

            // Info
            VStack(alignment: .leading, spacing: 10) {

                // Method + score
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(entry.method?.rawValue ?? "Método Livre")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundStyle(Color.cbCream)
                        if let tech = entry.technique {
                            Text(tech.rawValue)
                                .font(.caption.bold())
                                .foregroundStyle(Color.cbGreenLight)
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        Text(String(format: "%.1f", entry.overall))
                            .font(.system(size: 32, weight: .heavy))
                            .foregroundStyle(Color.cbYellow)
                            .monospacedDigit()
                        Text("/ 5")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.3))
                    }
                }

                // Chips row
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        chip(entry.date.formatted(.dateTime.day().month(.abbreviated).hour().minute()))
                        if let c = entry.coffee { chip("\(Int(c))g café") }
                        if let w = entry.water  { chip("\(Int(w))g água") }
                        if let r = entry.ratio  { chip(r) }
                        if !entry.brewTime.isEmpty { chip(entry.brewTime) }
                    }
                }

                // Dots + badge
                HStack(alignment: .center, spacing: 14) {
                    dotGroup("Amargor", v: entry.bitterness)
                    dotGroup("Doçura",  v: entry.sweetness)
                    dotGroup("Acidez",  v: entry.acidity)
                    dotGroup("Corpo",   v: entry.bodyScore)
                    Spacer()
                    if isBest  { badge("★ Melhor", .cbGreenLight) }
                    if isWorst { badge("▾ Pior",   Color(red: 0.72, green: 0.2, blue: 0.17)) }
                }
            }
            .padding(14)
        }
        .background {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .strokeBorder(
                            isBest  ? Color.cbGreenLight.opacity(0.45) :
                            isWorst ? Color.red.opacity(0.3) :
                                      Color.white.opacity(0.14),
                            lineWidth: 1
                        )
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.38), radius: 14, y: 5)
    }

    // MARK: Sub-views

    private func chip(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(.white.opacity(0.58))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
    }

    private func dotGroup(_ label: String, v: Double) -> some View {
        VStack(spacing: 3) {
            Text(label)
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(.white.opacity(0.28))
                .textCase(.uppercase)
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { i in
                    Circle()
                        .fill(Double(i) < v.rounded() ? Color.cbGreenLight : Color.white.opacity(0.1))
                        .frame(width: 5, height: 5)
                }
            }
        }
    }

    private func badge(_ text: String, _ color: Color) -> some View {
        Text(text)
            .font(.system(size: 9, weight: .bold))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
    }
}
