import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/registration_provider.dart';
import '../../theme/vero_theme.dart';
import '../../utils/input_formatters.dart';
import '../../widgets/vero_picker_field.dart';
import '../../widgets/vero_text_field.dart';

class Step3Address extends StatefulWidget {
  const Step3Address({super.key});
  @override
  State<Step3Address> createState() => _State();
}

class _State extends State<Step3Address> with AutomaticKeepAliveClientMixin {
  late final TextEditingController _cepCtrl;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _numberCtrl;
  late final TextEditingController _complementCtrl;
  late final TextEditingController _neighborhoodCtrl;
  late final TextEditingController _cityCtrl;

  @override bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final r = context.read<RegistrationProvider>();
    _cepCtrl          = TextEditingController(text: r.zipCode);
    _streetCtrl       = TextEditingController(text: r.street);
    _numberCtrl       = TextEditingController(text: r.number);
    _complementCtrl   = TextEditingController(text: r.complement);
    _neighborhoodCtrl = TextEditingController(text: r.neighborhood);
    _cityCtrl         = TextEditingController(text: r.city);
  }

  @override
  void dispose() {
    for (final c in [_cepCtrl, _streetCtrl, _numberCtrl, _complementCtrl, _neighborhoodCtrl, _cityCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  void _syncAddressFromProvider(RegistrationProvider reg) {
    if (_streetCtrl.text != reg.street)           _streetCtrl.text = reg.street;
    if (_neighborhoodCtrl.text != reg.neighborhood) _neighborhoodCtrl.text = reg.neighborhood;
    if (_cityCtrl.text != reg.city)               _cityCtrl.text = reg.city;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final reg = context.watch<RegistrationProvider>();
    _syncAddressFromProvider(reg);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _header(),
        const SizedBox(height: 20),

        // CEP + buscar
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('CEP *',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: VeroColors.primary)),
          const SizedBox(height: 5),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _cepCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [CepInputFormatter()],
                decoration: const InputDecoration(hintText: '00000-000'),
                onChanged: (v) {
                  reg.update(() => reg.zipCode = v);
                  if (v.replaceAll(RegExp(r'\D'), '').length == 8) {
                    reg.fetchAddress();
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 50, height: 50,
              child: ElevatedButton(
                onPressed: reg.isLoadingAddress ? null : () => reg.fetchAddress(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: VeroColors.primary,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: reg.isLoadingAddress
                    ? const SizedBox(width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.search, color: Colors.white, size: 20),
              ),
            ),
          ]),
          if (reg.addressError != null) ...[
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.warning_amber, color: VeroColors.secondary, size: 14),
              const SizedBox(width: 6),
              Expanded(child: Text(reg.addressError!,
                  style: const TextStyle(fontSize: 11, color: VeroColors.subtext))),
            ]),
          ],
        ]),
        const SizedBox(height: 16),

        Row(children: [
          Expanded(child: VeroTextField(
            label: 'Logradouro *', hint: 'Rua, Av., etc.',
            controller: _streetCtrl,
            onChanged: (v) => reg.update(() => reg.street = v),
          )),
          const SizedBox(width: 10),
          SizedBox(width: 85, child: VeroTextField(
            label: 'Número *', hint: 'N°',
            controller: _numberCtrl,
            keyboardType: TextInputType.number,
            onChanged: (v) => reg.update(() => reg.number = v),
          )),
        ]),
        const SizedBox(height: 16),

        VeroTextField(
          label: 'Complemento', hint: 'Apto, Bloco, Casa... (opcional)',
          controller: _complementCtrl,
          onChanged: (v) => reg.update(() => reg.complement = v),
        ),
        const SizedBox(height: 16),

        VeroTextField(
          label: 'Bairro *', hint: 'Nome do bairro',
          controller: _neighborhoodCtrl,
          onChanged: (v) => reg.update(() => reg.neighborhood = v),
        ),
        const SizedBox(height: 16),

        Row(children: [
          Expanded(child: VeroTextField(
            label: 'Cidade *', hint: 'Sua cidade',
            controller: _cityCtrl,
            onChanged: (v) => reg.update(() => reg.city = v),
          )),
          const SizedBox(width: 10),
          SizedBox(width: 90, child: VeroPickerField(
            label: 'UF *',
            options: RegistrationProvider.brStates,
            value: reg.state,
            placeholder: 'UF',
            onChanged: (v) => reg.update(() => reg.state = v),
          )),
        ]),
      ]),
    );
  }

  Widget _header() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
        color: VeroColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12)),
    child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.map_outlined, color: VeroColors.primary, size: 20),
      SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Endereço', style: TextStyle(fontWeight: FontWeight.w600, color: VeroColors.primary)),
        SizedBox(height: 2),
        Text('Digite o CEP para preenchimento automático.',
            style: TextStyle(fontSize: 12, color: VeroColors.subtext)),
      ])),
    ]),
  );
}
