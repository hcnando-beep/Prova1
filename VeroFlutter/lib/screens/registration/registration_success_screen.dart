import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/consultant.dart';
import '../../providers/auth_provider.dart';
import '../../theme/vero_theme.dart';
import '../../widgets/vero_button.dart';
import '../dashboard/consultant_dashboard_screen.dart';

class RegistrationSuccessScreen extends StatefulWidget {
  final Consultant consultant;
  const RegistrationSuccessScreen({super.key, required this.consultant});
  @override
  State<RegistrationSuccessScreen> createState() => _State();
}

class _State extends State<RegistrationSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _scale = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _fade  = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.4, 1.0, curve: Curves.easeIn)));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = widget.consultant;
    return Scaffold(
      backgroundColor: VeroColors.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              const SizedBox(height: 32),

              // Success icon
              Transform.scale(
                scale: _scale.value,
                child: Stack(alignment: Alignment.center, children: [
                  Container(width: 150, height: 150,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                          color: VeroColors.success.withOpacity(0.1))),
                  Container(width: 112, height: 112,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                          color: VeroColors.success.withOpacity(0.2))),
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, color: VeroColors.success,
                      boxShadow: [BoxShadow(color: VeroColors.success.withOpacity(0.4),
                          blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: const Icon(Icons.check_rounded, color: Colors.white, size: 38),
                  ),
                ]),
              ),
              const SizedBox(height: 24),

              Opacity(opacity: _fade.value, child: Column(children: [
                const Text('Cadastro Realizado!',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: VeroColors.text)),
                const SizedBox(height: 8),
                const Text('Bem-vinda à família Vero Cosméticos!\nSeu cadastro está sendo analisado.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: VeroColors.subtext, height: 1.5)),
                const SizedBox(height: 24),

                // Consultant card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: VeroColors.primary.withOpacity(0.10),
                          blurRadius: 10, offset: const Offset(0, 4))]),
                  child: Column(children: [
                    Row(children: [
                      CircleAvatar(
                        backgroundColor: VeroColors.primary,
                        radius: 22,
                        child: Text(c.firstName[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(c.name, style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold, color: VeroColors.text)),
                        Text(c.email, style: const TextStyle(fontSize: 12, color: VeroColors.subtext)),
                      ])),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: VeroColors.secondary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(c.status.label,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
                                color: VeroColors.secondary)),
                      ),
                    ]),
                    const Divider(height: 20),
                    Row(children: [
                      _infoChip(Icons.tag, 'Código', c.consultantCode),
                      const SizedBox(width: 12),
                      _infoChip(Icons.calendar_today_outlined, 'Cadastro',
                          DateFormat('dd/MM/yyyy').format(c.registrationDate)),
                    ]),
                  ]),
                ),
                const SizedBox(height: 20),

                // Next steps
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: VeroColors.primary.withOpacity(0.08),
                          blurRadius: 8, offset: const Offset(0, 3))]),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Próximos Passos',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: VeroColors.text)),
                    const SizedBox(height: 12),
                    ..._nextSteps.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          width: 26, height: 26,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: VeroColors.primary.withOpacity(0.12)),
                          child: Center(child: Text('${e.key + 1}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                                  color: VeroColors.primary))),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(e.value[0], style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600, color: VeroColors.text)),
                          Text(e.value[1], style: const TextStyle(
                              fontSize: 11, color: VeroColors.subtext)),
                        ])),
                      ]),
                    )),
                  ]),
                ),
                const SizedBox(height: 24),

                VeroButton(
                  title: 'Acessar Minha Conta',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {
                    context.read<AuthProvider>().setConsultant(c);
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const ConsultantDashboardScreen()),
                      (_) => false,
                    );
                  },
                ),
                const SizedBox(height: 12),
                VeroButton(
                  title: 'Compartilhar com Amigos',
                  icon: Icons.share_rounded,
                  style: VeroButtonStyle.outline,
                  onPressed: () {},
                ),
              ])),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, String value) => Expanded(
    child: Row(children: [
      Icon(icon, color: VeroColors.primary, size: 14),
      const SizedBox(width: 6),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 10, color: VeroColors.subtext)),
        Text(value, style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: VeroColors.text)),
      ]),
    ]),
  );

  static const _nextSteps = [
    ['Análise dos documentos', 'Nossa equipe analisará seus dados em até 2 dias úteis'],
    ['Ativação da conta', 'Você receberá um e-mail quando sua conta for ativada'],
    ['Primeiro pedido', 'Com a conta ativa, faça seu pedido com desconto de boas-vindas'],
    ['Início das vendas', 'Comece a vender e ganhar comissões!'],
  ];
}
