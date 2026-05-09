import 'package:flutter/material.dart';
import '../theme/vero_theme.dart';

class VeroPickerField extends StatelessWidget {
  final String label;
  final List<String> options;
  final String value;
  final String placeholder;
  final ValueChanged<String> onChanged;

  const VeroPickerField({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    this.placeholder = 'Selecione...',
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: VeroColors.primary)),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () => _showSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: VeroColors.border, width: 1.5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.isEmpty ? placeholder : value,
                    style: TextStyle(
                        fontSize: 15,
                        color: value.isEmpty
                            ? VeroColors.subtext.withOpacity(0.6)
                            : VeroColors.text),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: VeroColors.primary, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, ctrl) => Column(
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  color: VeroColors.border, borderRadius: BorderRadius.circular(2)),
            ),
            Text(label,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: VeroColors.text)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: ctrl,
                itemCount: options.length,
                itemBuilder: (_, i) => ListTile(
                  title: Text(options[i]),
                  trailing: options[i] == value
                      ? const Icon(Icons.check, color: VeroColors.primary)
                      : null,
                  onTap: () {
                    onChanged(options[i]);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
