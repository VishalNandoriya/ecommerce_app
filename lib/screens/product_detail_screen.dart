import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 300,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: product.thumbnail,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  product.description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildAddItem(context, product),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddItem(BuildContext context, Product product) {
    return Consumer<CartProvider>(
      builder: (ctx, cart, _) {
        if (!cart.items.keys.contains(product.id)) {
          return ElevatedButton(
            onPressed: () {
              cart.updateItem(product.id, product.title, product.price);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added ${product.title} to the cart!'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Add to Cart'),
          );
        } else {
          return ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
            child: const Text('Go to Cart'),
          );
        }
      },
    );
  }
}
