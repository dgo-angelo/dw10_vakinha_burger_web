import 'package:flutter/material.dart';

import '../../../core/ui/styles/app_text_styles.dart';
import '../../../core/ui/widgets/base_header.dart';
import '../payment_type_controller.dart';

class PaymentTypeHeader extends StatefulWidget {
  final PaymentTypeController controller;

  const PaymentTypeHeader({
    super.key,
    required this.controller,
  });

  @override
  State<PaymentTypeHeader> createState() => _PaymentTypeHeaderState();
}

class _PaymentTypeHeaderState extends State<PaymentTypeHeader> {
  bool? enabled;

  @override
  Widget build(BuildContext context) {
    return BaseHeader(
      title: 'ADMINISTRAR FORMAS DE PAGAMENTO',
      addButton: true,
      buttonLabel: 'ADICIONAR',
      buttonPressed: () {
        widget.controller.addPayment();
      },
      filterWidget: DropdownButton<bool>(
        value: enabled,
        onChanged: (value) {
          setState(() {
            enabled = value;
            widget.controller.changeFilter(value);
          });
        },
        items: [
          DropdownMenuItem(
            value: null,
            child: Text(
              'Todos',
              style: context.textStyles.textRegular,
            ),
          ),
          DropdownMenuItem(
            value: true,
            child: Text(
              'Ativos',
              style: context.textStyles.textRegular,
            ),
          ),
          DropdownMenuItem(
            value: false,
            child: Text(
              'Inativos',
              style: context.textStyles.textRegular,
            ),
          ),
        ],
      ),
    );
  }
}
