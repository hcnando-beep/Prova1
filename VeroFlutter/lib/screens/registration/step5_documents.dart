import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/registration_provider.dart';
import '../../theme/vero_theme.dart';

class Step5Documents extends StatefulWidget {
  const Step5Documents({super.key});
  @override
  State<Step5Documents> createState() => _State();
}

class _State extends State<Step5Documents> with AutomaticKeepAliveClientMixin {
  final _picker = ImagePicker();
  @override bool get wantKeepAlive => true;

  Future<void> _pickImage(String slot) async {
    final file = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 85, maxWidth: 1200);
    if (file == null || !mounted) return;
    final reg = context.read<RegistrationProvider>();
    reg.update(() {
      if (slot == 'front')  reg.documentFrontImage = file;
      if (slot == 'back')   reg.documentBackImage  = file;
      if (slot == 'selfie') reg.selfieImage        = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final reg = context.watch<RegistrationProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _header(),
        const SizedBox(height: 20),

        _docSlot(
          title: 'RG ou CNH – Frente *',
          subtitle: 'Foto nítida do documento aberto na frente',
          icon: Icons.badge_outlined,
          file: reg.documentFrontImage,
          slot: 'front',
        ),
        const SizedBox(height: 12),

        _docSlot(
          title: 'RG ou CNH – Verso',
          subtitle: 'Foto nítida do verso do documento',
          icon: Icons.flip_to_back_outlined,
          file: reg.documentBackImage,
          slot: 'back',
        ),
        const SizedBox(height: 12),

        _docSlot(
          title: 'Selfie com Documento',
          subtitle: 'Segure o documento ao lado do rosto',
          icon: Icons.face_outlined,
          file: reg.selfieImage,
          slot: 'selfie',
        ),
        const SizedBox(height: 20),

        _tipsCard(),
      ]),
    );
  }

  Widget _header() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
        color: VeroColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12)),
    child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.document_scanner_outlined, color: VeroColors.primary, size: 20),
      SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Documentos', style: TextStyle(fontWeight: FontWeight.w600, color: VeroColors.primary)),
        SizedBox(height: 2),
        Text('Precisamos verificar sua identidade. Fotos claras agilizam o processo.',
            style: TextStyle(fontSize: 12, color: VeroColors.subtext)),
      ])),
    ]),
  );

  Widget _docSlot({
    required String title, required String subtitle,
    required IconData icon, required XFile? file, required String slot,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: file != null ? VeroColors.success.withOpacity(0.5) : VeroColors.border,
              width: 1.5)),
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: VeroColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: VeroColors.text)),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: VeroColors.subtext)),
          ])),
          if (file != null)
            const Icon(Icons.check_circle_rounded, color: VeroColors.success, size: 20),
        ]),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _pickImage(slot),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: file != null
                ? Image.file(File(file.path),
                    width: double.infinity, height: 130, fit: BoxFit.cover)
                : Container(
                    width: double.infinity, height: 110,
                    decoration: BoxDecoration(
                        color: VeroColors.primary.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: VeroColors.primary.withOpacity(0.25),
                            style: BorderStyle.solid, width: 1.5)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.camera_alt_outlined,
                          color: VeroColors.primary.withOpacity(0.55), size: 28),
                      const SizedBox(height: 8),
                      const Text('Toque para adicionar foto',
                          style: TextStyle(fontSize: 12, color: VeroColors.subtext)),
                    ]),
                  ),
          ),
        ),
      ]),
    );
  }

  Widget _tipsCard() {
    const tips = [
      'Ambiente bem iluminado, sem flash direto',
      'Documento legível, sem reflexo ou sombras',
      'Fundo neutro, preferencialmente branco',
      'Selfie: olhe para a câmera e segure o documento ao lado do rosto',
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: VeroColors.secondary.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.lightbulb_outline, color: VeroColors.secondary, size: 18),
          SizedBox(width: 8),
          Text('Dicas para boas fotos',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: VeroColors.text)),
        ]),
        const SizedBox(height: 8),
        ...tips.map((t) => Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 5, height: 5, margin: const EdgeInsets.only(top: 6, right: 8),
                decoration: const BoxDecoration(shape: BoxShape.circle, color: VeroColors.secondary)),
            Expanded(child: Text(t, style: const TextStyle(fontSize: 12, color: VeroColors.subtext))),
          ]),
        )),
      ]),
    );
  }
}
