import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../dto/order/order_dto.dart';
import '../../models/orders/order_model.dart';
import '../../models/orders/order_status.dart';
import '../../repositories/order/order_repository.dart';
import '../../services/order/get_order_by_id.dart';

part 'order_controller.g.dart';

class OrderController = OrderControllerBase with _$OrderController;

enum OrderStateStatus {
  initial,
  loading,
  loaded,
  error,
  showDetailModal,
  statusChanged,
}

abstract class OrderControllerBase with Store {
  final GetOrderById _getOrderById;
  final OrderRepository _orderRepository;

  @readonly
  String? _errorMessage;

  @readonly
  var _status = OrderStateStatus.initial;

  late final DateTime _today;

  @readonly
  OrderStatus? _statusFilter;

  @readonly
  OrderDto? _orderSelected;

  @readonly
  var _orders = <OrderModel>[];

  OrderControllerBase({
    required OrderRepository orderRepository,
    required GetOrderById getOrderById,
  })  : _orderRepository = orderRepository,
        _getOrderById = getOrderById {
    final todayNow = DateTime.now();
    _today = DateTime(
      todayNow.year,
      todayNow.month,
      todayNow.day,
    );
  }

  @action
  void changeStatusFilter(OrderStatus? status) {
    _statusFilter = status;
    findOrders();
  }

  @action
  Future<void> findOrders() async {
    try {
      _status = OrderStateStatus.loading;
      _orders = await _orderRepository.findAllOrders(
        _today,
        _statusFilter,
      );
      _status = OrderStateStatus.loaded;
    } catch (e, s) {
      const message = 'Falha ao retornar pedidos';
      log(message, error: e, stackTrace: s);
      _errorMessage = message;
      _status = OrderStateStatus.error;
    }
  }

  @action
  Future<void> showDetailModel(OrderModel order) async {
    _status = OrderStateStatus.loading;
    _orderSelected = await _getOrderById(order);
    _status = OrderStateStatus.showDetailModal;
  }

  @action
  Future<void> chageStatus(OrderStatus status) async {
    _status = OrderStateStatus.loading;
    await _orderRepository.changeStatus(_orderSelected!.id, status);
    _status = OrderStateStatus.statusChanged;
  }
}
