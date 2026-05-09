import SwiftUI

struct Step2ContactView: View {
    @ObservedObject var reg: ConsultantRegistration

    private var emailError: String? {
        guard !reg.email.isEmpty else { return nil }
        return ValidationService.isValidEmail(reg.email) ? nil : "E-mail inválido"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionHeader

            VStack(spacing: 16) {
                VeroTextField(
                    title: "E-mail *",
                    placeholder: "seu@email.com",
                    text: $reg.email,
                    keyboardType: .emailAddress,
                    autocapitalization: .never,
                    errorMessage: emailError
                )

                VeroTextField(
                    title: "Telefone / Celular *",
                    placeholder: "(00) 00000-0000",
                    text: Binding(
                        get: { reg.phone },
                        set: { reg.phone = $0.phoneMasked() }
                    ),
                    keyboardType: .phonePad
                )

                whatsappSection
            }

            infoBox
        }
    }

    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.veroPrimary)
                Text("Informações de Contato")
                    .font(.headline)
                    .foregroundColor(.veroPrimary)
            }
            Text("Usaremos esses dados para enviar informações sobre seu cadastro e pedidos.")
                .font(.caption)
                .foregroundColor(.veroSubtext)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.veroPrimary.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var whatsappSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle(isOn: $reg.samePhoneAsWhatsApp) {
                HStack(spacing: 8) {
                    Image(systemName: "message.fill")
                        .foregroundColor(.veroSuccess)
                        .font(.subheadline)
                    Text("WhatsApp é o mesmo número")
                        .font(.subheadline)
                        .foregroundColor(.veroText)
                }
            }
            .tint(.veroPrimary)

            if !reg.samePhoneAsWhatsApp {
                VeroTextField(
                    title: "WhatsApp",
                    placeholder: "(00) 00000-0000",
                    text: Binding(
                        get: { reg.whatsapp },
                        set: { reg.whatsapp = $0.phoneMasked() }
                    ),
                    keyboardType: .phonePad
                )
            }
        }
        .padding(14)
        .background(Color.veroSuccess.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.veroSuccess.opacity(0.25), lineWidth: 1)
        )
    }

    private var infoBox: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle.fill")
                .foregroundColor(.veroPrimary)
                .font(.subheadline)
            Text("Seus dados estão protegidos. Não compartilhamos suas informações com terceiros.")
                .font(.caption)
                .foregroundColor(.veroSubtext)
        }
        .padding(12)
        .background(Color.veroPrimary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
