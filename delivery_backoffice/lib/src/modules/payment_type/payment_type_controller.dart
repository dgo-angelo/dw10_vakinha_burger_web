import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../models/payment_type_model.dart';
import '../../repositories/payment_type/payment_type_repository.dart';

part 'payment_type_controller.g.dart';

enum PaymentTypeStateStatus {
  initial,
  loading,
  loaded,
  error,
  saved,
  addOrUpdatePayment
}

class PaymentTypeController = PaymentTypeControllerBase
    with _$PaymentTypeController;

abstract class PaymentTypeControllerBase with Store {
  final PaymentTypeRepository _paymentTypeRepository;

  @readonly
  var _status = PaymentTypeStateStatus.initial;

  @readonly
  var _paymentTypes = <PaymentTypeModel>[];

  @readonly
  String? _errorMessage;

  @readonly
  PaymentTypeModel? _paymentTypeSelected;

  @readonly
  bool? _filterEnable;

  PaymentTypeControllerBase({
    required PaymentTypeRepository paymentTypeRepository,
  }) : _paymentTypeRepository = paymentTypeRepository;

  @action
  void changeFilter(bool? enabled) => _filterEnable = enabled;

  @action
  Future<void> loadPayments() async {
    try {
      _status = PaymentTypeStateStatus.loading;
      _paymentTypes = await _paymentTypeRepository.findAll(_filterEnable);
      _status = PaymentTypeStateStatus.loaded;
    } catch (e, s) {
      const message = 'Erro ao carregar as formas de pagamento';
      log(message, error: e, stackTrace: s);
      _status = PaymentTypeStateStatus.error;
      _errorMessage = message;
    }
  }

  @action
  Future<void> addPayment() async {
    _status = PaymentTypeStateStatus.loading;
    await Future.delayed(Duration.zero);
    _paymentTypeSelected = null;
    _status = PaymentTypeStateStatus.addOrUpdatePayment;
  }

  @action
  Future<void> editPayment(PaymentTypeModel payment) async {
    _status = PaymentTypeStateStatus.loading;
    await Future.delayed(Duration.zero);
    _paymentTypeSelected = payment;
    _status = PaymentTypeStateStatus.addOrUpdatePayment;
  }

  @action
  Future<void> savePayment({
    int? id,
    required String name,
    required String acronym,
    required bool enabled,
  }) async {
    try {
      _status = PaymentTypeStateStatus.loading;
      await Future.delayed(Duration.zero);
      _paymentTypeSelected = null;

      final paymentTypeModel = PaymentTypeModel(
        name: name,
        acronym: acronym,
        enabled: enabled,
        id: id,
      );
      await _paymentTypeRepository.save(paymentTypeModel);
      _status = PaymentTypeStateStatus.saved;
    } catch (e, s) {
      const message = 'Erro ao adicionar forma de pagamento';
      log(message, error: e, stackTrace: s);
      _status = PaymentTypeStateStatus.error;
      _errorMessage = message;
    }
  }
}
