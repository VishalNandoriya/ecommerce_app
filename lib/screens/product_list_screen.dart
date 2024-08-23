import 'package:ecommerce_app/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          _buildCartIcon(context),
        ],
      ),
      body: SafeArea(
        child: _buildProductGrid(context),
      ),
    );
  }

  Widget _buildCartIcon(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (ctx, cart, _) {
        final cartItemCount = cart.items.length;
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
            if (cartItemCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Text(
                    cartItemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (ctx, productProvider, _) {
        return FutureBuilder(
          future: productProvider.fetchProducts(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading products'));
            } else {
              return _buildList(context, productProvider);
            }
          },
        );
      },
    );
  }

  Widget _buildList(BuildContext context, ProductProvider productProvider) {
    return GridView.builder(
      padding: const EdgeInsets.all(4.0),
      itemCount: productProvider.products.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 4.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        var product = productProvider.products[index];
        return SizedBox(
          height: 250, // Fixed height for consistency
          child: GestureDetector(
            onTap: () {
              // Handle product tap
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product,
              );
            },
            child: ProductItem(product),
          ),
        );
      },
    );
  }
}
