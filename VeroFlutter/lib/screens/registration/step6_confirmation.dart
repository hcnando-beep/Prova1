import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/registration_provider.dart';
import '../../theme/vero_theme.dart';

class Step6Confirmation extends StatelessWidget {
  const Step6Confirmation({super.key});

  @override
  Widget build(BuildContext context) {
    final reg = context.watch<RegistrationProvider>();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _header(),
        const SizedBox(height: 16),
        _summary(reg),
        const SizedBox(height: 16),
        _termsSection(reg),
        if (reg.errorMessage != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: VeroColors.error.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              const Icon(Icons.error_outline, color: VeroColors.error, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text(reg.errorMessage!,
                  style: const TextStyle(color: VeroColors.error, fontSize: 12))),
            ]),
          ),
        ],
      ]),
    );
  }

  Widget _header() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
        color: VeroColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12)),
    child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.check_circle_outline, color: VeroColors.primary, size: 20),
      SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Revise e Confirme',
            style: TextStyle(fontWeight: FontWeight.w600, color: VeroColors.primary)),
        SizedBox(height: 2),
        Text('Confira suas informações antes de finalizar o cadastro.',
            style: TextStyle(fontSize: 12, color: VeroColors.subtext)),
      ])),
    ]),
  );

  Widget _summary(RegistrationProvider reg) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: VeroColors.border),
            borderRadius: BorderRadius.circular(14)),
        child: Column(children: [
          _section('Dados Pessoais', Icons.person_outline, [
            ['Nome', reg.fullName],
            ['CPF', reg.cpf],
            ['RG', reg.rg],
            ['Gênero', reg.gender],
          ]),
          _section('Contato', Icons.email_outlined, [
            ['E-mail', reg.email],
            ['Telefone', reg.phone],
          ]),
          _section('Endereço', Icons.map_outlined, [
            ['CEP', reg.zipCode],
            ['Logradouro', '${reg.street}, ${reg.number}'],
            if (reg.complement.isNotEmpty) ['Complemento', reg.complement],
            ['Bairro', reg.neighborhood],
            ['Cidade/UF', '${reg.city} - ${reg.state}'],
          ]),
          _section('Profissional', Icons.work_outline, [
            ['Área de interesse', reg.interestArea],
            if (reg.sponsorCode.isNotEmpty) ['Código patrocinadora', reg.sponsorCode],
            ['Experiência prévia', reg.hasExperience ? 'Sim' : 'Não'],
          ]),
          _section('Documentos', Icons.document_scanner_outlined, [
            ['RG/CNH Frente', reg.documentFrontImage != null ? 'Enviado ✓' : 'Não enviado'],
            ['RG/CNH Verso',  reg.documentBackImage  != null ? 'Enviado ✓' : 'Não enviado'],
            ['Selfie',        reg.selfieImage        != null ? 'Enviado ✓' : 'Não enviado'],
          ]),
        ]),
      ),
    );
  }

  Widget _section(String title, IconData icon, List<List<String>> rows) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        color: VeroColors.primary.withOpacity(0.05),
        child: Row(children: [
          Icon(icon, color: VeroColors.primary, size: 14),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: VeroColors.primary)),
        ]),
      ),
      ...rows.map((row) => Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 120, child: Text(row[0],
              style: const TextStyle(fontSize: 12, color: VeroColors.subtext))),
          Expanded(child: Text(row[1].isEmpty ? '—' : row[1],
              style: const TextStyle(fontSize: 12, color: VeroColors.text))),
        ]),
      )),
    ]);
  }

  Widget _termsSection(RegistrationProvider reg) {
    return Column(children: [
      _termsTile(
        text: 'Li e aceito os ',
        link: 'Termos de Uso e Política Comercial',
        icon: Icons.description_outlined,
        value: reg.acceptedTerms,
        onChanged: (v) => reg.update(() => reg.acceptedTerms = v),
      ),
      const SizedBox(height: 10),
      _termsTile(
        text: 'Li e aceito a ',
        link: 'Política de Privacidade',
        icon: Icons.lock_outline,
        value: reg.acceptedPrivacy,
        onChanged: (v) => reg.update(() => reg.acceptedPrivacy = v),
      ),
    ]);
  }

  Widget _termsTile({
    required String text, required String link,
    required IconData icon, required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: value ? VeroColors.primary.withOpacity(0.4) : VeroColors.border,
              width: 1.5)),
      child: Row(children: [
        Transform.scale(
          scale: 0.9,
          child: Switch(
              value: value, activeColor: VeroColors.primary,
              onChanged: onChanged),
        ),
        const SizedBox(width: 6),
        Icon(icon, color: VeroColors.primary, size: 16),
        const SizedBox(width: 6),
        Expanded(child: Text.rich(TextSpan(children: [
          TextSpan(text: text, style: const TextStyle(fontSize: 12, color: VeroColors.text)),
          TextSpan(text: link, style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: VeroColors.primary,
              decoration: TextDecoration.underline)),
        ]))),
      ]),
    );
  }
}
