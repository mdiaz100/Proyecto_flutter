import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';

class ProductItemWidget extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;

  const ProductItemWidget({super.key,  required this.product, this.onTap });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: product.thumbnail.isNotEmpty
          ? Image.network(product.thumbnail, width: 50, height: 50, fit: BoxFit.cover)
          : null,
      title: Text(product.title),
      subtitle: Text("\$${product.price.toString()}"),
      onTap: onTap,
    );
  }
}
