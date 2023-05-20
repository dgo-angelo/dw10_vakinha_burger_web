import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../core/ui/helpers/loader.dart';
import '../../core/ui/helpers/messages.dart';
import 'payment_type_controller.dart';
import 'widgets/payment_type_form/payment_type_form_modal.dart';
import 'widgets/payment_type_header.dart';
import 'widgets/payment_type_item.dart';

class PaymentTypePage extends StatefulWidget {
  const PaymentTypePage({super.key});

  @override
  State<PaymentTypePage> createState() => _PaymentTypePageState();
}

class _PaymentTypePageState extends State<PaymentTypePage>
    with Loader, Messages {
  final controller = Modular.get<PaymentTypeController>();
  final disposers = <ReactionDisposer>[];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filterDisposer = reaction((_) => controller.filterEnable, (filter) {
        controller.loadPayments();
      });

      final statusReactionDisposer = reaction(
        (_) => controller.status,
        (status) {
          switch (status) {
            case PaymentTypeStateStatus.initial:
              break;
            case PaymentTypeStateStatus.loading:
              showLoader();
              break;
            case PaymentTypeStateStatus.loaded:
              hideLoader();
              break;
            case PaymentTypeStateStatus.error:
              hideLoader();
              showError(
                controller.errorMessage ?? 'Erro ao buscar formas de pagamento',
              );
              break;
            case PaymentTypeStateStatus.addOrUpdatePayment:
              hideLoader();
              _showAddOrUpdatePayment();
              break;
            case PaymentTypeStateStatus.saved:
              hideLoader();
              Navigator.of(context, rootNavigator: true).pop();
              controller.loadPayments();
              showSuccess('Forma de pagamento incluída com sucesso');
              break;
          }
        },
      );
      controller.loadPayments();
      disposers.addAll([statusReactionDisposer, filterDisposer]);
    });

    super.initState();
  }

  @override
  void dispose() {
    for (var disposer in disposers) {
      disposer();
    }
    super.dispose();
  }

  void _showAddOrUpdatePayment() {
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.black26,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.white,
            elevation: 10,
            child: PaymentTypeFormModal(
              model: controller.paymentTypeSelected,
              controller: controller,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 40,
        top: 40,
        right: 40,
      ),
      color: Colors.grey[50],
      child: Column(
        children: [
          PaymentTypeHeader(
            controller: controller,
          ),
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: Observer(
              builder: (_) {
                final paymentTypes = controller.paymentTypes;
                return GridView.builder(
                  itemCount: paymentTypes.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisExtent: 120,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 10,
                    maxCrossAxisExtent: 680,
                  ),
                  itemBuilder: (context, index) {
                    final paymentTypeModel = paymentTypes[index];
                    return PaymentTypeItem(
                      payment: paymentTypeModel,
                      controller: controller,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
