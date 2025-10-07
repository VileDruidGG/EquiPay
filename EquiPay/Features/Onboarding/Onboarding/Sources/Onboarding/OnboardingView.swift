
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
        .init(title: "Smart Calculation",
              description: "Automatically split expenses considering different scenarios and custom adjustments.",
              imageName: "calculation"),
        .init(title: "Unlimited Groups",
              description: "Create groups for trips, dinners, roommates, or any occasion where you share expenses.",
              imageName: "groups"),
        .init(title: "Complete History",
              description: "Keep a detailed record of all expenses and payments for full transparency.",
              imageName: "history"),
        .init(title: "Notifications",
              description: "Receive automatic reminders for pending payments without being annoying.",
              imageName: "notifications"),
        .init(title: "Manual Adjustments",
              description: "Modify splits when needed for special cases.",
              imageName: "manual"),
        .init(title: "Super Fast",
              description: "A minimalist interface that lets you manage expenses in seconds.",
              imageName: "fast")
    ]


    public var body: some View {
        VStack(spacing: 32) {
            Spacer(minLength: 0)
            // Header
            Text("Welcome to ")
                .font(.largeTitle) + Text("EquiPay").font(.largeTitle.bold()).foregroundStyle(LinearGradient(colors: [.mint, .purple],  startPoint: .leading, endPoint: .trailing))
            
            //Subheader
            Text("Fair splits. Smarter sharing.")
                .font(.headline.bold())
                .foregroundColor(.secondary)

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
            Spacer(minLength: 0)
        }
        .frame(alignment: .center).padding()
    }
}

// MARK: - Slide
private struct FeatureSlide: View {
    let card: FeatureCard

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            // Imagen desde el bundle del package
            Image.fromModule(card.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding(16)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)).padding(.horizontal,32)

            Text(card.title)
                .font(.title3.bold())

            Text(card.description)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }.frame(maxHeight: .infinity, alignment: .top).padding(10)
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
