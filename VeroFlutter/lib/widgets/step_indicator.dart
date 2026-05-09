import 'package:flutter/material.dart';
import '../theme/vero_theme.dart';

class StepIndicator extends StatelessWidget {
  final List<String> steps;
  final List<IconData> icons;
  final int currentStep;

  const StepIndicator({
    super.key,
    required this.steps,
    required this.icons,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (idx) {
          if (idx.isOdd) {
            final done = idx ~/ 2 < currentStep;
            return Expanded(
              child: Container(height: 2, color: done ? VeroColors.primary : VeroColors.border),
            );
          }
          final i = idx ~/ 2;
          final state = i < currentStep ? _S.done : i == currentStep ? _S.active : _S.upcoming;
          return _Dot(icon: icons[i], label: steps[i], state: state);
        }),
      ),
    );
  }
}

enum _S { done, active, upcoming }

class _Dot extends StatelessWidget {
  final IconData icon;
  final String label;
  final _S state;
  const _Dot({required this.icon, required this.label, required this.state});

  @override
  Widget build(BuildContext context) {
    final active = state != _S.upcoming;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? VeroColors.primary : VeroColors.border.withOpacity(0.6),
            boxShadow: state == _S.active
                ? [BoxShadow(color: VeroColors.primary.withOpacity(0.4), blurRadius: 7, offset: const Offset(0, 3))]
                : null,
          ),
          child: Icon(
            state == _S.done ? Icons.check : icon,
            size: 16,
            color: active ? Colors.white : VeroColors.subtext,
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: active ? VeroColors.primary : VeroColors.subtext)),
      ],
    );
  }
}
