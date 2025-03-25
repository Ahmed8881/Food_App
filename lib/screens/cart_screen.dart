import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/checkout_modal.dart';
import '../widgets/order_success_modal.dart';
import '../theme/app_theme.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isCheckingOut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              if (appProvider.cartItems.isNotEmpty) {
                return IconButton(
                  onPressed: () {
                    _showClearCartConfirmation(context);
                  },
                  icon: const Icon(Icons.delete_sweep),
                  tooltip: 'Clear Cart',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: '/cart',
        onNavigate: (route) {
          Navigator.pop(context); // Close drawer
          if (route != '/cart') {
            Navigator.pushNamed(context, route);
          }
        },
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          final cartItems = appProvider.cartItems;

          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add items from the menu or create your own recipe',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/menu');
                    },
                    icon: const Icon(Icons.restaurant_menu),
                    label: const Text('Browse Menu'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];

                    return CartItemCard(
                      cartItem: cartItem,
                      onIncrease: (id) {
                        appProvider.updateQuantity(id, cartItem.quantity + 1);
                      },
                      onDecrease: (id) {
                        if (cartItem.quantity > 1) {
                          appProvider.updateQuantity(id, cartItem.quantity - 1);
                        } else {
                          appProvider.removeFromCart(id);
                        }
                      },
                      onRemove: (id) {
                        appProvider.removeFromCart(id);
                      },
                    );
                  },
                ),
              ),

              // Order summary and checkout button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal', style: TextStyle(fontSize: 16)),
                        Text(
                          '\$${appProvider.getCartTotal().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery', style: TextStyle(fontSize: 16)),
                        const Text(
                          '\$2.99',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${(appProvider.getCartTotal() + 2.99).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _showCheckoutModal(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Proceed to Checkout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showClearCartConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear Cart'),
          content: const Text(
            'Are you sure you want to remove all items from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final appProvider = Provider.of<AppProvider>(
                  context,
                  listen: false,
                );
                appProvider.clearCart();
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _showCheckoutModal(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final total = appProvider.getCartTotal() + 2.99; // Adding delivery fee

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: CheckoutModal(
            total: total,
            isLoading: _isCheckingOut,
            onCheckout: (address, phone, paymentMethod) async {
              setState(() {
                _isCheckingOut = true;
              });

              // Close checkout modal
              Navigator.pop(context);

              // Create order
              final order = appProvider.createOrder(
                address: address,
                phone: phone,
                paymentMethod: paymentMethod,
              );

              setState(() {
                _isCheckingOut = false;
              });

              if (order != null) {
                // Show success modal
                if (context.mounted) {
                  _showOrderSuccessModal(context, order.orderNumber);
                }
              }
            },
            onClose: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _showOrderSuccessModal(BuildContext context, String orderNumber) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return OrderSuccessModal(
          orderNumber: orderNumber,
          onClose: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/orders');
          },
        );
      },
    );
  }
}
