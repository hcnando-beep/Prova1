import Foundation
import SwiftUI
import Combine

@MainActor
final class ConsultantRegistrationViewModel: ObservableObject {
    @Published var registration = ConsultantRegistration()
    @Published var currentStep: Int = 0
    @Published var isLoading = false
    @Published var isLoadingAddress = false
    @Published var errorMessage: String?
    @Published var addressError: String?
    @Published var isRegistered = false
    @Published var registeredConsultant: Consultant?

    private var cancellables = Set<AnyCancellable>()

    let totalSteps = 6
    let stepTitles = ["Pessoal", "Contato", "Endereço", "Profissional", "Docs", "Confirmar"]
    let stepIcons  = ["person.fill", "envelope.fill", "map.fill", "briefcase.fill", "doc.fill", "checkmark.seal.fill"]

    init() {
        // Forward nested ObservableObject changes so the parent view re-renders
        registration.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    var canAdvance: Bool {
        switch currentStep {
        case 0: return registration.isStep1Valid
        case 1: return registration.isStep2Valid
        case 2: return registration.isStep3Valid
        case 3: return registration.isStep4Valid
        case 4: return registration.isStep5Valid
        case 5: return registration.isStep6Valid
        default: return false
        }
    }

    var navigationTitle: String {
        switch currentStep {
        case 0: return "Dados Pessoais"
        case 1: return "Contato"
        case 2: return "Endereço"
        case 3: return "Dados Profissionais"
        case 4: return "Documentos"
        case 5: return "Confirmar Cadastro"
        default: return "Cadastro"
        }
    }

    func next() {
        guard canAdvance, currentStep < totalSteps - 1 else { return }
        withAnimation(.easeInOut(duration: 0.3)) { currentStep += 1 }
    }

    func back() {
        guard currentStep > 0 else { return }
        withAnimation(.easeInOut(duration: 0.3)) { currentStep -= 1 }
    }

    func fetchAddress() async {
        let cep = registration.zipCode.digitsOnly
        guard cep.count == 8 else { return }
        isLoadingAddress = true
        addressError = nil
        do {
            let resp = try await ViaCEPService.fetchAddress(cep: cep)
            registration.street       = resp.logradouro ?? ""
            registration.neighborhood = resp.bairro     ?? ""
            registration.city         = resp.localidade ?? ""
            registration.state        = resp.uf         ?? ""
        } catch {
            addressError = error.localizedDescription
        }
        isLoadingAddress = false
    }

    func submitRegistration() async {
        isLoading = true
        errorMessage = nil
        do {
            registeredConsultant = try await APIService.shared.registerConsultant(registration)
            isRegistered = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
