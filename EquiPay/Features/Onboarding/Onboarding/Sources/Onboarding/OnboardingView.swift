import SwiftUI
import DesignSystem

struct FeatureCard {
    let title: String
    let description: String
    let image: String
}

public struct OnboardingView: View {

    // MARK: - Properties
    @State private var currentIndex: Int = 0
    @StateObject private var vm: OnboardingViewModel
    public init(vm: OnboardingViewModel) { _vm = StateObject(wrappedValue: vm) }

    // MARK: - Dummy Data
    private let features: [FeatureCard] = [
        .init(title: "Manage groups",
              description: "Create groups for every occasion and easily add participants",
              image: "groups"),
        .init(title: "Complete History",
              description: "Keep a clear record of all your shared expenses",
              image: "history"),
        .init(title: "Automatic Calculation",
              description: "Split expenses fairly and transparently",
              image: "calculation")
    ]

    // MARK: - Body
    public var body: some View {
        VStack(spacing: 32) {
            Text("EquiPay")
                .font(.largeTitle.bold())

            // MARK: - Carousel
            TabView(selection: $currentIndex) {
                ForEach(features.indices, id: \.self) { index in
                    VStack(spacing: 16) {
                        Image(features[index].image, bundle: .module)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 220)
                            .padding(.horizontal, 32)

                        Text(features[index].title)
                            .font(.title3.bold())

                        Text(features[index].description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 32)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 380)

            Spacer()

            // MARK: - Buttons
            VStack(spacing: 12) {
                GhostButton("Log in") { vm.startAuth() }
                SecondaryButton("Sign up") { vm.startAuth() }
            }
        }
        .padding()
    }
}

#if DEBUG
#Preview("Onboarding") {
    OnboardingView(vm: OnboardingViewModel { })
        .padding()
}
#endif

