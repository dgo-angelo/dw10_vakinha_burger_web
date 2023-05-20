import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/env/env.dart';
import '../../../../core/extensions/formatter_extensions.dart';
import '../../../../core/ui/styles/app_text_styles.dart';
import '../../../../models/product_model.dart';
import '../products_controller.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;

  const ProductItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: LayoutBuilder(
        builder: (_, constrains) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: constrains.maxHeight * .6,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    '${Env.instance.get('backend_base_url')}/${product.image}',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Tooltip(
                message: product.name,
                child: Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.textMedium,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(product.price.currencyPTBR),
                ),
                TextButton(
                  onPressed: () async {
                    final controller = context.read<ProductsController>();
                    controller.editProduct(product);
                  },
                  child: const Text('Editar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
