import 'package:flutter_modular/flutter_modular.dart';

import '../../repositories/order/order_repository.dart';
import '../../repositories/order/order_repository_impl.dart';
import '../../services/order/get_order_by_id.dart';
import '../../services/order/get_order_by_id_impl.dart';
import 'order_controller.dart';
import 'order_page.dart';

class OrderModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton<OrderRepository>(
          (i) => OrderRepositoryImpl(
            dio: i(),
          ),
        ),
        Bind.lazySingleton<GetOrderById>(
          (i) => GetOrderByIdImpl(
            paymentTypeRepository: i(),
            productsRepository: i(),
            userRepository: i(),
          ),
        ),
        Bind.lazySingleton<OrderController>(
          (i) => OrderController(
            orderRepository: i(),
            getOrderById: i(),
          ),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => const OrderPage(),
        )
      ];
}
