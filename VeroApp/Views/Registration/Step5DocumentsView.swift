import SwiftUI
import PhotosUI

struct Step5DocumentsView: View {
    @ObservedObject var reg: ConsultantRegistration

    @State private var frontPickerItem: PhotosPickerItem?
    @State private var backPickerItem: PhotosPickerItem?
    @State private var selfiePickerItem: PhotosPickerItem?

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionHeader

            VStack(spacing: 16) {
                documentSlot(
                    title: "RG ou CNH – Frente *",
                    subtitle: "Foto nítida do documento aberto na frente",
                    icon: "doc.text.fill",
                    image: reg.documentFrontImage,
                    pickerItem: $frontPickerItem
                ) { reg.documentFrontImage = $0 }

                documentSlot(
                    title: "RG ou CNH – Verso",
                    subtitle: "Foto nítida do verso do documento",
                    icon: "doc.text",
                    image: reg.documentBackImage,
                    pickerItem: $backPickerItem
                ) { reg.documentBackImage = $0 }

                documentSlot(
                    title: "Selfie com Documento",
                    subtitle: "Segure o documento ao lado do rosto",
                    icon: "person.crop.square.fill",
                    image: reg.selfieImage,
                    pickerItem: $selfiePickerItem
                ) { reg.selfieImage = $0 }
            }

            tipsCard
        }
    }

    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                Image(systemName: "doc.fill")
                    .foregroundColor(.veroPrimary)
                Text("Documentos")
                    .font(.headline)
                    .foregroundColor(.veroPrimary)
            }
            Text("Precisamos verificar sua identidade para ativar sua conta. Fotos claras agilizam o processo.")
                .font(.caption)
                .foregroundColor(.veroSubtext)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.veroPrimary.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private func documentSlot(
        title: String,
        subtitle: String,
        icon: String,
        image: UIImage?,
        pickerItem: Binding<PhotosPickerItem?>,
        onImageLoaded: @escaping (UIImage) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.veroPrimary)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.veroText)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.veroSubtext)
                }
                Spacer()
                if image != nil {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.veroSuccess)
                }
            }

            PhotosPicker(
                selection: pickerItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                ZStack {
                    if let img = image {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 130)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        VStack(spacing: 10) {
                            Image(systemName: "camera.fill")
                                .font(.title2)
                                .foregroundColor(.veroPrimary.opacity(0.6))
                            Text("Toque para adicionar foto")
                                .font(.caption)
                                .foregroundColor(.veroSubtext)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 110)
                        .background(Color.veroPrimary.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.veroPrimary.opacity(0.25), style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                        )
                    }
                }
            }
            .onChange(of: pickerItem.wrappedValue) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let img = UIImage(data: data) {
                        onImageLoaded(img)
                    }
                }
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(image != nil ? Color.veroSuccess.opacity(0.4) : Color.veroBorder, lineWidth: 1.5)
        )
    }

    private var tipsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.veroSecondary)
                Text("Dicas para boas fotos")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.veroText)
            }
            ForEach(tips, id: \.self) { tip in
                HStack(alignment: .top, spacing: 8) {
                    Circle().fill(Color.veroSecondary).frame(width: 5, height: 5).padding(.top, 5)
                    Text(tip).font(.caption).foregroundColor(.veroSubtext)
                }
            }
        }
        .padding(14)
        .background(Color.veroSecondary.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private let tips = [
        "Ambiente bem iluminado, sem flash direto",
        "Documento legível, sem reflexo ou sombras",
        "Fundo neutro, preferencialmente branco",
        "Selfie: olhe para a câmera e segure o documento ao lado do rosto"
    ]
}
