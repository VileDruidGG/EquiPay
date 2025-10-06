
import SwiftUI
import DesignSystem

// MARK: - Model
struct FeatureCard: Hashable {
    let title: String
    let description: String
    let imageName: String
}

// MARK: - Onboarding
public struct OnboardingView: View {

    // Estado UI
    @State private var currentIndex: Int = 0

    // ViewModel (inyectado)
    @StateObject private var vm: OnboardingViewModel
    public init(vm: OnboardingViewModel) { _vm = StateObject(wrappedValue: vm) }

    // Contenido del carrusel
    private let features: [FeatureCard] = [
        .init(title: "Manage groups",
              description: "Create groups for every occasion and easily add participants",
              imageName: "groups"),
        .init(title: "Complete History",
              description: "Keep a clear record of all your shared expenses",
              imageName: "history"),
        .init(title: "Automatic Calculation",
              description: "Split expenses fairly and transparently",
              imageName: "calculation")
    ]

    public var body: some View {
        VStack(spacing: 32) {
            // Header
            Text("EquiPay")
                .font(.largeTitle.bold())

            // Carousel
            TabView(selection: $currentIndex) {
                ForEach(features.indices, id: \.self) { index in
                    FeatureSlide(card: features[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 400)

            Spacer(minLength: 0)

            // CTA Buttons (usa tus componentes del DesignSystem)
            VStack(spacing: 12) {
                GhostButton("Log in") { vm.startAuth() }
                SecondaryButton("Sign up") { vm.startAuth() }
            }
        }
        .padding()
    }
}

// MARK: - Slide
private struct FeatureSlide: View {
    let card: FeatureCard

    var body: some View {
        VStack(spacing: 16) {
            // Imagen desde el bundle del package
            Image.fromModule(card.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 230)
                .padding(.horizontal, 32)

            Text(card.title)
                .font(.title3.bold())

            Text(card.description)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
}

// MARK: - Image helper
extension Image {
    /// Carga primero desde el bundle del package (Bundle.module) y cae a un SF Symbol si no lo encuentra.
    static func fromModule(_ baseName: String) -> Image {
        // PNG
        if let url = Bundle.module.url(forResource: baseName, withExtension: "png"),
           let ui = UIImage(contentsOfFile: url.path) {
            return Image(uiImage: ui)
        }
        // JPG (por si las guardaste en jpg)
        if let url = Bundle.module.url(forResource: baseName, withExtension: "jpg"),
           let ui = UIImage(contentsOfFile: url.path) {
            return Image(uiImage: ui)
        }
        // Si las imágenes están en el bundle de la APP (no en el package),
        // descomenta este bloque y quita los de arriba.
        // if let ui = UIImage(named: baseName) { return Image(uiImage: ui) }

        return Image(systemName: "photo")
    }
}

// MARK: - Preview
#if DEBUG
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(vm: OnboardingViewModel { })
            .previewDisplayName("Onboarding")
    }
}
#endif
