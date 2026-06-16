import SwiftUI
import PhotosUI
import UIKit

struct AddCoffeeView: View {
    var store: CoffeeStore
    @Environment(\.dismiss) private var dismiss

    @State private var cafeName = ""
    @State private var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?

    @State private var showingSourceDialog = false
    @State private var showingCamera = false
    @State private var showingPhotoPicker = false

    @State private var cardAppeared = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.cafeBg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 36) {
                        // Photo card
                        photoTapArea
                            .scaleEffect(cardAppeared ? 1 : 0.88)
                            .opacity(cardAppeared ? 1 : 0)

                        // Cafe name field
                        cafeNameField
                            .opacity(cardAppeared ? 1 : 0)

                        Spacer(minLength: 40)
                    }
                    .padding(.top, 32)
                }

                // Save button pinned above keyboard
                VStack {
                    Spacer()
                    saveButton
                        .padding(.bottom, 40)
                        .opacity(cardAppeared ? 1 : 0)
                }
            }
            .navigationTitle("new moment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.cafeBg, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("cancel") { dismiss() }
                        .font(.system(size: 16, weight: .light))
                        .foregroundStyle(Color.cafeText.opacity(0.5))
                }
            }
            .confirmationDialog("Add Photo", isPresented: $showingSourceDialog, titleVisibility: .visible) {
                Button("Take Photo") { showingCamera = true }
                Button("Choose from Library") { showingPhotoPicker = true }
                Button("Cancel", role: .cancel) {}
            }
            .sheet(isPresented: $showingCamera) {
                CameraPickerView(image: $selectedImage)
                    .ignoresSafeArea()
            }
            .photosPicker(
                isPresented: $showingPhotoPicker,
                selection: $selectedItem,
                matching: .images
            )
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    guard let data = try? await newItem?.loadTransferable(type: Data.self),
                          let img = UIImage(data: data)
                    else { return }
                    selectedImage = img
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.7)) {
                cardAppeared = true
            }
        }
    }

    // MARK: Sub-views

    private var photoTapArea: some View {
        Button { showingSourceDialog = true } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(red: 0.91, green: 0.88, blue: 0.84))
                    .frame(width: 200, height: 267)

                if let img = selectedImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 267)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .overlay(alignment: .bottomTrailing) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(.white.opacity(0.85))
                                .shadow(radius: 4)
                                .padding(12)
                        }
                } else {
                    VStack(spacing: 14) {
                        Image(systemName: "camera")
                            .font(.system(size: 34, weight: .ultraLight))
                            .foregroundStyle(Color.cafeText.opacity(0.45))
                        Text("add a photo")
                            .font(.system(size: 14, weight: .light))
                            .foregroundStyle(Color.cafeText.opacity(0.40))
                    }
                }
            }
            .shadow(color: .black.opacity(0.09), radius: 18, x: 0, y: 8)
        }
        .buttonStyle(.plain)
    }

    private var cafeNameField: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("café name")
                .font(.system(size: 11, weight: .light))
                .tracking(2.5)
                .foregroundStyle(Color.cafeText.opacity(0.42))

            TextField(
                "",
                text: $cafeName,
                prompt: Text("where was this moment?")
                    .foregroundColor(Color.cafeText.opacity(0.30))
            )
            .font(.system(size: 20, weight: .light, design: .serif))
            .foregroundStyle(Color.cafeText.opacity(0.80))
            .tint(Color.cafeText.opacity(0.6))
            .padding(.bottom, 10)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Color.cafeText.opacity(0.18))
                    .frame(height: 1)
            }
        }
        .padding(.horizontal, 40)
    }

    private var saveButton: some View {
        let canSave = !cafeName.trimmingCharacters(in: .whitespaces).isEmpty
        return Button { saveEntry() } label: {
            Text("add to cloud")
                .font(.system(size: 16, weight: .light))
                .tracking(0.5)
                .foregroundStyle(canSave ? Color.cafeBg : Color.cafeText.opacity(0.30))
                .padding(.horizontal, 48)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(canSave ? Color.cafeText.opacity(0.72) : Color.cafeText.opacity(0.10))
                )
        }
        .disabled(!canSave)
        .animation(.easeOut(duration: 0.2), value: canSave)
    }

    private func saveEntry() {
        let imagePath = selectedImage.flatMap { store.saveImage($0) }
        store.add(CoffeeEntry(cafeName: cafeName.trimmingCharacters(in: .whitespaces), imagePath: imagePath))
        dismiss()
    }
}

// MARK: Camera wrapper

struct CameraPickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPickerView
        init(_ parent: CameraPickerView) { self.parent = parent }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            parent.image = info[.originalImage] as? UIImage
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
