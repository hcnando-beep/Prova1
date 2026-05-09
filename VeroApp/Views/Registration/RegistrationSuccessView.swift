import SwiftUI

struct RegistrationSuccessView: View {
    let consultant: Consultant
    @EnvironmentObject var authVM: AuthViewModel
    @State private var checkScale: CGFloat = 0
    @State private var contentOpacity: Double = 0
    @State private var confettiVisible = false

    var body: some View {
        ZStack {
            Color.veroBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    Spacer().frame(height: 40)

                    successIcon
                    headerText
                    consultantCard
                    nextStepsList
                    actionButtons

                    Spacer().frame(height: 40)
                }
                .padding(.horizontal, 24)
                .opacity(contentOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.55).delay(0.1)) {
                checkScale = 1.0
            }
            withAnimation(.easeIn(duration: 0.5).delay(0.5)) {
                contentOpacity = 1.0
            }
        }
    }

    private var successIcon: some View {
        ZStack {
            Circle()
                .fill(Color.veroSuccess.opacity(0.12))
                .frame(width: 150, height: 150)

            Circle()
                .fill(Color.veroSuccess.opacity(0.2))
                .frame(width: 115, height: 115)

            Circle()
                .fill(Color.veroSuccess)
                .frame(width: 82, height: 82)
                .shadow(color: Color.veroSuccess.opacity(0.4), radius: 14, x: 0, y: 6)

            Image(systemName: "checkmark")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
        }
        .scaleEffect(checkScale)
    }

    private var headerText: some View {
        VStack(spacing: 10) {
            Text("Cadastro Realizado!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.veroText)

            Text("Bem-vinda à família Vero Cosméticos!\nSeu cadastro está sendo analisado.")
                .font(.subheadline)
                .foregroundColor(.veroSubtext)
                .multilineTextAlignment(.center)
        }
    }

    private var consultantCard: some View {
        VStack(spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(consultant.name)
                        .font(.headline)
                        .foregroundColor(.veroText)
                    Text(consultant.email)
                        .font(.caption)
                        .foregroundColor(.veroSubtext)
                }
                Spacer()
                statusBadge
            }

            Divider()

            HStack {
                infoItem(icon: "number", label: "Código", value: consultant.consultantCode)
                Spacer()
                infoItem(icon: "calendar", label: "Cadastro", value: formattedDate)
            }
        }
        .padding(16)
        .veroCard()
    }

    private var statusBadge: some View {
        Text(consultant.status.rawValue)
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundColor(.veroSecondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.veroSecondary.opacity(0.12))
            .clipShape(Capsule())
    }

    private func infoItem(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.veroPrimary)
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.caption2).foregroundColor(.veroSubtext)
                Text(value).font(.caption).fontWeight(.semibold).foregroundColor(.veroText)
            }
        }
    }

    private var nextStepsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Próximos Passos")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.veroText)

            ForEach(nextSteps.indices, id: \.self) { idx in
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.veroPrimary.opacity(0.12))
                            .frame(width: 28, height: 28)
                        Text("\(idx + 1)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.veroPrimary)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(nextSteps[idx].title)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.veroText)
                        Text(nextSteps[idx].detail)
                            .font(.caption2)
                            .foregroundColor(.veroSubtext)
                    }
                }
            }
        }
        .padding(16)
        .veroCard()
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            VeroButton(title: "Acessar Minha Conta", icon: "arrow.right.circle.fill") {
                authVM.currentConsultant = consultant
            }

            VeroButton(title: "Compartilhar com Amigos", icon: "square.and.arrow.up", style: .outline) {}
        }
    }

    private var formattedDate: String {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        f.locale = Locale(identifier: "pt_BR")
        return f.string(from: consultant.registrationDate)
    }

    private let nextSteps: [(title: String, detail: String)] = [
        ("Análise dos documentos", "Nossa equipe analisará seus dados em até 2 dias úteis"),
        ("Ativação da conta", "Você receberá um e-mail quando sua conta for ativada"),
        ("Primeiro pedido", "Com a conta ativa, faça seu primeiro pedido com desconto de boas-vindas"),
        ("Início das vendas", "Comece a vender e ganhar comissões!")
    ]
}
