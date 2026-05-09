import SwiftUI

struct Step3AddressView: View {
    @ObservedObject var reg: ConsultantRegistration
    @ObservedObject var viewModel: ConsultantRegistrationViewModel

    private let stateOptions = [
        "AC","AL","AP","AM","BA","CE","DF","ES","GO","MA",
        "MT","MS","MG","PA","PB","PR","PE","PI","RJ","RN",
        "RS","RO","RR","SC","SP","SE","TO"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionHeader

            VStack(spacing: 16) {
                cepField
                streetAndNumber
                complementField
                neighborhoodField
                cityAndState
            }

            if let err = viewModel.addressError {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.veroSecondary)
                    Text(err)
                        .font(.caption)
                        .foregroundColor(.veroSubtext)
                }
                .padding(12)
                .background(Color.veroSecondary.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                Image(systemName: "map.fill")
                    .foregroundColor(.veroPrimary)
                Text("Endereço")
                    .font(.headline)
                    .foregroundColor(.veroPrimary)
            }
            Text("Informe o CEP para preenchimento automático ou preencha manualmente.")
                .font(.caption)
                .foregroundColor(.veroSubtext)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.veroPrimary.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var cepField: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("CEP *")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.veroPrimary)

            HStack(spacing: 10) {
                TextField("00000-000", text: Binding(
                    get: { reg.zipCode },
                    set: { reg.zipCode = $0.cepMasked() }
                ))
                .keyboardType(.numberPad)
                .padding(.horizontal, 14)
                .padding(.vertical, 13)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.veroBorder, lineWidth: 1.5)
                )
                .onChange(of: reg.zipCode) { val in
                    if val.digitsOnly.count == 8 {
                        Task { await viewModel.fetchAddress() }
                    }
                }

                Button(action: { Task { await viewModel.fetchAddress() } }) {
                    Group {
                        if viewModel.isLoadingAddress {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                    .frame(width: 44, height: 44)
                    .background(Color.veroPrimary)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(reg.zipCode.digitsOnly.count != 8 || viewModel.isLoadingAddress)
            }
        }
    }

    private var streetAndNumber: some View {
        HStack(spacing: 10) {
            VeroTextField(
                title: "Logradouro *",
                placeholder: "Rua, Av., etc.",
                text: $reg.street
            )
            .frame(maxWidth: .infinity)

            VeroTextField(
                title: "Número *",
                placeholder: "N°",
                text: $reg.number,
                keyboardType: .numberPad
            )
            .frame(width: 80)
        }
    }

    private var complementField: some View {
        VeroTextField(
            title: "Complemento",
            placeholder: "Apto, Bloco, Casa... (opcional)",
            text: $reg.complement
        )
    }

    private var neighborhoodField: some View {
        VeroTextField(
            title: "Bairro *",
            placeholder: "Nome do bairro",
            text: $reg.neighborhood
        )
    }

    private var cityAndState: some View {
        HStack(spacing: 10) {
            VeroTextField(
                title: "Cidade *",
                placeholder: "Sua cidade",
                text: $reg.city
            )
            .frame(maxWidth: .infinity)

            VeroPickerField(
                title: "UF *",
                options: stateOptions,
                selection: $reg.state,
                placeholder: "UF"
            )
            .frame(width: 80)
        }
    }
}
