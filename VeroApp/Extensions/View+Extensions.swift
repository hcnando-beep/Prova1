import SwiftUI
import UIKit

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }

    func veroCard() -> some View {
        self
            .background(Color.veroCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.veroPrimary.opacity(0.10), radius: 8, x: 0, y: 4)
    }
}
