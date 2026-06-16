import SwiftUI

struct PhotoCardView: View {
    let entry: CoffeeEntry
    let containerSize: CGSize
    var store: CoffeeStore

    // Drag physics
    @State private var dragTranslation: CGSize = .zero
    @State private var isDragging = false
    @State private var velocity: CGSize = .zero

    // Ambient float — X and Y animate independently for Lissajous-like drift
    @State private var floatX: CGFloat = 0
    @State private var floatY: CGFloat = 0
    @State private var breathScale: CGFloat = 1.0

    // Context menu long-press
    @State private var showDelete = false

    private let cardWidth: CGFloat = 152
    private var cardHeight: CGFloat { cardWidth * (4.0 / 3.0) }

    private var baseX: CGFloat { CGFloat(entry.positionX) * containerSize.width }
    private var baseY: CGFloat { CGFloat(entry.positionY) * containerSize.height }

    private var tiltAngle: Double {
        isDragging ? Double(dragTranslation.width) * 0.04 : 0
    }

    var body: some View {
        cardContent
            .rotationEffect(.degrees(entry.rotation + tiltAngle))
            .scaleEffect(isDragging ? 1.07 : breathScale)
            .shadow(
                color: .black.opacity(isDragging ? 0.22 : 0.10),
                radius: isDragging ? 22 : 10,
                x: 0,
                y: isDragging ? 12 : 5
            )
            .offset(
                x: baseX - containerSize.width / 2 + dragTranslation.width + (isDragging ? 0 : floatX),
                y: baseY - containerSize.height / 2 + dragTranslation.height + (isDragging ? 0 : floatY)
            )
            .gesture(dragGesture)
            .contextMenu {
                Button(role: .destructive) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        store.remove(id: entry.id)
                    }
                } label: {
                    Label("Remove", systemImage: "trash")
                }
            }
            .animation(.spring(response: 0.38, dampingFraction: 0.62), value: isDragging)
            .onAppear { startFloating() }
    }

    // MARK: Card visual

    private var cardContent: some View {
        ZStack(alignment: .bottom) {
            // Photo or soft placeholder
            Group {
                if let path = entry.imagePath, let uiImg = UIImage(contentsOfFile: path) {
                    Image(uiImage: uiImg)
                        .resizable()
                        .scaledToFill()
                } else {
                    placeholderFill
                }
            }
            .frame(width: cardWidth, height: cardHeight)
            .clipped()

            // Caption bar
            LinearGradient(
                colors: [.clear, .black.opacity(0.50)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: cardHeight * 0.38)

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.cafeName)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Text(entry.dateAdded, format: .dateTime.month(.abbreviated).day().year())
                    .font(.system(size: 10, weight: .light))
                    .foregroundStyle(.white.opacity(0.72))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var placeholderFill: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.86, green: 0.80, blue: 0.73),
                    Color(red: 0.76, green: 0.68, blue: 0.60),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Image(systemName: "cup.and.saucer.fill")
                .font(.system(size: 38, weight: .ultraLight))
                .foregroundStyle(.white.opacity(0.55))
        }
    }

    // MARK: Drag

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                if !isDragging { isDragging = true }
                dragTranslation = value.translation
                velocity = value.velocity
            }
            .onEnded { value in
                // Settle position with slight momentum
                let momentum = CGSize(
                    width: value.velocity.width * 0.08,
                    height: value.velocity.height * 0.08
                )
                let newX = (baseX + value.translation.width + momentum.width) / containerSize.width
                let newY = (baseY + value.translation.height + momentum.height) / containerSize.height
                store.updatePosition(id: entry.id, x: newX, y: newY)

                withAnimation(.spring(response: 0.52, dampingFraction: 0.60)) {
                    isDragging = false
                    dragTranslation = .zero
                }
            }
    }

    // MARK: Ambient float (Lissajous drift)

    private func startFloating() {
        let amp = CGFloat(entry.floatAmplitude)
        let phase = CGFloat(entry.phaseOffset)

        // X and Y at different durations → elliptical, non-repeating drift
        withAnimation(
            .easeInOut(duration: entry.floatDurationX)
            .repeatForever(autoreverses: true)
        ) {
            floatX = amp * cos(phase)
        }
        withAnimation(
            .easeInOut(duration: entry.floatDurationY)
            .repeatForever(autoreverses: true)
        ) {
            floatY = amp * sin(phase)
        }

        // Subtle scale breathing
        withAnimation(
            .easeInOut(duration: entry.floatDurationX * 1.3)
            .repeatForever(autoreverses: true)
        ) {
            breathScale = 1.018
        }
    }
}
