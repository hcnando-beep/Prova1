import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/registration_provider.dart';
import '../../theme/vero_theme.dart';
import '../../widgets/vero_picker_field.dart';
import '../../widgets/vero_text_field.dart';

class Step4Professional extends StatefulWidget {
  const Step4Professional({super.key});
  @override
  State<Step4Professional> createState() => _State();
}

class _State extends State<Step4Professional> with AutomaticKeepAliveClientMixin {
  late final TextEditingController _sponsorCtrl;
  @override bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _sponsorCtrl = TextEditingController(text: context.read<RegistrationProvider>().sponsorCode);
  }

  @override
  void dispose() { _sponsorCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final reg = context.watch<RegistrationProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _header(),
        const SizedBox(height: 20),

        VeroTextField(
          label: 'Código da Consultora Patrocinadora',
          hint: 'Ex: VR-123456 (opcional)',
          controller: _sponsorCtrl,
          textCapitalization: TextCapitalization.characters,
          onChanged: (v) => reg.update(() => reg.sponsorCode = v),
        ),
        const SizedBox(height: 6),
        const Text('Se uma consultora te indicou, insira o código dela.',
            style: TextStyle(fontSize: 11, color: VeroColors.subtext)),
        const SizedBox(height: 16),

        VeroPickerField(
          label: 'Área de Interesse Principal *',
          options: RegistrationProvider.interestAreas,
          value: reg.interestArea,
          placeholder: 'Selecione uma área...',
          onChanged: (v) => reg.update(() => reg.interestArea = v),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: VeroColors.border, width: 1.5)),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Tenho experiência em vendas diretas',
                  style: TextStyle(fontSize: 14, color: VeroColors.text)),
              const SizedBox(height: 2),
              const Text('Já trabalhei com vendas ou marketing de rede',
                  style: TextStyle(fontSize: 12, color: VeroColors.subtext)),
            ])),
            Switch(
              value: reg.hasExperience,
              activeColor: VeroColors.primary,
              onChanged: (v) => reg.update(() => reg.hasExperience = v),
            ),
          ]),
        ),
        const SizedBox(height: 20),

        _benefitsCard(),
      ]),
    );
  }

  Widget _header() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
        color: VeroColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12)),
    child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.work_outline, color: VeroColors.primary, size: 20),
      SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Dados Profissionais',
            style: TextStyle(fontWeight: FontWeight.w600, color: VeroColors.primary)),
        SizedBox(height: 2),
        Text('Personalizamos sua experiência de acordo com seu perfil.',
            style: TextStyle(fontSize: 12, color: VeroColors.subtext)),
      ])),
    ]),
  );

  Widget _benefitsCard() {
    const benefits = [
      'Desconto exclusivo de até 30% nos produtos',
      'Comissão sobre suas vendas e da sua rede',
      'Treinamentos e capacitações gratuitas',
      'Suporte da equipe Vero 24/7',
      'Prêmios e bonificações por metas',
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [VeroColors.secondary.withOpacity(0.08), VeroColors.primary.withOpacity(0.04)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: VeroColors.secondary.withOpacity(0.25))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.star_rounded, color: VeroColors.secondary, size: 18),
          SizedBox(width: 8),
          Text('Benefícios da consultora Vero',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: VeroColors.text)),
        ]),
        const SizedBox(height: 10),
        ...benefits.map((b) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(children: [
            const Icon(Icons.check_circle_rounded, color: VeroColors.success, size: 14),
            const SizedBox(width: 8),
            Expanded(child: Text(b, style: const TextStyle(fontSize: 12, color: VeroColors.subtext))),
          ]),
        )),
      ]),
    );
  }
}
