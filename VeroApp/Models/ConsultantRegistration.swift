import Foundation
import SwiftUI

final class ConsultantRegistration: ObservableObject {

    // MARK: - Step 1: Dados Pessoais
    @Published var fullName: String = ""
    @Published var cpf: String = ""
    @Published var rg: String = ""
    @Published var birthDate: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    @Published var gender: Gender = .notInformed

    // MARK: - Step 2: Contato
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var whatsapp: String = ""
    @Published var samePhoneAsWhatsApp: Bool = true

    // MARK: - Step 3: Endereço
    @Published var zipCode: String = ""
    @Published var street: String = ""
    @Published var number: String = ""
    @Published var complement: String = ""
    @Published var neighborhood: String = ""
    @Published var city: String = ""
    @Published var state: String = ""

    // MARK: - Step 4: Dados Profissionais
    @Published var sponsorCode: String = ""
    @Published var interestArea: String = ""
    @Published var hasExperience: Bool = false

    // MARK: - Step 5: Documentos
    @Published var documentFrontImage: UIImage? = nil
    @Published var documentBackImage: UIImage? = nil
    @Published var selfieImage: UIImage? = nil

    // MARK: - Step 6: Confirmação
    @Published var acceptedTerms: Bool = false
    @Published var acceptedPrivacy: Bool = false

    // MARK: - Validation
    var isStep1Valid: Bool {
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty &&
        cpf.digitsOnly.count == 11 &&
        ValidationService.isValidCPF(cpf) &&
        !rg.isEmpty
    }

    var isStep2Valid: Bool {
        ValidationService.isValidEmail(email) &&
        phone.digitsOnly.count >= 10
    }

    var isStep3Valid: Bool {
        zipCode.digitsOnly.count == 8 &&
        !street.trimmingCharacters(in: .whitespaces).isEmpty &&
        !number.trimmingCharacters(in: .whitespaces).isEmpty &&
        !city.trimmingCharacters(in: .whitespaces).isEmpty &&
        !state.isEmpty
    }

    var isStep4Valid: Bool { !interestArea.isEmpty }

    var isStep5Valid: Bool { documentFrontImage != nil }

    var isStep6Valid: Bool { acceptedTerms && acceptedPrivacy }

    // MARK: - Nested Types
    enum Gender: String, CaseIterable {
        case female      = "Feminino"
        case male        = "Masculino"
        case other       = "Outro"
        case notInformed = "Prefiro não informar"
    }
}
