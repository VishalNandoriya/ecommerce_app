import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Hero(
                transitionOnUserGestures: true,
                tag: product.id,
                child: CachedNetworkImage(
                  imageUrl: product.thumbnail,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium),
          Row(
            children: [
              Text("\$${product.price.toString()}",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              Expanded(
                child: Container(),
              ),
              _buildAddItem(context),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAddItem(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (ctx, cart, _) {
        if (!cart.items.keys.contains(product.id)) {
          return IconButton(
              icon: const Icon(Icons.add),
              color: Colors.black,
              iconSize: 25,
              onPressed: () {
                cart.updateItem(product.id, product.title, product.price,
                    isAdding: true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added ${product.title} to the cart!'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              });
        } else {
          return IconButton(
              icon: const Icon(Icons.shopping_cart),
              color: Colors.black,
              iconSize: 25,
              onPressed: () {
                Navigator.of(context).pushNamed('/cart');
              });
        }
      },
    );
  }
}
