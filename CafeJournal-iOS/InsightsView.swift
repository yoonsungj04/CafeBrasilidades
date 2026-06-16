import SwiftUI

// MARK: - Insights tab

struct InsightsView: View {
    @Environment(CoffeeStore.self) var store

    var body: some View {
        NavigationStack {
            Group {
                if store.entries.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            summaryGrid
                            radarCard
                            averageBarsCard
                            if let best = store.bestEntry   { highlightCard(best,  isBest: true) }
                            if let worst = store.worstEntry { highlightCard(worst, isBest: false) }
                            calendarCard
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 110)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .navigationTitle("Insights")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: Empty

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.xyaxis.line")
                .font(.system(size: 52))
                .foregroundStyle(.white.opacity(0.15))
            Text("Sem dados ainda")
                .font(.title3.bold())
                .foregroundStyle(.white.opacity(0.6))
            Text("Adicione registros no diário\npara ver suas estatísticas")
                .font(.callout)
                .foregroundStyle(.white.opacity(0.32))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Summary grid

    private var summaryGrid: some View {
        HStack(spacing: 12) {
            glassStatCard(
                label: "Nota Média",
                value: String(format: "%.1f", store.avgRating(\.overall)),
                unit: "/ 5",
                sub: "Nota geral"
            )
            glassStatCard(
                label: "Xícaras",
                value: "\(store.entries.count)",
                unit: nil,
                sub: "Registros"
            )
        }
    }

    private func glassStatCard(label: String, value: String, unit: String?, sub: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .tracking(1.2)
                .textCase(.uppercase)
                .foregroundStyle(.white.opacity(0.38))
            HStack(alignment: .lastTextBaseline, spacing: 3) {
                Text(value)
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundStyle(Color.cbCream)
                    .monospacedDigit()
                if let u = unit {
                    Text(u)
                        .font(.callout)
                        .foregroundStyle(.white.opacity(0.3))
                }
            }
            Text(sub)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.38))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .glassCard()
    }

    // MARK: Radar

    private var radarCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionLabel("Perfil de Sabor · Média")
            HStack {
                Spacer()
                RadarChart(
                    bitterness: store.avgRating(\.bitterness),
                    sweetness:  store.avgRating(\.sweetness),
                    acidity:    store.avgRating(\.acidity),
                    bodyScore:  store.avgRating(\.bodyScore)
                )
                .frame(width: 240, height: 240)
                Spacer()
            }
        }
        .padding(16)
        .glassCard()
    }

    // MARK: Average bars

    private var averageBarsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Média por Dimensão")
            let categories: [(String, KeyPath<CoffeeEntry, Double>)] = [
                ("Amargor",    \.bitterness),
                ("Doçura",     \.sweetness),
                ("Acidez",     \.acidity),
                ("Corpo",      \.bodyScore),
                ("Nota Geral", \.overall),
            ]
            ForEach(categories, id: \.0) { label, kp in
                averageBar(label: label, value: store.avgRating(kp))
            }
        }
        .padding(16)
        .glassCard()
    }

    private func averageBar(label: String, value: Double) -> some View {
        HStack(spacing: 10) {
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.cbCream)
                .frame(width: 72, alignment: .leading)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(.white.opacity(0.08)).frame(height: 5)
                    Capsule()
                        .fill(Color.cbGreenLight)
                        .frame(width: geo.size.width * CGFloat(value / 5), height: 5)
                }
            }
            .frame(height: 5)
            Text(String(format: "%.1f", value))
                .font(.system(size: 13, weight: .heavy))
                .foregroundStyle(Color.cbGreenLight)
                .monospacedDigit()
                .frame(width: 28, alignment: .trailing)
        }
    }

    // MARK: Highlight cards

    private func highlightCard(_ entry: CoffeeEntry, isBest: Bool) -> some View {
        let accent = isBest ? Color.cbGreenLight : Color(red: 0.72, green: 0.2, blue: 0.17)
        return ZStack(alignment: .trailing) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(isBest ? "★ Melhor Xícara" : "▾ Pior Xícara")
                        .font(.system(size: 9, weight: .bold))
                        .tracking(1)
                        .textCase(.uppercase)
                        .foregroundStyle(accent)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background(accent.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Text(entry.method?.rawValue ?? "Método Livre")
                    .font(.system(size: 22, weight: .heavy))
                    .foregroundStyle(Color.cbCream)
                Text("\(entry.date.formatted(.dateTime.day().month(.abbreviated).year()))\(entry.technique.map { "  ·  \($0.rawValue)" } ?? "")")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.42))
            }
            Text(String(format: "%.1f", entry.overall))
                .font(.system(size: 54, weight: .heavy))
                .foregroundStyle(accent.opacity(0.85))
                .monospacedDigit()
                .padding(.trailing, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .glassCard(borderColor: accent.opacity(0.38))
    }

    // MARK: Calendar

    private var calendarCard: some View {
        let now = Date()
        let cal = Calendar.current
        let year = cal.component(.year, from: now)
        let month = cal.component(.month, from: now)
        let today = cal.component(.day, from: now)
        let firstDay = cal.component(.weekday, from: cal.date(from: DateComponents(year: year, month: month, day: 1))!) - 1
        let range = cal.range(of: .day, in: .month, for: now)!
        let daysInMonth = range.count

        let entryDays = Set(
            store.entries.compactMap { e -> Int? in
                let c = cal.dateComponents([.year, .month, .day], from: e.date)
                guard c.year == year, c.month == month else { return nil }
                return c.day
            }
        )
        let monthName = now.formatted(.dateTime.month(.wide).year())

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                sectionLabel("Registros do Mês")
                Spacer()
                Text(monthName)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color.cbGreenLight)
            }

            let weekdays = ["D", "S", "T", "Q", "Q", "S", "S"]
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 7), spacing: 3) {
                ForEach(weekdays, id: \.self) { d in
                    Text(d)
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.white.opacity(0.25))
                        .frame(maxWidth: .infinity)
                }
                ForEach(0..<firstDay, id: \.self) { _ in Color.clear.frame(height: 32) }
                ForEach(1...daysInMonth, id: \.self) { day in
                    ZStack {
                        if day == today {
                            RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color.cbYellow)
                        } else if entryDays.contains(day) {
                            RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color.cbGreen.opacity(0.22))
                        }
                        VStack(spacing: 2) {
                            Text("\(day)")
                                .font(.system(size: 11, weight: day == today || entryDays.contains(day) ? .bold : .regular))
                                .foregroundStyle(day == today ? Color.cbDark : entryDays.contains(day) ? Color.cbCream : .white.opacity(0.3))
                            if entryDays.contains(day) && day != today {
                                Circle().fill(Color.cbGreenLight).frame(width: 4, height: 4)
                            }
                        }
                    }
                    .frame(height: 32)
                }
            }
        }
        .padding(16)
        .glassCard()
    }

    // MARK: Helpers

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .tracking(1.2)
            .textCase(.uppercase)
            .foregroundStyle(.white.opacity(0.38))
    }
}

