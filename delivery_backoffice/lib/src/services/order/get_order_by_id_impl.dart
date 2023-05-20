import '../../dto/order/order_dto.dart';
import '../../dto/order/order_product_dto.dart';
import '../../models/orders/order_model.dart';
import '../../models/payment_type_model.dart';
import '../../models/user_model.dart';
import '../../repositories/payment_type/payment_type_repository.dart';
import '../../repositories/products/products_repository.dart';
import '../../repositories/user/user_repository.dart';
import 'get_order_by_id.dart';

class GetOrderByIdImpl implements GetOrderById {
  final PaymentTypeRepository _paymentTypeRepository;
  final UserRepository _userRepository;
  final ProductsRepository _productsRepository;

  GetOrderByIdImpl({
    required PaymentTypeRepository paymentTypeRepository,
    required UserRepository userRepository,
    required ProductsRepository productsRepository,
  })  : _paymentTypeRepository = paymentTypeRepository,
        _userRepository = userRepository,
        _productsRepository = productsRepository;

  @override
  Future<OrderDto> call(OrderModel order) => _orderDtoParse(order);

  Future<OrderDto> _orderDtoParse(OrderModel order) async {
    final paymentTypeFuture =
        _paymentTypeRepository.getById(order.paymentMethodId);
    final userFuture = _userRepository.getById(order.userId);
    final orderProductsFuture = _orderProductParse(order);
    final responses = await Future.wait(
      [
        paymentTypeFuture,
        userFuture,
        orderProductsFuture,
      ],
    );

    final paymentResponse = responses[0] as PaymentTypeModel;
    final userResponse = responses[1] as UserModel;
    final orderProductsResponse = responses[2] as List<OrderProductDto>;

    return OrderDto(
      id: order.id,
      date: order.date,
      status: order.status,
      paymentTypeModel: paymentResponse,
      user: userResponse,
      orderProducts: orderProductsResponse,
      address: order.address,
      cpf: order.cpf,
    );
  }

  Future<List<OrderProductDto>> _orderProductParse(OrderModel order) async {
    final orderProducts = <OrderProductDto>[];
    final productsFuture = order.orderProducts
        .map(
          (product) => _productsRepository.getProduct(product.productId),
        )
        .toList();
    final products = await Future.wait(productsFuture);

    for (var i = 0; i < order.orderProducts.length; i++) {
      final orderProduct = order.orderProducts[i];
      final productDto = OrderProductDto(
        product: products[i],
        amount: orderProduct.amount,
        totalPrice: orderProduct.totalPrice,
      );

      orderProducts.add(productDto);
    }
    return orderProducts;
  }
}
