import Foundation

struct Address: Codable, Equatable {
    var zipCode: String
    var street: String
    var number: String
    var complement: String
    var neighborhood: String
    var city: String
    var state: String

    var formatted: String {
        var parts = [street]
        if !number.isEmpty      { parts.append(number) }
        if !complement.isEmpty  { parts.append(complement) }
        if !neighborhood.isEmpty { parts.append(neighborhood) }
        if !city.isEmpty || !state.isEmpty { parts.append("\(city) - \(state)") }
        if !zipCode.isEmpty     { parts.append(zipCode) }
        return parts.joined(separator: ", ")
    }
}
