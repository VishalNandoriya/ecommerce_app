import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout';

  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {

  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  String _name = '';
  String _address = '';
  String _city = '';
  String _postalCode = '';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: cartItems.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(cartItems[i].title),
                  trailing: Text(
                      '${cartItems[i].quantity} x \$${cartItems[i].price}'),
                ),
              ),
              const Divider(),
              Text('Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                  style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: _buildForm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Name'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
          onSaved: (value) {
            _name = value!;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Address'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your address';
            }
            return null;
          },
          onSaved: (value) {
            _address = value!;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'City'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your city';
            }
            return null;
          },
          onSaved: (value) {
            _city = value!;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Postal Code'),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your postal code';
            }
            if (value.length != 5) {
              return 'Postal code must be 5 digits';
            }
            return null;
          },
          onSaved: (value) {
            _postalCode = value!;
          },
        ),
        const SizedBox(height: 20),
        _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
          onPressed: _placeOrder,
          child: const Text('Place Order'),
        ),
      ],
    );
  }

  void _placeOrder() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    // Simulate API call for placing order
    Future.delayed(const Duration(seconds: 2)).then((_) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Clear the cart and navigate back to the product list screen
      Provider.of<CartProvider>(context, listen: false).clearCart();
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }
}