// MARK: - Radar chart

struct RadarChart: View {
    let bitterness: Double
    let sweetness: Double
    let acidity: Double
    let bodyScore: Double

    private var values: [Double] { [bitterness, sweetness, acidity, bodyScore] }
    private let labels = ["Amargor", "Doçura", "Acidez", "Corpo"]
    private let angles: [Double] = [-90, 0, 90, 180].map { $0 * .pi / 180 }

    var body: some View {
        ZStack {
            Canvas { ctx, size in
                let cx = size.width / 2, cy = size.height / 2
                let maxR = min(cx, cy) * 0.62

                // Grid rings
                for level in 1...5 {
                    let r = Double(level) / 5.0 * maxR
                    var path = Path()
                    for (i, angle) in angles.enumerated() {
                        let pt = CGPoint(x: cx + r * cos(angle), y: cy + r * sin(angle))
                        i == 0 ? path.move(to: pt) : path.addLine(to: pt)
                    }
                    path.closeSubpath()
                    ctx.stroke(path, with: .color(.white.opacity(0.07)), lineWidth: 1)
                }

                // Axes
                for angle in angles {
                    var p = Path()
                    p.move(to: CGPoint(x: cx, y: cy))
                    p.addLine(to: CGPoint(x: cx + maxR * cos(angle), y: cy + maxR * sin(angle)))
                    ctx.stroke(p, with: .color(.white.opacity(0.09)), lineWidth: 1)
                }

                // Data polygon
                var dataPath = Path()
                for (i, (value, angle)) in zip(values, angles).enumerated() {
                    let r = value / 5.0 * maxR
                    let pt = CGPoint(x: cx + r * cos(angle), y: cy + r * sin(angle))
                    i == 0 ? dataPath.move(to: pt) : dataPath.addLine(to: pt)
                }
                dataPath.closeSubpath()
                ctx.fill(dataPath,   with: .color(Color.cbGreen.opacity(0.22)))
                ctx.stroke(dataPath, with: .color(Color.cbGreenLight), style: StrokeStyle(lineWidth: 2, lineJoin: .round))

                // Corner dots
                for (value, angle) in zip(values, angles) {
                    let r = value / 5.0 * maxR
                    let x = cx + r * cos(angle), y = cy + r * sin(angle)
                    let dr: Double = 5
                    ctx.fill(Path(ellipseIn: CGRect(x: x - dr, y: y - dr, width: dr * 2, height: dr * 2)),
                             with: .color(Color.cbGreenLight))
                }
            }

            // Labels
            GeometryReader { geo in
                let cx = geo.size.width / 2, cy = geo.size.height / 2
                let labelR = min(cx, cy) * 0.62 + 22
                ForEach(Array(zip(labels, angles)), id: \.0) { label, angle in
                    Text(label)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white.opacity(0.52))
                        .position(
                            x: cx + labelR * cos(angle),
                            y: cy + labelR * sin(angle)
                        )
                }
            }
        }
    }
}

// MARK: - Glass card modifier

struct GlassCardModifier: ViewModifier {
    var borderColor: Color = .white.opacity(0.14)
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .strokeBorder(borderColor, lineWidth: 1)
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(color: .black.opacity(0.38), radius: 12, y: 4)
    }
}

extension View {
    func glassCard(borderColor: Color = .white.opacity(0.14)) -> some View {
        modifier(GlassCardModifier(borderColor: borderColor))
    }
}
