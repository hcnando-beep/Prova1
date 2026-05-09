import SwiftUI

struct Step6ConfirmationView: View {
    @ObservedObject var reg: ConsultantRegistration
    @ObservedObject var viewModel: ConsultantRegistrationViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionHeader
            dataSummary
            termsSection

            if let err = viewModel.errorMessage {
                HStack(spacing: 8) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.veroError)
                    Text(err)
                        .font(.caption)
                        .foregroundColor(.veroError)
                }
                .padding(12)
                .background(Color.veroError.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.veroPrimary)
                Text("Revise e Confirme")
                    .font(.headline)
                    .foregroundColor(.veroPrimary)
            }
            Text("Confira suas informações antes de finalizar o cadastro.")
                .font(.caption)
                .foregroundColor(.veroSubtext)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.veroPrimary.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var dataSummary: some View {
        VStack(spacing: 1) {
            summarySection(title: "Dados Pessoais", icon: "person.fill") {
                summaryRow("Nome", reg.fullName)
                summaryRow("CPF", reg.cpf)
                summaryRow("RG", reg.rg)
                summaryRow("Gênero", reg.gender.rawValue)
            }

            summarySection(title: "Contato", icon: "envelope.fill") {
                summaryRow("E-mail", reg.email)
                summaryRow("Telefone", reg.phone)
                if !reg.samePhoneAsWhatsApp && !reg.whatsapp.isEmpty {
                    summaryRow("WhatsApp", reg.whatsapp)
                }
            }

            summarySection(title: "Endereço", icon: "map.fill") {
                summaryRow("CEP", reg.zipCode)
                summaryRow("Logradouro", "\(reg.street), \(reg.number)")
                if !reg.complement.isEmpty { summaryRow("Complemento", reg.complement) }
                summaryRow("Bairro", reg.neighborhood)
                summaryRow("Cidade/UF", "\(reg.city) - \(reg.state)")
            }

            summarySection(title: "Profissional", icon: "briefcase.fill") {
                summaryRow("Área de interesse", reg.interestArea)
                if !reg.sponsorCode.isEmpty { summaryRow("Código patrocinadora", reg.sponsorCode) }
                summaryRow("Experiência prévia", reg.hasExperience ? "Sim" : "Não")
            }

            summarySection(title: "Documentos", icon: "doc.fill") {
                summaryRow("RG/CNH Frente", reg.documentFrontImage != nil ? "Enviado ✓" : "Não enviado")
                summaryRow("RG/CNH Verso",  reg.documentBackImage  != nil ? "Enviado ✓" : "Não enviado")
                summaryRow("Selfie",          reg.selfieImage       != nil ? "Enviado ✓" : "Não enviado")
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.veroBorder, lineWidth: 1)
        )
    }

    private func summarySection<Content: View>(
        title: String, icon: String, @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(.veroPrimary)
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.veroPrimary)
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.veroPrimary.opacity(0.05))

            content()
        }
    }

    private func summaryRow(_ label: String, _ value: String) -> some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.caption)
                .foregroundColor(.veroSubtext)
                .frame(width: 130, alignment: .leading)
            Text(value.isEmpty ? "—" : value)
                .font(.caption)
                .foregroundColor(.veroText)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Color.white)
    }

    private var termsSection: some View {
        VStack(spacing: 12) {
            TermsToggle(
                isOn: $reg.acceptedTerms,
                text: "Li e aceito os ",
                linkText: "Termos de Uso e Política Comercial",
                icon: "doc.text.fill"
            )

            TermsToggle(
                isOn: $reg.acceptedPrivacy,
                text: "Li e aceito a ",
                linkText: "Política de Privacidade",
                icon: "lock.fill"
            )
        }
    }
}

private struct TermsToggle: View {
    @Binding var isOn: Bool
    let text: String
    let linkText: String
    let icon: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.veroPrimary)

            HStack(spacing: 0) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(.veroPrimary)
                    .padding(.trailing, 4)
                Text(text)
                    .font(.caption)
                    .foregroundColor(.veroText)
                Text(linkText)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.veroPrimary)
                    .underline()
            }
            Spacer()
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isOn ? Color.veroPrimary.opacity(0.4) : Color.veroBorder, lineWidth: 1.5)
        )
    }
}
