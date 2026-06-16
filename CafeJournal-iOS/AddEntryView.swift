import SwiftUI
import PhotosUI

struct AddEntryView: View {
    @Environment(CoffeeStore.self) var store
    @Environment(\.dismiss) var dismiss

    private let existing: CoffeeEntry?
    @State private var entry: CoffeeEntry
    @State private var photoItem: PhotosPickerItem?
    @State private var showDeleteAlert = false

    init(entry: CoffeeEntry? = nil) {
        existing = entry
        _entry = State(initialValue: entry ?? CoffeeEntry())
    }

    var isEditing: Bool { existing != nil }

    // MARK: Body

    var body: some View {
        NavigationStack {
            Form {
                photoSection
                dateSection
                methodSection
                techniqueSection
                quantitiesSection
                ratingsSection
                notesSection
                if isEditing { deleteSection }
            }
            .scrollContentBackground(.hidden)
            .background(Color.cbCream.opacity(0.96))
            .navigationTitle(isEditing ? "Editar Xícara" : "Nova Xícara")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                        .foregroundStyle(Color.cbGreen)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") { saveAndDismiss() }
                        .bold()
                        .foregroundStyle(Color.cbGreen)
                }
            }
        }
        .onChange(of: photoItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    entry.photoData = data
                }
            }
        }
        .alert("Remover registro?", isPresented: $showDeleteAlert) {
            Button("Remover", role: .destructive) {
                if let e = existing { store.delete(e) }
                dismiss()
            }
            Button("Cancelar", role: .cancel) {}
        }
    }

    // MARK: Sections

    private var photoSection: some View {
        Section("Foto") {
            PhotosPicker(selection: $photoItem, matching: .images) {
                if let img = entry.image {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                } else {
                    Label("Adicionar foto", systemImage: "camera.fill")
                        .font(.callout.bold())
                        .foregroundStyle(Color.cbGreen)
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                }
            }
            .listRowInsets(.init(top: 8, leading: 12, bottom: 8, trailing: 12))
        }
    }

    private var dateSection: some View {
        Section("Data e Hora") {
            DatePicker("Data", selection: $entry.date, displayedComponents: .date)
                .tint(Color.cbGreen)
            DatePicker("Hora", selection: $entry.date, displayedComponents: .hourAndMinute)
                .tint(Color.cbGreen)
        }
    }

    private var methodSection: some View {
        Section("Método de Preparo") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(BrewMethod.allCases) { m in
                        ChipButton(label: m.rawValue, isOn: entry.method == m) {
                            entry.method = entry.method == m ? nil : m
                        }
                    }
                }
                .padding(.vertical, 6)
            }
            .listRowInsets(.init(top: 4, leading: 12, bottom: 4, trailing: 12))
        }
    }

    private var techniqueSection: some View {
        Section("Técnica") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(BrewTechnique.allCases) { t in
                        ChipButton(label: t.rawValue, isOn: entry.technique == t) {
                            entry.technique = entry.technique == t ? nil : t
                        }
                    }
                }
                .padding(.vertical, 6)
            }
            .listRowInsets(.init(top: 4, leading: 12, bottom: 4, trailing: 12))
        }
    }

    private var quantitiesSection: some View {
        Section("Quantidades") {
            HStack {
                Text("Café")
                Spacer()
                TextField("15", value: $entry.coffee, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 70)
                Text("g").foregroundStyle(.secondary)
            }
            HStack {
                Text("Água")
                Spacer()
                TextField("250", value: $entry.water, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 70)
                Text("g").foregroundStyle(.secondary)
            }
            if let ratio = entry.ratio {
                HStack {
                    Text("Proporção").foregroundStyle(.secondary)
                    Spacer()
                    Text(ratio)
                        .bold()
                        .foregroundStyle(Color.cbGreen)
                }
            }
            HStack {
                Text("Tempo de Preparo")
                Spacer()
                TextField("3:00", text: $entry.brewTime)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 70)
            }
        }
    }

    private var ratingsSection: some View {
        Section("Avaliação dos Sabores  ·  0 – 5") {
            ratingRow("Amargor",   value: $entry.bitterness)
            ratingRow("Doçura",    value: $entry.sweetness)
            ratingRow("Acidez",    value: $entry.acidity)
            ratingRow("Corpo",     value: $entry.bodyScore)
            Divider().listRowBackground(Color.clear)
            ratingRow("Nota Geral", value: $entry.overall, accent: Color.cbYellowDark, valueFont: .title2)
        }
    }

    private func ratingRow(
        _ label: String,
        value: Binding<Double>,
        accent: Color = Color.cbGreen,
        valueFont: Font = .title3
    ) -> some View {
        VStack(spacing: 6) {
            HStack {
                Text(label)
                    .font(.callout.bold())
                    .foregroundStyle(accent == Color.cbGreen ? Color.cbDark : accent)
                Spacer()
                Text(String(format: "%.1f", value.wrappedValue))
                    .font(valueFont.bold())
                    .foregroundStyle(accent)
                    .monospacedDigit()
                    .frame(minWidth: 36, alignment: .trailing)
            }
            Slider(value: value, in: 0...5, step: 0.5)
                .tint(accent)
        }
        .padding(.vertical, 4)
    }

    private var notesSection: some View {
        Section("Notas") {
            TextField("Aromas, texturas, impressões…", text: $entry.notes, axis: .vertical)
                .lineLimit(3...6)
        }
    }

    private var deleteSection: some View {
        Section {
            Button(role: .destructive) {
                showDeleteAlert = true
            } label: {
                HStack {
                    Spacer()
                    Text("Remover Registro")
                        .bold()
                    Spacer()
                }
            }
        }
    }

    // MARK: Save

    private func saveAndDismiss() {
        if isEditing { store.update(entry) } else { store.add(entry) }
        dismiss()
    }
}

// MARK: - Chip button

struct ChipButton: View {
    let label: String
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(label, action: action)
            .font(.callout.bold())
            .foregroundStyle(isOn ? Color.white : Color.cbGreen)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isOn ? Color.cbGreen : Color.cbGreen.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(Color.cbGreen.opacity(isOn ? 0 : 0.25), lineWidth: 1)
            }
            .animation(.spring(duration: 0.2), value: isOn)
    }
}
