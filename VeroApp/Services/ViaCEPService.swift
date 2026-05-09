import Foundation

struct ViaCEPResponse: Codable {
    let logradouro: String?
    let bairro: String?
    let localidade: String?
    let uf: String?
    let erro: Bool?
}

enum ViaCEPError: LocalizedError {
    case notFound
    case network(Error)

    var errorDescription: String? {
        switch self {
        case .notFound:      return "CEP não encontrado. Preencha os campos manualmente."
        case .network(let e): return "Erro de rede: \(e.localizedDescription)"
        }
    }
}

enum ViaCEPService {
    static func fetchAddress(cep: String) async throws -> ViaCEPResponse {
        let clean = cep.filter(\.isNumber)
        guard clean.count == 8,
              let url = URL(string: "https://viacep.com.br/ws/\(clean)/json/") else {
            throw ViaCEPError.notFound
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(ViaCEPResponse.self, from: data)
            if response.erro == true { throw ViaCEPError.notFound }
            return response
        } catch let e as ViaCEPError {
            throw e
        } catch {
            throw ViaCEPError.network(error)
        }
    }
}
