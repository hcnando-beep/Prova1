import SwiftUI

struct ConsultantRegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = ConsultantRegistrationViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                stepIndicator
                Divider()
                stepContent
            }
            .navigationTitle(vm.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { leadingButton }
            .safeAreaInset(edge: .bottom) { bottomBar }
            .fullScreenCover(isPresented: $vm.isRegistered) {
                if let c = vm.registeredConsultant {
                    RegistrationSuccessView(consultant: c)
                        .environmentObject(AuthViewModel())
                }
            }
            .onTapGesture { hideKeyboard() }
        }
    }

    // MARK: - Step Indicator
    private var stepIndicator: some View {
        StepIndicatorView(
            steps: vm.stepTitles,
            icons: vm.stepIcons,
            currentStep: vm.currentStep
        )
        .padding(.vertical, 14)
        .background(Color.white)
    }

    // MARK: - Step Content
    private var stepContent: some View {
        ScrollView {
            VStack {
                currentStepView
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 110)
            }
        }
        .background(Color.veroBackground)
    }

    @ViewBuilder
    private var currentStepView: some View {
        switch vm.currentStep {
        case 0: Step1PersonalInfoView(reg: vm.registration)
        case 1: Step2ContactView(reg: vm.registration)
        case 2: Step3AddressView(reg: vm.registration, viewModel: vm)
        case 3: Step4ProfessionalView(reg: vm.registration)
        case 4: Step5DocumentsView(reg: vm.registration)
        case 5: Step6ConfirmationView(reg: vm.registration, viewModel: vm)
        default: EmptyView()
        }
    }

    // MARK: - Toolbar
    private var leadingButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: handleBack) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text(vm.currentStep == 0 ? "Cancelar" : "Voltar")
                }
                .foregroundColor(.veroPrimary)
            }
        }
    }

    // MARK: - Bottom Bar
    private var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
            VStack(spacing: 6) {
                progressText

                if vm.currentStep < vm.totalSteps - 1 {
                    VeroButton(
                        title: "Continuar",
                        icon: "arrow.right",
                        isEnabled: vm.canAdvance
                    ) { vm.next() }
                } else {
                    VeroButton(
                        title: "Finalizar Cadastro",
                        icon: "checkmark.circle.fill",
                        style: .secondary,
                        isLoading: vm.isLoading,
                        isEnabled: vm.canAdvance
                    ) {
                        Task { await vm.submitRegistration() }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(Color.white)
        }
    }

    private var progressText: some View {
        HStack {
            Text("Passo \(vm.currentStep + 1) de \(vm.totalSteps)")
                .font(.caption)
                .foregroundColor(.veroSubtext)
            Spacer()
            Text("\(Int(Double(vm.currentStep + 1) / Double(vm.totalSteps) * 100))% concluído")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.veroPrimary)
        }
    }

    private func handleBack() {
        if vm.currentStep == 0 { dismiss() } else { vm.back() }
    }
}

#Preview { ConsultantRegistrationView() }
