import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case network(Error)
    case decoding(Error)
    case server(Int)
    case unauthorized
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:       return "URL inválida."
        case .network(let e):   return "Erro de rede: \(e.localizedDescription)"
        case .decoding(let e):  return "Erro ao processar dados: \(e.localizedDescription)"
        case .server(let code): return "Erro do servidor (\(code)). Tente novamente."
        case .unauthorized:     return "Email ou senha inválidos."
        case .unknown:          return "Erro desconhecido. Tente novamente."
        }
    }
}

final class APIService {
    static let shared = APIService()
    private init() {}

    // Simulated base URL – replace with real endpoint
    private let baseURL = "https://api.vero.com.br/v1"

    func registerConsultant(_ reg: ConsultantRegistration) async throws -> Consultant {
        try await Task.sleep(nanoseconds: 2_000_000_000)

        return Consultant(
            id: UUID().uuidString,
            name: reg.fullName,
            email: reg.email,
            cpf: reg.cpf,
            phone: reg.phone,
            status: .pending,
            registrationDate: Date(),
            sponsorCode: reg.sponsorCode.isEmpty ? nil : reg.sponsorCode,
            address: Address(
                zipCode: reg.zipCode,
                street: reg.street,
                number: reg.number,
                complement: reg.complement,
                neighborhood: reg.neighborhood,
                city: reg.city,
                state: reg.state
            ),
            consultantCode: "VR-\(String(format: "%06d", Int.random(in: 100000...999999)))"
        )
    }

    func login(email: String, password: String) async throws -> Consultant {
        try await Task.sleep(nanoseconds: 1_500_000_000)
        guard !password.isEmpty else { throw APIError.unauthorized }

        return Consultant(
            id: UUID().uuidString,
            name: "Consultora Vero",
            email: email,
            cpf: "000.000.000-00",
            phone: "(11) 99999-9999",
            status: .active,
            registrationDate: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date(),
            sponsorCode: nil,
            address: Address(zipCode: "01310-100", street: "Av. Paulista", number: "1000",
                             complement: "", neighborhood: "Bela Vista", city: "São Paulo", state: "SP"),
            consultantCode: "VR-123456"
        )
    }
}
