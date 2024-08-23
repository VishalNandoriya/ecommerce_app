import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final String productId;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cart.removeItem(productId);
      },
      child: _buildCard(context, cart),
    );
  }

  Widget _buildCard(BuildContext context, CartProvider cart) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                child: Text('\$${cartItem.price}'),
              ),
            ),
          ),
          title: Text(cartItem.title),
          subtitle: Text(
              'Total: \$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}'),
          trailing: SizedBox(
            width: 120,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    cart.updateItem(productId, cartItem.title, cartItem.price,
                        isAdding: false);
                  },
                ),
                Text('${cartItem.quantity}'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    cart.updateItem(
                        productId, cartItem.title, cartItem.price);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
