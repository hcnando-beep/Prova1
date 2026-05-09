import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/vero_theme.dart';
import '../widgets/vero_text_field.dart';
import '../widgets/vero_button.dart';
import 'registration/registration_screen.dart';
import 'dashboard/consultant_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _showPassword  = false;

  bool get _ready => _emailCtrl.text.isNotEmpty && _passwordCtrl.text.length >= 6;

  @override
  void dispose() { _emailCtrl.dispose(); _passwordCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            const SizedBox(height: 48),
            _header(),
            const SizedBox(height: 36),
            _form(context),
            const SizedBox(height: 24),
            _divider(),
            const SizedBox(height: 24),
            _registerSection(),
            const SizedBox(height: 40),
          ]),
        ),
      ),
    );
  }

  Widget _header() => Column(children: [
    Container(
      width: 112, height: 112,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [VeroColors.gradientStart, VeroColors.gradientEnd],
          begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(
          color: VeroColors.primary.withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('VERO', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900,
            color: Colors.white, letterSpacing: 2)),
        Text('COSMÉTICOS', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold,
            color: Colors.white, letterSpacing: 4)),
      ]),
    ),
    const SizedBox(height: 20),
    const Text('Bem-vinda de volta!',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: VeroColors.text)),
    const SizedBox(height: 6),
    const Text('Acesse sua conta de consultora',
        style: TextStyle(fontSize: 14, color: VeroColors.subtext)),
  ]);

  Widget _form(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      VeroTextField(
        label: 'E-mail', hint: 'seu@email.com',
        controller: _emailCtrl,
        keyboardType: TextInputType.emailAddress,
        textCapitalization: TextCapitalization.none,
        onChanged: (_) => setState(() {}),
      ),
      const SizedBox(height: 16),
      VeroTextField(
        label: 'Senha', hint: 'Mínimo 6 caracteres',
        controller: _passwordCtrl,
        obscureText: !_showPassword,
        textCapitalization: TextCapitalization.none,
        onChanged: (_) => setState(() {}),
        suffixIcon: IconButton(
          icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility,
              color: VeroColors.primary),
          onPressed: () => setState(() => _showPassword = !_showPassword),
        ),
      ),
      const SizedBox(height: 6),
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {},
          child: const Text('Esqueci minha senha',
              style: TextStyle(color: VeroColors.primary, fontSize: 12)),
        ),
      ),
      if (auth.errorMessage != null) ...[
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: VeroColors.error.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            const Icon(Icons.error_outline, color: VeroColors.error, size: 16),
            const SizedBox(width: 8),
            Expanded(child: Text(auth.errorMessage!,
                style: const TextStyle(color: VeroColors.error, fontSize: 12))),
          ]),
        ),
      ],
      const SizedBox(height: 20),
      VeroButton(
        title: 'Entrar',
        icon: Icons.arrow_forward_rounded,
        isLoading: auth.isLoading,
        enabled: _ready && !auth.isLoading,
        onPressed: () async {
          await auth.login(_emailCtrl.text.trim(), _passwordCtrl.text);
          if (mounted && auth.isAuthenticated) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ConsultantDashboardScreen()));
          }
        },
      ),
    ]);
  }

  Widget _divider() => Row(children: [
    const Expanded(child: Divider(color: VeroColors.border)),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text('ou', style: TextStyle(color: VeroColors.subtext.withOpacity(0.8), fontSize: 12)),
    ),
    const Expanded(child: Divider(color: VeroColors.border)),
  ]);

  Widget _registerSection() => Column(children: [
    VeroButton(
      title: 'Quero ser consultora Vero',
      icon: Icons.star_rounded,
      style: VeroButtonStyle.outline,
      onPressed: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const RegistrationScreen())),
    ),
    const SizedBox(height: 12),
    const Text('Comece sua jornada e transforme sua vida!',
        style: TextStyle(fontSize: 12, color: VeroColors.subtext),
        textAlign: TextAlign.center),
  ]);
}
