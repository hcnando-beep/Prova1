import SwiftUI

struct Step1PersonalInfoView: View {
    @ObservedObject var reg: ConsultantRegistration

    private var cpfError: String? {
        guard !reg.cpf.isEmpty, reg.cpf.digitsOnly.count == 11 else { return nil }
        return ValidationService.isValidCPF(reg.cpf) ? nil : "CPF inválido"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionHeader

            VStack(spacing: 16) {
                VeroTextField(
                    title: "Nome Completo *",
                    placeholder: "Ex: Maria da Silva",
                    text: $reg.fullName
                )

                VeroTextField(
                    title: "CPF *",
                    placeholder: "000.000.000-00",
                    text: Binding(
                        get: { reg.cpf },
                        set: { reg.cpf = $0.cpfMasked() }
                    ),
                    keyboardType: .numberPad,
                    autocapitalization: .never,
                    errorMessage: cpfError
                )

                VeroTextField(
                    title: "RG *",
                    placeholder: "00.000.000-0",
                    text: Binding(
                        get: { reg.rg },
                        set: { reg.rg = $0.rgMasked() }
                    ),
                    keyboardType: .numberPad,
                    autocapitalization: .never
                )

                birthDateField

                VeroPickerField(
                    title: "Gênero",
                    options: ConsultantRegistration.Gender.allCases.map(\.rawValue),
                    selection: Binding(
                        get: { reg.gender.rawValue },
                        set: { reg.gender = ConsultantRegistration.Gender(rawValue: $0) ?? .notInformed }
                    )
                )
            }

            Text("* Campos obrigatórios")
                .font(.caption2)
                .foregroundColor(.veroSubtext)
        }
    }

    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                Image(systemName: "person.fill")
                    .foregroundColor(.veroPrimary)
                Text("Dados Pessoais")
                    .font(.headline)
                    .foregroundColor(.veroPrimary)
            }
            Text("Preencha suas informações pessoais conforme documento de identidade.")
                .font(.caption)
                .foregroundColor(.veroSubtext)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.veroPrimary.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var birthDateField: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Data de Nascimento *")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.veroPrimary)

            DatePicker(
                "",
                selection: $reg.birthDate,
                in: ...Calendar.current.date(byAdding: .year, value: -18, to: Date())!,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .environment(\.locale, Locale(identifier: "pt_BR"))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.veroBorder, lineWidth: 1.5)
            )
        }
    }
}
