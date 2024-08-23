import 'package:flutter/material.dart';
import '../models/cart.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  void updateItem(String productId, String title, double price, {bool isAdding = true}) {
    if (_items.containsKey(productId)) {
      if (isAdding) {
        // Increase quantity if item is already in cart
        _items.update(
          productId,
              (existingItem) => CartItem(
            id: existingItem.id,
            title: existingItem.title,
            price: existingItem.price,
            quantity: existingItem.quantity + 1,
          ),
        );
      } else {
        // Decrease quantity if the item is already in the cart
        if (_items[productId]!.quantity > 1) {
          _items.update(
            productId,
                (existingItem) => CartItem(
              id: existingItem.id,
              title: existingItem.title,
              price: existingItem.price,
              quantity: existingItem.quantity - 1,
            ),
          );
        } else {
          _items.remove(productId); // Remove the item if quantity reaches zero
        }
      }
    } else {
      if (isAdding) {
        // Add new item to cart
        _items.putIfAbsent(
          productId,
              () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1,
          ),
        );
      }
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
