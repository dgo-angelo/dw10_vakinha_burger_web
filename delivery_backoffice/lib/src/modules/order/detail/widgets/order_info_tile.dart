import 'package:flutter/material.dart';

import '../../../../core/ui/styles/app_text_styles.dart';

class OrderInfoTile extends StatelessWidget {
  final String label;
  final String information;

  const OrderInfoTile({
    super.key,
    required this.label,
    required this.information,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: context.textStyles.textBold,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            information,
            style: context.textStyles.textMedium,
          ),
        ],
      ),
    );
  }
}
