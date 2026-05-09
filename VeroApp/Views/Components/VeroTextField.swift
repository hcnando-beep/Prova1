import SwiftUI

struct VeroTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    var autocapitalization: TextInputAutocapitalization = .words
    var errorMessage: String? = nil
    var trailingIcon: String? = nil
    var onTrailingIconTap: (() -> Void)? = nil
    var onChange: ((String) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.veroPrimary)

            HStack {
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                            .onChange(of: text) { onChange?($0) }
                    }
                }
                .keyboardType(keyboardType)
                .textInputAutocapitalization(autocapitalization)

                if let icon = trailingIcon {
                    Button(action: { onTrailingIconTap?() }) {
                        Image(systemName: icon)
                            .foregroundColor(.veroPrimary)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 13)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(errorMessage != nil ? Color.veroError : Color.veroBorder, lineWidth: 1.5)
            )

            if let err = errorMessage {
                Text(err)
                    .font(.caption2)
                    .foregroundColor(.veroError)
            }
        }
    }
}
