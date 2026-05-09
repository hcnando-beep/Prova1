import 'package:flutter/material.dart';
import '../theme/vero_theme.dart';

enum VeroButtonStyle { primary, secondary, outline, ghost }

class VeroButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VeroButtonStyle style;
  final bool isLoading;
  final bool enabled;
  final VoidCallback? onPressed;

  const VeroButton({
    super.key,
    required this.title,
    this.icon,
    this.style = VeroButtonStyle.primary,
    this.isLoading = false,
    this.enabled = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = !enabled || isLoading;

    if (style == VeroButtonStyle.outline) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton(
          onPressed: disabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: VeroColors.primary,
            side: BorderSide(
                color: disabled ? VeroColors.border : VeroColors.primary, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _content(disabled ? VeroColors.border : VeroColors.primary),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled ? Colors.grey.shade300 : _bgColor,
          foregroundColor: disabled ? Colors.grey : _fgColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _content(disabled ? Colors.grey : _fgColor),
      ),
    );
  }

  Widget _content(Color color) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading) ...[
            SizedBox(
                width: 18, height: 18,
                child: CircularProgressIndicator(strokeWidth: 2.2, color: color)),
            const SizedBox(width: 10),
          ] else if (icon != null) ...[
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
          ],
          Text(title,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600, color: color)),
        ],
      );

  Color get _bgColor => switch (style) {
        VeroButtonStyle.secondary => VeroColors.secondary,
        VeroButtonStyle.ghost => VeroColors.primary.withOpacity(0.08),
        _ => VeroColors.primary,
      };

  Color get _fgColor => switch (style) {
        VeroButtonStyle.ghost => VeroColors.primary,
        _ => Colors.white,
      };
}
