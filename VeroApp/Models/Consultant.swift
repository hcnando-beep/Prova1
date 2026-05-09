import Foundation

struct Consultant: Identifiable, Codable {
    let id: String
    var name: String
    var email: String
    var cpf: String
    var phone: String
    var status: ConsultantStatus
    var registrationDate: Date
    var sponsorCode: String?
    var address: Address
    var consultantCode: String

    enum ConsultantStatus: String, Codable {
        case pending  = "PENDENTE"
        case active   = "ATIVO"
        case inactive = "INATIVO"
        case suspended = "SUSPENSO"

        var label: String { rawValue.capitalized }

        var color: String {
            switch self {
            case .active:    return "success"
            case .pending:   return "secondary"
            case .inactive:  return "subtext"
            case .suspended: return "error"
            }
        }
    }

    var firstName: String { name.components(separatedBy: " ").first ?? name }
}
