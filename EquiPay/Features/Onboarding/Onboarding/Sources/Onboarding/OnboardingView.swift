import SwiftUI
import DesignSystem

public struct OnboardingView: View {
    @StateObject private var vm: OnboardingViewModel
    public init(vm: OnboardingViewModel) { _vm = StateObject(wrappedValue: vm) }
    public var body: some View {
        VStack(spacing: 20) {
            Text("EquiPay").font(.largeTitle)
            PrimaryButton("Comenzar") { vm.startAuth() }
        }.padding()
    }
}

