import SwiftUI

enum VeroButtonStyle { case primary, secondary, outline, ghost }

struct VeroButton: View {
    let title: String
    var icon: String? = nil
    var style: VeroButtonStyle = .primary
    var size: ButtonSize = .regular
    var isLoading: Bool = false
    var isEnabled: Bool = true
    let action: () -> Void

    enum ButtonSize { case small, regular, large }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foreground))
                        .scaleEffect(0.85)
                } else if let icon {
                    Image(systemName: icon)
                        .font(iconFont)
                }
                Text(title)
                    .font(labelFont)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, verticalPad)
            .background(isEnabled ? background : Color.gray.opacity(0.25))
            .foregroundColor(isEnabled ? foreground : .gray)
            .clipShape(RoundedRectangle(cornerRadius: cornerR))
            .overlay(
                RoundedRectangle(cornerRadius: cornerR)
                    .stroke(style == .outline ? Color.veroPrimary : Color.clear, lineWidth: 2)
            )
        }
        .disabled(!isEnabled || isLoading)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }

    private var background: Color {
        switch style {
        case .primary:   return .veroPrimary
        case .secondary: return .veroSecondary
        case .outline:   return .clear
        case .ghost:     return Color.veroPrimary.opacity(0.08)
        }
    }
    private var foreground: Color {
        switch style {
        case .primary, .secondary: return .white
        case .outline, .ghost:     return .veroPrimary
        }
    }
    private var verticalPad: CGFloat { size == .small ? 10 : size == .large ? 18 : 14 }
    private var cornerR: CGFloat { 12 }
    private var labelFont: Font { size == .small ? .subheadline : .body }
    private var iconFont: Font  { size == .small ? .caption : .callout }
}
