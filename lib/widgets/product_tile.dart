import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductTile extends StatelessWidget {
  const ProductTile(this.product, {super.key, this.onTap});
  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          product.thumbnail,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          // A broken image shows an icon, never a red error box
          errorBuilder: (context, error, stackTrace) =>
              const SizedBox(width: 56, height: 56, child: Icon(Icons.image_not_supported)),
        ),
      ),
      title: Text(product.title),
      subtitle: Text(
        '\$${product.price.toStringAsFixed(2)} · ★ ${product.rating.toStringAsFixed(1)}',
      ),
    );
  }
}