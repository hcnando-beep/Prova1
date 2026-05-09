import SwiftUI

struct StepIndicatorView: View {
    let steps: [String]
    let icons: [String]
    let currentStep: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(steps.indices, id: \.self) { idx in
                StepDot(
                    icon: icons[idx],
                    label: steps[idx],
                    state: state(for: idx)
                )
                if idx < steps.count - 1 {
                    Rectangle()
                        .fill(idx < currentStep ? Color.veroPrimary : Color.veroBorder)
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 12)
    }

    private func state(for idx: Int) -> StepDot.DotState {
        if idx < currentStep  { return .done }
        if idx == currentStep { return .active }
        return .upcoming
    }
}

struct StepDot: View {
    let icon: String
    let label: String
    let state: DotState

    enum DotState { case done, active, upcoming }

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(circleFill)
                    .frame(width: 34, height: 34)
                    .shadow(color: state == .active ? Color.veroPrimary.opacity(0.35) : .clear,
                            radius: 6, x: 0, y: 3)

                if state == .done {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(state == .active ? .white : .veroSubtext)
                }
            }
            Text(label)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(state == .upcoming ? .veroSubtext : .veroPrimary)
                .lineLimit(1)
        }
    }

    private var circleFill: Color {
        switch state {
        case .done, .active: return .veroPrimary
        case .upcoming:      return Color.veroBorder.opacity(0.6)
        }
    }
}
