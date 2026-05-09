import SwiftUI

struct Step4ProfessionalView: View {
    @ObservedObject var reg: ConsultantRegistration

    private let interestAreas = [
        "Bem-estar e cuidados pessoais",
        "Maquiagem e beleza",
        "Skincare e cuidados com a pele",
        "Perfumaria",
        "Produtos capilares",
        "Diversificado (todas as categorias)"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionHeader

            VStack(spacing: 16) {
                sponsorCodeField
                interestAreaPicker
                experienceToggle
            }

            benefitsCard
        }
    }

    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                Image(systemName: "briefcase.fill")
                    .foregroundColor(.veroPrimary)
                Text("Dados Profissionais")
                    .font(.headline)
                    .foregroundColor(.veroPrimary)
            }
            Text("Essas informações ajudam a personalizar sua experiência como consultora.")
                .font(.caption)
                .foregroundColor(.veroSubtext)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.veroPrimary.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var sponsorCodeField: some View {
        VStack(alignment: .leading, spacing: 8) {
            VeroTextField(
                title: "Código da Consultora Patrocinadora",
                placeholder: "Ex: VR-123456 (opcional)",
                text: $reg.sponsorCode,
                autocapitalization: .characters
            )

            Text("Se uma consultora te indicou, insira o código dela para ela receber os benefícios.")
                .font(.caption2)
                .foregroundColor(.veroSubtext)
        }
    }

    private var interestAreaPicker: some View {
        VeroPickerField(
            title: "Área de Interesse Principal *",
            options: interestAreas,
            selection: $reg.interestArea,
            placeholder: "Selecione uma área..."
        )
    }

    private var experienceToggle: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle(isOn: $reg.hasExperience) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Tenho experiência em vendas diretas")
                        .font(.subheadline)
                        .foregroundColor(.veroText)
                    Text("Já trabalhei com vendas ou marketing de rede")
                        .font(.caption)
                        .foregroundColor(.veroSubtext)
                }
            }
            .tint(.veroPrimary)
            .padding(14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.veroBorder, lineWidth: 1.5)
            )
        }
    }

    private var benefitsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .foregroundColor(.veroSecondary)
                Text("Benefícios da consultora Vero")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.veroText)
            }

            ForEach(benefits, id: \.self) { benefit in
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.veroSuccess)
                        .font(.caption)
                    Text(benefit)
                        .font(.caption)
                        .foregroundColor(.veroSubtext)
                }
            }
        }
        .padding(14)
        .background(
            LinearGradient(
                colors: [Color.veroSecondary.opacity(0.08), Color.veroPrimary.opacity(0.04)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.veroSecondary.opacity(0.25), lineWidth: 1)
        )
    }

    private let benefits = [
        "Desconto exclusivo de até 30% nos produtos",
        "Comissão sobre suas vendas e da sua rede",
        "Treinamentos e capacitações gratuitas",
        "Suporte da equipe Vero 24/7",
        "Prêmios e bonificações por metas"
    ]
}
