import 'package:flutter_modular/flutter_modular.dart';

import '../../core/rest_client/custom_dio.dart';
import '../../core/storage/session_storage.dart';
import '../../core/storage/storage.dart';
import '../../repositories/payment_type/payment_type_repository.dart';
import '../../repositories/payment_type/payment_type_repository_impl.dart';
import '../../repositories/products/products_repository.dart';
import '../../repositories/products/products_repository_impl.dart';
import '../../repositories/user/user_repository.dart';
import '../../repositories/user/user_repository_impl.dart';

class CoreModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton<Storage>(
          (i) => SessionStorage(),
          export: true,
        ),
        Bind.lazySingleton(
          (i) => CustomDio(i()),
          export: true,
        ),
        Bind.lazySingleton<PaymentTypeRepository>(
          (i) => PaymentTypeRepositoryImpl(dio: i()),
          export: true,
        ),
        Bind.lazySingleton<ProductsRepository>(
          (i) => ProductsRepositoryImpl(
            dio: i(),
          ),
          export: true,
        ),
        Bind.lazySingleton<UserRepository>(
          (i) => UserRepositoryImpl(
            dio: i(),
          ),
          export: true,
        ),
      ];
}
