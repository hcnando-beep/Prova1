import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/registration_provider.dart';
import '../../theme/vero_theme.dart';
import '../../widgets/step_indicator.dart';
import '../../widgets/vero_button.dart';
import 'step1_personal_info.dart';
import 'step2_contact.dart';
import 'step3_address.dart';
import 'step4_professional.dart';
import 'step5_documents.dart';
import 'step6_confirmation.dart';
import 'registration_success_screen.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => RegistrationProvider(),
        child: const _Content(),
      );
}

class _Content extends StatefulWidget {
  const _Content();
  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final _pageCtrl = PageController();

  @override
  void dispose() { _pageCtrl.dispose(); super.dispose(); }

  void _goTo(int step) => _pageCtrl.animateToPage(
    step, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

  Future<void> _handleNext(RegistrationProvider reg) async {
    if (!reg.canAdvance) return;
    if (reg.currentStep < 5) {
      reg.next();
      _goTo(reg.currentStep);
    } else {
      await reg.submit();
      if (mounted && reg.isRegistered) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => RegistrationSuccessScreen(consultant: reg.registeredConsultant!),
        ));
      }
    }
  }

  void _handleBack(RegistrationProvider reg) {
    if (reg.currentStep > 0) { reg.back(); _goTo(reg.currentStep); }
    else { Navigator.of(context).pop(); }
  }

  @override
  Widget build(BuildContext context) {
    final reg = context.watch<RegistrationProvider>();
    return Scaffold(
      backgroundColor: VeroColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(reg.currentStep == 0 ? Icons.close : Icons.arrow_back_ios_new),
          onPressed: () => _handleBack(reg),
        ),
        title: Text(reg.navigationTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(74),
          child: Column(children: [
            StepIndicator(
              steps: RegistrationProvider.stepTitles,
              icons: RegistrationProvider.stepIcons,
              currentStep: reg.currentStep,
            ),
            const SizedBox(height: 6),
          ]),
        ),
      ),
      body: Column(children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Passo ${reg.currentStep + 1} de 6',
                style: const TextStyle(fontSize: 12, color: VeroColors.subtext)),
            Text('${((reg.currentStep + 1) / 6 * 100).round()}% concluído',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                    color: VeroColors.primary)),
          ]),
        ),
        const Divider(height: 1),
        Expanded(
          child: PageView(
            controller: _pageCtrl,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              Step1PersonalInfo(),
              Step2Contact(),
              Step3Address(),
              Step4Professional(),
              Step5Documents(),
              Step6Confirmation(),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: VeroColors.border))),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: VeroButton(
            title: reg.currentStep < 5 ? 'Continuar' : 'Finalizar Cadastro',
            icon: reg.currentStep < 5 ? Icons.arrow_forward : Icons.check_circle_rounded,
            style: reg.currentStep < 5 ? VeroButtonStyle.primary : VeroButtonStyle.secondary,
            enabled: reg.canAdvance,
            isLoading: reg.isLoading,
            onPressed: () => _handleNext(reg),
          ),
        ),
      ]),
    );
  }
}
