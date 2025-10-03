import UIKit
import SwiftUI
import Onboarding

final class AppCoordinator {
    private let window: UIWindow
    init(window: UIWindow) { self.window = window }

    func start() {
        let vm = OnboardingViewModel { /* TODO */ }
        let root = UIHostingController(rootView: OnboardingView(vm: vm))
        window.rootViewController = root
        window.makeKeyAndVisible()
    }
}

