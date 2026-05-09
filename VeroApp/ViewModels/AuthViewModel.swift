import Foundation
import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var currentConsultant: Consultant?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showRegistration = false

    var isAuthenticated: Bool { currentConsultant != nil }

    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        do {
            currentConsultant = try await APIService.shared.login(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func logout() {
        currentConsultant = nil
    }
}
