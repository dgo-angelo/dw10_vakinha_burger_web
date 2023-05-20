import 'package:flutter/material.dart';

import '../../../core/ui/styles/app_text_styles.dart';
import '../../../core/ui/widgets/base_header.dart';
import '../../../models/orders/order_status.dart';
import '../order_controller.dart';

class OrderHeader extends StatefulWidget {
  final OrderController controller;

  const OrderHeader({
    super.key,
    required this.controller,
  });

  @override
  State<OrderHeader> createState() => _OrderHeaderState();
}

class _OrderHeaderState extends State<OrderHeader> {
  OrderStatus? statusSelected;
  @override
  Widget build(BuildContext context) {
    return BaseHeader(
      title: 'ADMINISTRAR PEDIDOS',
      addButton: false,
      filterWidget: DropdownButton<OrderStatus?>(
        value: statusSelected,
        onChanged: (value) {
          setState(() {
            widget.controller.changeStatusFilter(value);
            statusSelected = value;
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
          ...OrderStatus.values
              .map(
                (option) => DropdownMenuItem(
                  value: option,
                  child: Text(
                    option.name,
                    style: context.textStyles.textRegular,
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
