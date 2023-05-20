import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../core/ui/helpers/debouncer.dart';
import '../../../core/ui/helpers/loader.dart';
import '../../../core/ui/helpers/messages.dart';
import '../../../core/ui/widgets/base_header.dart';
import 'products_controller.dart';
import 'widgets/product_item.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> with Loader, Messages {
  final controller = Modular.get<ProductsController>();
  late final ReactionDisposer statusReactionDisposer;
  final debouncer = Debouncer(miliseconds: 500);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      statusReactionDisposer = reaction(
        (_) => controller.status,
        (status) async {
          switch (status) {
            case ProductsStateStatus.initial:
              break;
            case ProductsStateStatus.loading:
              showLoader();
              break;
            case ProductsStateStatus.loaded:
              hideLoader();
              break;
            case ProductsStateStatus.error:
              hideLoader();
              showError(controller.errorMessage ?? 'Erro ao buscar produtos');
              break;
            case ProductsStateStatus.addOrUpdateProduct:
              hideLoader();
              final productSelected = controller.productSelected;
              var uri = '/products/detail';

              if (productSelected != null) {
                uri += '?id=${productSelected.id}';
              }

              await Modular.to.pushNamed(uri);
              controller.loadProducts();
              break;
          }
        },
      );
      controller.loadProducts();
    });

    super.initState();
  }

  @override
  void dispose() {
    statusReactionDisposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.only(
        left: 40,
        top: 40,
        right: 40,
      ),
      child: Column(
        children: [
          BaseHeader(
            title: 'ADMINISTRAR PRODUTOS',
            buttonLabel: 'ADICIONAR',
            buttonPressed: controller.addProduct,
            searchChange: (value) {
              debouncer.call(() {
                controller.filterByName(value);
              });
            },
          ),
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: Observer(
              builder: (_) {
                final products = controller.products;
                return GridView.builder(
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisExtent: 280,
                    mainAxisSpacing: 20,
                    maxCrossAxisExtent: 280,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductItem(product: product);
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
