import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/registration_provider.dart';
import '../../services/validation_service.dart';
import '../../theme/vero_theme.dart';
import '../../utils/input_formatters.dart';
import '../../widgets/vero_text_field.dart';

class Step2Contact extends StatefulWidget {
  const Step2Contact({super.key});
  @override
  State<Step2Contact> createState() => _State();
}

class _State extends State<Step2Contact> with AutomaticKeepAliveClientMixin {
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _waCtrl;

  @override bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final r = context.read<RegistrationProvider>();
    _emailCtrl = TextEditingController(text: r.email);
    _phoneCtrl = TextEditingController(text: r.phone);
    _waCtrl    = TextEditingController(text: r.whatsapp);
  }

  @override
  void dispose() { _emailCtrl.dispose(); _phoneCtrl.dispose(); _waCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final reg = context.watch<RegistrationProvider>();
    final emailError = reg.email.isNotEmpty && !ValidationService.isValidEmail(reg.email)
        ? 'E-mail inválido' : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _header(),
        const SizedBox(height: 20),

        VeroTextField(
          label: 'E-mail *', hint: 'seu@email.com',
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
          errorText: emailError,
          onChanged: (v) => reg.update(() => reg.email = v),
        ),
        const SizedBox(height: 16),

        VeroTextField(
          label: 'Telefone / Celular *', hint: '(00) 00000-0000',
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          inputFormatters: [PhoneInputFormatter()],
          onChanged: (v) => reg.update(() => reg.phone = v),
        ),
        const SizedBox(height: 16),

        _whatsappSection(reg),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: VeroColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10)),
          child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.info_outline, color: VeroColors.primary, size: 16),
            SizedBox(width: 8),
            Expanded(child: Text(
              'Seus dados estão protegidos. Não compartilhamos suas informações com terceiros.',
              style: TextStyle(fontSize: 12, color: VeroColors.subtext),
            )),
          ]),
        ),
      ]),
    );
  }

  Widget _header() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
        color: VeroColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12)),
    child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.email_outlined, color: VeroColors.primary, size: 20),
      SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Informações de Contato',
            style: TextStyle(fontWeight: FontWeight.w600, color: VeroColors.primary)),
        SizedBox(height: 2),
        Text('Usaremos para enviar informações sobre seu cadastro e pedidos.',
            style: TextStyle(fontSize: 12, color: VeroColors.subtext)),
      ])),
    ]),
  );

  Widget _whatsappSection(RegistrationProvider reg) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: VeroColors.success.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: VeroColors.success.withOpacity(0.25))),
      child: Column(children: [
        Row(children: [
          const Icon(Icons.chat_bubble_outline, color: VeroColors.success, size: 18),
          const SizedBox(width: 8),
          const Expanded(child: Text('WhatsApp é o mesmo número',
              style: TextStyle(fontSize: 14, color: VeroColors.text))),
          Switch(
            value: reg.samePhoneAsWhatsApp,
            activeColor: VeroColors.primary,
            onChanged: (v) => reg.update(() => reg.samePhoneAsWhatsApp = v),
          ),
        ]),
        if (!reg.samePhoneAsWhatsApp) ...[
          const SizedBox(height: 12),
          VeroTextField(
            label: 'WhatsApp', hint: '(00) 00000-0000',
            controller: _waCtrl,
            keyboardType: TextInputType.phone,
            inputFormatters: [PhoneInputFormatter()],
            onChanged: (v) => reg.update(() => reg.whatsapp = v),
          ),
        ],
      ]),
    );
  }
}
