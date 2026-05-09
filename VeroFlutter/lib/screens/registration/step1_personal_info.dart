import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/registration_provider.dart';
import '../../services/validation_service.dart';
import '../../theme/vero_theme.dart';
import '../../utils/input_formatters.dart';
import '../../widgets/vero_picker_field.dart';
import '../../widgets/vero_text_field.dart';

class Step1PersonalInfo extends StatefulWidget {
  const Step1PersonalInfo({super.key});
  @override
  State<Step1PersonalInfo> createState() => _State();
}

class _State extends State<Step1PersonalInfo> with AutomaticKeepAliveClientMixin {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _cpfCtrl;
  late final TextEditingController _rgCtrl;

  @override bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final r = context.read<RegistrationProvider>();
    _nameCtrl = TextEditingController(text: r.fullName);
    _cpfCtrl  = TextEditingController(text: r.cpf);
    _rgCtrl   = TextEditingController(text: r.rg);
  }

  @override
  void dispose() { _nameCtrl.dispose(); _cpfCtrl.dispose(); _rgCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final reg = context.watch<RegistrationProvider>();
    final cpfDigits = reg.cpf.replaceAll(RegExp(r'\D'), '');
    final cpfError  = cpfDigits.length == 11 && !ValidationService.isValidCPF(reg.cpf)
        ? 'CPF inválido' : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _header(),
        const SizedBox(height: 20),

        VeroTextField(
          label: 'Nome Completo *', hint: 'Ex: Maria da Silva',
          controller: _nameCtrl,
          onChanged: (v) => reg.update(() => reg.fullName = v),
        ),
        const SizedBox(height: 16),

        VeroTextField(
          label: 'CPF *', hint: '000.000.000-00',
          controller: _cpfCtrl,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.none,
          inputFormatters: [CpfInputFormatter()],
          errorText: cpfError,
          onChanged: (v) => reg.update(() => reg.cpf = v),
        ),
        const SizedBox(height: 16),

        VeroTextField(
          label: 'RG *', hint: '00.000.000-0',
          controller: _rgCtrl,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.none,
          inputFormatters: [RgInputFormatter()],
          onChanged: (v) => reg.update(() => reg.rg = v),
        ),
        const SizedBox(height: 16),

        _datePicker(context, reg),
        const SizedBox(height: 16),

        VeroPickerField(
          label: 'Gênero',
          options: RegistrationProvider.genderOptions,
          value: reg.gender,
          onChanged: (v) => reg.update(() => reg.gender = v),
        ),
        const SizedBox(height: 12),

        const Text('* Campos obrigatórios',
            style: TextStyle(fontSize: 11, color: VeroColors.subtext)),
      ]),
    );
  }

  Widget _header() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
        color: VeroColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12)),
    child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.person_outline, color: VeroColors.primary, size: 20),
      SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Dados Pessoais',
            style: TextStyle(fontWeight: FontWeight.w600, color: VeroColors.primary)),
        SizedBox(height: 2),
        Text('Preencha conforme seu documento de identidade.',
            style: TextStyle(fontSize: 12, color: VeroColors.subtext)),
      ])),
    ]),
  );

  Widget _datePicker(BuildContext context, RegistrationProvider reg) {
    final d = reg.birthDate;
    final label =
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Data de Nascimento *',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: VeroColors.primary)),
      const SizedBox(height: 5),
      GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: reg.birthDate,
            firstDate: DateTime(1930),
            lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
            builder: (ctx, child) => Theme(
              data: Theme.of(ctx).copyWith(
                  colorScheme: const ColorScheme.light(primary: VeroColors.primary)),
              child: child!,
            ),
          );
          if (picked != null) reg.update(() => reg.birthDate = picked);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: VeroColors.border, width: 1.5)),
          child: Row(children: [
            Expanded(child: Text(label,
                style: const TextStyle(fontSize: 15, color: VeroColors.text))),
            const Icon(Icons.calendar_today_outlined, color: VeroColors.primary, size: 18),
          ]),
        ),
      ),
    ]);
  }
}
